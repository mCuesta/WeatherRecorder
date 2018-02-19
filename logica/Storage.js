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
