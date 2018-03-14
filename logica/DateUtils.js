/* Funciones de utilidad para trabajar con fechas en Javascript */


/* La fecha de entrada del formato tiene dos dígitos para el día y el mes (el valor predeterminado es un dígito en js)
   ej: 2017-04-28
*/
function formatDateToString(date) {
   var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
   var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
   var yyyy = date.getFullYear();

   return (yyyy + "-" + MM + "-" + dd);
}

/* Calcula la diferencia en días entre dos fechas */
function getDifferenceInDays(dateFrom, dateTo) {
    // Obtiene 1 día en milisegundos
    var one_day = 1000 * 60 * 60 * 24;

    var date1_ms = dateFrom.getTime();
    var date2_ms = dateTo.getTime();

    // Calcula la diferencia en milisegundos
    var difference_ms = date2_ms - date1_ms;

    // Convertir de nuevo a días
    return Math.round(difference_ms / one_day);
}

/* Añade la cantidad de días provista en la fecha de entrada, si la cantidad es negativa, los resta.
 * Los datos devueltos tienen el patrón YYYY-MM-DD
*/
function addDaysAndFormat(date, days) {
    var newDate = new Date(
        date.getFullYear(),
        date.getMonth(),
        date.getDate() + days,
        0,
        0,
        0,
        0
    );

    return formatDateToString(newDate);
}
