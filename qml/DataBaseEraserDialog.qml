import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../logica/Storage.js" as Storage

/* Mostrar un cuadro de diálogo de confirmación */
Dialog {
    id: dataBaseEraserDialog
    text: "<b>" + i18n.tr("¿Eliminar TODAS las temperaturas guardadas?") + "<br/>" + i18n.tr("(no se puede deshacer)") + "</b>"

    Button {
        id: closeButton
        text: i18n.tr("Cerrar")
        onClicked: PopupUtils.close(dataBaseEraserDialog)
    }

    Button {
        id: deleteButton
        text: i18n.tr("Eliminar")
        color: UbuntuColors.orange
        onClicked: {
            var rowsDeleted = Storage.deleteAllTemperatureValues();
            PopupUtils.close(dataBaseEraserDialog)
        }
    }
}
