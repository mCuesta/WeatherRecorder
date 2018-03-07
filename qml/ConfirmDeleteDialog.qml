import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../logica/DateUtils.js" as DateUtils
import "../logica/Storage.js" as Storage

/* Mostrar un cuadro de diálogo de confirmación */
Dialog {
    id: temperatureDeleteDialog
    text: "<b>" + i18n.tr("¿Eliminar valor de temperatura?") + "<br/>" + i18n.tr("(no se puede deshacer)") + "</b>"

    /* Parámetro de entrada: la fecha de la temperatura */
    property string temperatureDate;

    Button {
        id: closeButton
        text: i18n.tr("Cerrar")
        onClicked: PopupUtils.close(temperatureDeleteDialog)
    }

    Button {
        id: importButton
        text: i18n.tr("Eliminar")
        color: UbuntuColors.orange
        onClicked: {
            var rowsDeleted = Storage.deleteTemperatureByDate(temperatureDate);

            resultForm.visible = false;
            PopupUtils.close(temperatureDeleteDialog)
        }
    }
}
