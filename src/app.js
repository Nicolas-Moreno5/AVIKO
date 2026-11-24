const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const path = require('path');
const pool = require('./config/db'); 
const { procesarMensajeIA } = require('./controllers/iaController'); 
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.use(express.static(path.join(__dirname, 'public')));

// Memoria temporal de chats activos: { socketId: { id, nombre, telefono, mensajes: [] } }
const sesionesActivas = {};

io.on('connection', (socket) => {
    console.log('🌐 Nueva conexión (ID:', socket.id, ')');

    // Si es el administrador conectándose, le enviamos todas las conversaciones actuales
    socket.on('admin_conectado', () => {
        socket.emit('lista_sesiones', sesionesActivas);
    });

    // 1. Registro del cliente
    socket.on('registrar_usuario', async (datos) => {
        try {
            const { nombre, apellido, telefono, ubicacion, direccion } = datos;
            const nombreCompleto = `${nombre} ${apellido}`;
            
            const clienteExistente = await pool.query('SELECT * FROM CLIENTES WHERE numero_contacto = $1', [telefono]);
            
            if (clienteExistente.rows.length === 0) {
                await pool.query(
                    `INSERT INTO CLIENTES (nombre, numero_contacto, ubicacion, direccion, tipo_inmueble, tipo_cliente) 
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [nombreCompleto, telefono, ubicacion || 'Pendiente', direccion || 'Pendiente', 'Pendiente', 'Nuevo Prospecto (Web)']
                );
                console.log(`✅ Nuevo cliente registrado: ${nombreCompleto} (${telefono}) - ${ubicacion}, ${direccion}`);
            } else {
                await pool.query(
                    `UPDATE CLIENTES SET ubicacion = $1, direccion = $2 WHERE numero_contacto = $3`,
                    [ubicacion || 'Pendiente', direccion || 'Pendiente', telefono]
                );
                console.log(`🔄 Cliente Web recurrente actualizado: ${nombreCompleto} (${ubicacion})`);
            }

            sesionesActivas[socket.id] = {
                id: socket.id,
                nombre: nombreCompleto,
                telefono: telefono,
                mensajes: []
            };
            io.emit('lista_sesiones', sesionesActivas);
            
            socket.emit('registro_exitoso', nombre);
        } catch (error) {
            console.error("❌ Error en BD:", error);
        }
    });

    // 2. Mensaje del cliente
    socket.on('chat message', async (msg) => {
        if (!sesionesActivas[socket.id]) {
            sesionesActivas[socket.id] = { id: socket.id, nombre: 'Cliente Web', telefono: 'N/A', mensajes: [] };
        }

        // Guardamos el mensaje del cliente y avisamos al admin
        sesionesActivas[socket.id].mensajes.push({ remitente: 'cliente', texto: msg });
        io.emit('actualizar_chat', { userId: socket.id, sesion: sesionesActivas[socket.id] });

        // Cámbiala por esta línea:
        const respuestaIA = await procesarMensajeIA(sesionesActivas[socket.id].mensajes, sesionesActivas[socket.id].telefono);
        
        // Guardamos la respuesta de la IA y avisamos al cliente y al admin
        sesionesActivas[socket.id].mensajes.push({ remitente: 'bot', texto: respuestaIA });
        socket.emit('bot message', respuestaIA);
        io.emit('actualizar_chat', { userId: socket.id, sesion: sesionesActivas[socket.id] });
    });

    // 3. Respuesta manual del administrador
    socket.on('admin_responde', (datos) => {
        const { userId, texto } = datos;
        if (sesionesActivas[userId]) {
            sesionesActivas[userId].mensajes.push({ remitente: 'admin', texto: texto });
            io.to(userId).emit('bot message', `👨‍💻 Asesor Humano: ${texto}`);
            io.emit('actualizar_chat', { userId: userId, sesion: sesionesActivas[userId] });
        }
    });

    // 4. Consultar perfil e historial de visitas del cliente
    socket.on('obtener_perfil_historial', async () => {
        const sesion = sesionesActivas[socket.id];
        if (!sesion) return;

        try {
            const clienteRes = await pool.query(
                'SELECT nombre, numero_contacto, ubicacion, direccion, tipo_inmueble FROM CLIENTES WHERE numero_contacto = $1',
                [sesion.telefono]
            );
            const visitasRes = await pool.query(
                'SELECT id, tipo_plaga, tecnico_asignado, fecha_hora_programada, direccion, estado FROM visitas_tecnicas WHERE telefono_cliente = $1 ORDER BY fecha_registro DESC',
                [sesion.telefono]
            );

            socket.emit('datos_perfil_historial', {
                perfil: clienteRes.rows[0] || null,
                visitas: visitasRes.rows
            });
        } catch (error) {
            console.error("❌ Error consultando perfil/historial:", error);
        }
    });

    // 5. Actualizar datos del cliente desde el modal de perfil
    socket.on('actualizar_perfil_cliente', async (datos) => {
        const sesion = sesionesActivas[socket.id];
        if (!sesion) return;

        try {
            const { nombre, ubicacion, direccion, tipo_inmueble } = datos;
            await pool.query(
                'UPDATE CLIENTES SET nombre = $1, ubicacion = $2, direccion = $3, tipo_inmueble = $4 WHERE numero_contacto = $5',
                [nombre, ubicacion, direccion, tipo_inmueble, sesion.telefono]
            );
            sesion.nombre = nombre;
            io.emit('lista_sesiones', sesionesActivas);
            socket.emit('perfil_actualizado', '✅ Tus datos han sido actualizados correctamente.');
            console.log(`✏️ Perfil actualizado desde el modal: ${nombre} (${sesion.telefono})`);
        } catch (error) {
            console.error("❌ Error actualizando perfil:", error);
        }
    });

    socket.on('disconnect', () => {
        if (sesionesActivas[socket.id]) {
            delete sesionesActivas[socket.id];
            io.emit('lista_sesiones', sesionesActivas);
        }
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`✅ Servidor web listo en el puerto ${PORT}`);
});