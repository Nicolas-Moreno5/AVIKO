const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const pool = require('./config/db'); // Carga la conexión a la base de datos
const { procesarMensajeIA } = require('./controllers/iaController'); // Carga la IA

const client = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: {
        executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe' // O la ruta de tu Edge
    }
});

client.on('qr', (qr) => {
    qrcode.generate(qr, { small: true });
});

client.on('ready', () => {
    console.log('¡AVIKO está en línea e inteligente!');
});

// Lógica de respuesta conectada a la IA
client.on('message', async msg => {
    console.log(`Mensaje recibido de ${msg.from}: ${msg.body}`);
    
    // Le pasamos el mensaje del cliente a la IA y esperamos su respuesta
    const respuestaIA = await procesarMensajeIA(msg.body);
    
    // El bot responde lo que la IA generó
    msg.reply(respuestaIA);
});

client.initialize();