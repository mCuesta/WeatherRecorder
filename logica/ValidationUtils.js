/*
    Varias funciones de utilidad para validación de entrada
*/

// Verifica si el valor proporcionado está vacío
function isEmptyValue(valueToCheck) {
    if (valueToCheck.length <= 0)
        return true;
    else
        return false;
}

// Comprueba si el valor de entrada contiene una temperatura válida
function hasInvalidTemp(fieldTxtValue) {
    return /^[+-]?\d+([,.]\d+)?$/.test(fieldTxtValue) ? false : true;
}
