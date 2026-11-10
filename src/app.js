const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');

// Inicializa el cliente guardando la sesión localmente
const client = new Client({
    authStrategy: new LocalAuth()
});

// Genera el código QR en la terminal
client.on('qr', (qr) => {
    console.log('Escanea este código QR con el WhatsApp de Fumigaciones K.O:');
    qrcode.generate(qr, { small: true });
});

// Aviso cuando el bot se conecta exitosamente
client.on('ready', () => {
    console.log('¡AVIKO está en línea y listo para recibir mensajes!');
});

// Lógica de respuesta a los mensajes
client.on('message', async msg => {
    const mensajeCliente = msg.body.toLowerCase();

    if (mensajeCliente === 'hola') {
        msg.reply('Hola, soy AVIKO, el asistente virtual de Fumigaciones K.O. 🪳🐀 ¿En qué te puedo ayudar hoy?');
    } 
    else if (mensajeCliente.includes('precio') || mensajeCliente.includes('cotizar')) {
        msg.reply('Para generar una cotización necesito que me compartas algunos datos. ¿Qué tipo de inmueble deseas fumigar? (Ej: Casa, Apartamento, Restaurante)');
    }
});

// Inicia el bot
client.initialize();