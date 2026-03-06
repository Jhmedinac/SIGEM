const { sql, pool, poolConnect } = require('./api-backend/src/config/database');

async function run() {
    try {
        await poolConnect;
        console.log("Conectado a la base de datos.");
        await pool.request().query(`
            ALTER TABLE sec.usuario ALTER COLUMN id_persona INT NULL;
        `);
        console.log("¡Éxito! La columna 'id_persona' ahora permite valores NULL.");
    } catch (err) {
        console.error("Error al ejecutar:", err);
    } finally {
        process.exit();
    }
}

run();
