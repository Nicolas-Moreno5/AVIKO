const Groq = require('groq-sdk');
const pool = require('../config/db');
require('dotenv').config();

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

async function obtenerContextoBD(telefonoCliente) {
    let listaTecnicos = "1. Ing. Carlos Mendoza (Roedores)\n2. Téc. Laura Rodríguez (Cucarachas e Insectos)\n3. Téc. Andrés Silva (Preventivo y Tanques)";
    let perfilTexto = "Cliente sin datos adicionales registrados.";
    let historialTexto = "No tiene visitas ni servicios registrados aún.";

    try {
        const tecnicosRes = await pool.query('SELECT nombre, especialidad, zona_asignada, disponibilidad FROM tecnicos');
        if (tecnicosRes.rows.length > 0) {
            listaTecnicos = tecnicosRes.rows.map((t, index) => 
                `${index + 1}. ${t.nombre} | Especialidad: ${t.especialidad} | Zonas: ${t.zona_asignada} | Horario: ${t.disponibilidad}`
            ).join('\n');
        }

        if (telefonoCliente) {
            const clienteRes = await pool.query(
                'SELECT nombre, numero_contacto, ubicacion, direccion, tipo_inmueble, tipo_cliente FROM CLIENTES WHERE numero_contacto = $1',
                [telefonoCliente]
            );
            if (clienteRes.rows.length > 0) {
                const c = clienteRes.rows[0];
                perfilTexto = `Nombre: ${c.nombre} | Teléfono: ${c.numero_contacto} | Ubicación: ${c.ubicacion} | Dirección: ${c.direccion} | Tipo de inmueble: ${c.tipo_inmueble} | Tipo de cliente: ${c.tipo_cliente}`;
            }

            const visitasRes = await pool.query(
                'SELECT id, tipo_plaga, tecnico_asignado, fecha_hora_programada, direccion, estado FROM visitas_tecnicas WHERE telefono_cliente = $1 ORDER BY fecha_registro DESC',
                [telefonoCliente]
            );
            if (visitasRes.rows.length > 0) {
                historialTexto = visitasRes.rows.map(v => 
                    `- Visita #${v.id} | Plaga/Servicio: ${v.tipo_plaga} | Técnico: ${v.tecnico_asignado} | Fecha: ${v.fecha_hora_programada} | Dirección: ${v.direccion} | Estado: ${v.estado}`
                ).join('\n');
            }
        }
    } catch (error) {
        console.error("⚠️ Error cargando contexto de BD:", error.message);
    }

    return { listaTecnicos, perfilTexto, historialTexto };
}

