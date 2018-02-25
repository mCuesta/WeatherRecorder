/*
 * Funciones para manejar la base de datos
 */

// http://doc.qt.io/archives/qt-5.5/qtquick-localstorage-qmlmodule.html
function getDatabase() {
    return LocalStorage.openDatabaseSync("weatherrecorder_db", "1.0", "StorageDatabase", 1000000);
}

// Crear las tablas necesarias
function createTables() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS configuration(id INTEGER PRIMARY KEY AUTOINCREMENT, param_name TEXT, param_value TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS temperature(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, temperature_value REAL)');
    });
}

// Eliminar todos los valores de configuración
function deleteAllConfigValues() {
    var db = getDatabase();

    db.transaction(
        function(tx) {
            tx.executeSql('DELETE FROM configuration');
    });
}

// Insertar un valor de parámetro de configuración. Devuelve 'OK' si la fila se actualiza con éxito, de lo contrario 'ERROR' 
function insertConfigParamValue(paramName, paramValue) {
    var db = getDatabase();
    var res = "";

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('INSERT INTO configuration(param_name, param_value) VALUES (?,?);', [paramName, paramValue]);
            if (rs.rowsAffected === 1) {
                res = "OK";
            } else {
                res = "Error";
            } 
        });
    return res;
}

// Inicializamos las tablas con valores predeterminados
function insertDefaultConfigValues() {
    insertConfigParamValue('city', 'Villaviciosa');
    insertConfigParamValue('temperatureUnit', 'Celsius');
}

// Cargar el parámetro de configuración con el nombre proporcionado 
function getConfigParamValue(paramName) {
    var db = getDatabase();
    var rs = "";

    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT param_value FROM configuration WHERE param_name = ?;', [paramName]);
    });

    return rs.rows.item(0).param_value;
}

// Actualiza un valor de parámetro de configuración
// Devuelve 'OK' si la fila se actualiza con éxito, de lo contrario 'ERROR'
function updateConfigParamValue(paramName, paramValue) {
    var db = getDatabase();
    var res = "";

    db.transaction(
        function(tx) {
            var rs = tx.executeSql('UPDATE configuration SET param_value=? WHERE param_name=?;', [paramValue, paramName]);
            if (rs.rowsAffected === 1) {
                res = "OK";
            } else {
                res = "Error";
            } 
        });
    return res;
}

/* Devuelve un valor de temperatura para la fecha dada. Si no existe devuelve 'N/A' (no disponible) */
function getTemperatureValueByDate(date) {

    var db = getDatabase();
    var targetDate = new Date (date);

    /* devuelve una fecha formateada como: 2018-02-28 (aaaa-mm-dd) */
    var fullTargetDate = DateUtils.formatDateToString(targetDate);
    var rs = "";

    db.transaction(function(tx) {
        rs = tx.executeSql("SELECT temperature_value FROM temperature t where date(t.date) = date('"+fullTargetDate+"')");
    });

    /* comprobar si falta valor o no */
    if (rs.rows.length > 0) {
        return rs.rows.item(0).temperature_value;
    } else {
        return "N/A";
    }
}

/* Inserta un nuevo valor de temperatura para la fecha dada */
function insertTemperature(date,tempValue, escala) { 

    var db = getDatabase();
    var fullDate = new Date (date);
    var res = "";

    /* devuelve una fecha formateada como: 2018-02-28 (aaaa-mm-dd) */
    var dateFormatted = DateUtils.formatDateToString(fullDate);

    /* convierte grados Fahrenheit a Celsius
       todas las temperaturas se almacenan en Celsius */
    var tempFormatted = (escala === "ºC") ? tempValue : (tempValue - 32) * 5 / 9;

    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT INTO temperature (date, temperature_value) VALUES (?,?);', [dateFormatted, tempFormatted]);
        if (rs.rowsAffected > 0) {
           res = "OK";
       } else {
           res = "Error";
       }
    });
    return res;
}
