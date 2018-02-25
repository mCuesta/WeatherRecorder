import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Notificar un resultado de operación usando el mensaje de entrada y el color */
Dialog {
    id: operationErrorDialog

    /* Parámetros de entrada: el texto del mensaje a mostrar y el color a usar */
    property string msg;
    property color labelColor;

    title: i18n.tr("Resultado de la operación")

    Label{
        text: i18n.tr(msg)
        color: labelColor
    }

    Button {
        text: "Cerrar"
        onClicked:
           PopupUtils.close(operationErrorDialog)
    }
}