async function procesarMensajeIA(historialMensajes, telefonoCliente) {
    try {
        const { listaTecnicos, perfilTexto, historialTexto } = await obtenerContextoBD(telefonoCliente);

        const instruccionesSistema = `
Eres AVIKO, el Asistente Virtual Inteligente de Fumigaciones K.O. (Oficina: Cra. 39 A # 2B-38, Bogotá).
Horario de atención: Lunes a sábado, de 8:00 a.m. a 6:00 p.m.

DATOS ACTUALES DEL CLIENTE CON EL QUE HABLAS:
${perfilTexto}

HISTORIAL DE VISITAS Y SERVICIOS DEL CLIENTE:
${historialTexto}
* Si el cliente pregunta por sus datos personales o su historial de visitas/transacciones, muéstrale esta información de forma clara y ordenada.
* Si el cliente quiere modificar algún dato (nombre, ubicación, dirección o tipo de inmueble), confírmale el cambio y usa el comando interno [ACTUALIZAR_DATOS|...].

CATÁLOGO DE SERVICIOS Y RANGOS ESTIMADOS DE PRECIOS (Mercado Bogotá, COP):
1. Fumigación de Cucarachas (bajo olor, eco-amigable): $90.000 – $150.000 COP (hogares) | $160.000 – $280.000 COP (comercios).
2. Control de Roedores (mapeo de madrigueras, cebado estratégico y monitoreo): $140.000 – $260.000 COP.
3. Fumigación de Insectos (hormigas, zancudos, moscas, pulgas, chinches, garrapatas): $100.000 – $170.000 COP.
4. Control Preventivo de Plagas (planes mensuales/trimestrales con certificado): $150.000 – $320.000 COP.
5. Curso de Manipulación de Alimentos (avalado Secretaría de Salud): $50.000 – $70.000 COP por persona.
6. Limpieza y Desinfección de Tanques (Resolución 0082 de 2009): $180.000 – $380.000 COP según capacidad.
* REGLA DE COTIZACIÓN: Entrega el rango estimado aclarando siempre que es preliminar y sujeto al diagnóstico técnico.

COBERTURA OFICIAL:
- Bogotá: Chapinero, Usaquén, Suba, Engativá, Fontibón, Kennedy, Teusaquillo, Barrios Unidos, Puente Aranda, Bosa, Ciudad Bolívar y San Cristóbal.
- Cundinamarca: Chía, Cajicá, Zipaquirá, Cota, Soacha, Mosquera, Funza, Madrid (Cundinamarca), La Calera, Tocancipá, Sopó y Tenjo.

PROTOCOLOS DE SEGURIDAD:
- Antes: Guardar alimentos, despejar áreas y retirar mascotas.
- Después: Ventilar de 2 a 4 horas antes de reingresar.
- Plagas peligrosas (roedores, chinches, garrapatas, infestaciones graves): NO tocar heces/madrigueras sin protección, aislar niños y mascotas, NO usar venenos caseros. Ante mordedura o intoxicación, acudir a urgencias.

TÉCNICOS DISPONIBLES (PERMITE QUE EL CLIENTE ELIJA):
${listaTecnicos}

COMANDOS INTERNOS DE BASE DE DATOS (El cliente NO los verá):
- Si el cliente actualiza sus datos (nombre, ubicación, dirección o tipo de inmueble), agrega al final:
  [ACTUALIZAR_DATOS|nombre:NOMBRE_COMPLETO|ubicacion:LOCALIDAD|direccion:DIRECCION|inmueble:TIPO_INMUEBLE]
- Cuando el cliente confirme una visita técnica (elija técnico, fecha y hora), agrega al final:
  [AGENDAR_VISITA|ubicacion:LOCALIDAD|direccion:DIRECCION|plaga:PLAGA|tecnico:NOMBRE_TECNICO|fecha:FECHA_Y_HORA]
`;

        const mensajesGroq = [
            { role: "system", content: instruccionesSistema },
            ...historialMensajes.slice(-10).map(m => ({
                role: m.remitente === 'cliente' ? 'user' : 'assistant',
                content: m.texto
            }))
        ];

        const chatCompletion = await groq.chat.completions.create({
            messages: mensajesGroq,
            model: "openai/gpt-oss-20b",
            temperature: 0.5,
            max_tokens: 1024,
        });

        let respuesta = chatCompletion.choices[0]?.message?.content || "";

        // Procesar comando [ACTUALIZAR_DATOS|...]
        const regexActualizar = /\[ACTUALIZAR_DATOS\|nombre:(.*?)\|ubicacion:(.*?)\|direccion:(.*?)\|inmueble:(.*?)\]/;
        const matchActualizar = respuesta.match(regexActualizar);
        if (matchActualizar && telefonoCliente) {
            const [, nombre, ubicacion, direccion, inmueble] = matchActualizar;
            await pool.query(
                `UPDATE CLIENTES SET nombre = $1, ubicacion = $2, direccion = $3, tipo_inmueble = $4 WHERE numero_contacto = $5`,
                [nombre.trim(), ubicacion.trim(), direccion.trim(), inmueble.trim(), telefonoCliente]
            );
            console.log(`✏️ Datos actualizados vía IA para ${telefonoCliente}`);
            respuesta = respuesta.replace(regexActualizar, '').trim();
        }

        // Procesar comando [AGENDAR_VISITA|...]
        const regexVisita = /\[AGENDAR_VISITA\|ubicacion:(.*?)\|direccion:(.*?)\|plaga:(.*?)\|tecnico:(.*?)\|fecha:(.*?)\]/;
        const matchVisita = respuesta.match(regexVisita);
        if (matchVisita && telefonoCliente) {
            const [, ubicacion, direccion, plaga, tecnico, fecha] = matchVisita;
            await pool.query(
                `INSERT INTO visitas_tecnicas (telefono_cliente, ubicacion, direccion, tipo_plaga, tecnico_asignado, fecha_hora_programada)
                 VALUES ($1, $2, $3, $4, $5, $6)`,
                [telefonoCliente, ubicacion.trim(), direccion.trim(), plaga.trim(), tecnico.trim(), fecha.trim()]
            );
            console.log(`📅 Nueva visita técnica agendada en BD con ${tecnico} para ${fecha}`);
            respuesta = respuesta.replace(regexVisita, '').trim();

            respuesta += `\n\n✅ ¡Muchas gracias por elegir a **Fumigaciones K.O.**! Tu tranquilidad y seguridad son nuestra prioridad. 🐜✨\n\n💻 *AVIKO desarrollado por: Juan Casas, Nicolas Moreno, Joseph Romero y Camila Palacio.*`;
        }

        return respuesta || "¿Podrías darme un poco más de detalle para ayudarte mejor? 🐜";

    } catch (error) {
        console.error("❌ Error en Groq:", error);
        return "En este momento presento intermitencias en mi sistema. 🔄 Te estoy transfiriendo con un agente humano de Fumigaciones K.O., por favor espera en el chat...";
    }
}

module.exports = { procesarMensajeIA };