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
