/* Contiene las utilidades para recuperar datos de la base de datos 
 * y crear el conjunto de datos del gráfico */

/* Obtener una referencia a la base de datos SQLite donde recoger los datos */
function getDatabase() {
    return LocalStorage.openDatabaseSync("weatherrecorder_db", "1.0", "StorageDatabase", 1000000);
}

/* 
 * Llamado para obtener el dataSet X Y para el gráfico
 * Recibe como entrada el objeto date Javascript
*/
function getChartData(fromDate, toDate) {

    /* la cantidad de días del mes */
    var monthDays = DateUtils.getDifferenceInDays(fromDate, toDate);

    var xyDataSet = prepareEmptyDataset(fromDate, monthDays);

    updateXYdataset(fromDate, toDate, xyDataSet);

    /* activar solo para depuración: imprime el conjunto de datos XY
     * printDataSet(xyDataSet);
     */

    var x = getXaxisValue(xyDataSet);
    var y = getYaxisValue(xyDataSet);

    var ChartBarData = {
        labels: x,
        datasets: [{
            fillColor: "rgba(220, 220, 220, 0.5)",
            strokeColor: "rgba(220, 220, 220, 1)",
            data: y
        }]
    }

    getChartLegendData(xyDataSet);

    return ChartBarData;
}

/* Extrae los valores X del conjunto de datos XY completo. Los valores X son la parte 'clave' del 
 * conjunto de datos XY completo (es decir, la fecha aaaa-mm-dd)
*/
function getXaxisValue(xyDataSet) {
    var x = [];

    for(var key in xyDataSet) {            
        x.push(key);
    }

    return x;
}

/* Extrae los valores Y del conjunto de datos XY completo. Los valores Y son la parte 'valor' del 
 * conjunto de datos XY completo (es decir, el valor de temperatura)
*/
function getYaxisValue(xyDataSet) {
    var y = [];

    for(var key in xyDataSet) {            
        y.push(xyDataSet[key]);
    }

    return y;
}

/* Función DEBUG para imprimir por consola el conjunto de datos del gráfico XY */
function printDataSet(xyDataSet) {
    for(var key in xyDataSet) {
        console.log("Clave: " + key + " valor: " + xyDataSet[key]);
    }
}

/* Prepara un conjunto de datos XY para cada día del mes, estableciendo su valor de temperatura en cero
 * (valor predeterminado).
 * 'fromDate' es el primer día del mes
 * 'monthDays' es el número de días del mes
*/
function prepareEmptyDataset(fromDate, monthDays) {

    /* Inicia una matriz asociativa vacía */
    var xyDataSet = {};

    for(var i = 0; i < monthDays + 1; i++) {
        // Inicializar el valor de temperatura para la fecha
        xyDataSet[DateUtils.addDaysAndFormat(fromDate, i)] = 0;
    }

    return xyDataSet;
}

/* Extrae de la base de datos los valores de temperatura dentro del mes objetivo y actualiza la configuración del conjunto 
 * de datos XY proporcionado reemplazando el valor predeterminado (es decir, cero) con el valor de temperatura correcto para el día.
*/
function updateXYdataset(fromDate, toDate, xyDataSet) {
    var dateTo = DateUtils.formatDateToString(toDate);
    var dateFrom = DateUtils.formatDateToString(fromDate);

    var db = getDatabase();
    var rs = "";

    db.transaction(
        function(tx) {
            rs = tx.executeSql("select temperature_value,date from temperature e where date(e.date) <= date('" + dateTo + "') and date(e.date) >= date('" + dateFrom + "') order by date asc");
        }
    );

    /* Actualizar los valores en el conjunto de datos xy con los que se encuentran en la base de datos */
    for(var i = 0; i < rs.rows.length; i++) {
        xyDataSet[rs.rows.item(i).date] = rs.rows.item(i).temperature_value
    }         
}

/* Completa el QML ListModel utilizado para crear la leyenda del gráfico.
 * Los valores insertados se mostrarán mediante un componente Listview
 * Con slice(8) cogemos sólo los días y transformamos el valor numérico 
 * a dos decimales para su representación
*/
function getChartLegendData(xyDataSet) {
    customRangeChartListModel.clear();

    for(var key in xyDataSet) {
        customRangeChartListModel.append({"date": key.slice(8), "temp": xyDataSet[key].toFixed(2)});
    }
}

function mostrarGrafico() {
    /* extraer el año, mes y día de la variable 'targetDate' que contiene un valor aaaa-mm-dd */
    var dateParts = chartPage.targetDate.split("-");

    /* construye un objeto de fecha JS usando tokens de cadena (el mes está basado en 0) */
    var date = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);

    /* calcula el primer y último día del mes */
    var firstDayMonth = new Date(date.getFullYear(), date.getMonth(), 1);
    var lastDayMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

    /* establece el conjunto de datos en el gráfico y hace visible el gráfico y la leyenda */
    temperatureChart.chartData = getChartData(firstDayMonth, lastDayMonth);
    chartAndLegendGridContainer.visible = true;
}
