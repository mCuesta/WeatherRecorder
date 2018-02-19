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

// Comprueba si el valor de entrada contiene letras o caracteres no válidos (es decir, no es numérico)
function hasInvalidChar(fieldTxtValue) {
    return /[<>?%#;a-z*A-Z]|&#/.test(fieldTxtValue) ? true : false;
}
