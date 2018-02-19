import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../logica/Storage.js" as Storage
import "../logica/ValidationUtils.js" as ValidationUtils

Dialog {
    id: appConfigurationDialog
    title: i18n.tr("Configuración")

    width: units.gu(45)
    height: units.gu(75)

    Row {
        spacing: units.gu(2)

        Label {
            anchors.verticalCenter: cityField.verticalCenter
            text: i18n.tr("Ciudad:")
        }

        TextField {
            id: cityField
            width: units.gu(22)
        }

    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: units.gu(1)

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Escala de temperatura:")
        }

        ListItem.ItemSelector {
            id: temperatureUnitSelector
            model: [i18n.tr("Farenheit"), i18n.tr("Celsius")]
            expanded: true
        }
    }

    Row {
        spacing: units.gu(2)

        Button {
            text: i18n.tr("Guardar")
            width: units.gu(14)
            onClicked: {
                if (ValidationUtils.isEmptyValue(cityField.text)) {
                    operationResultLabel.text = i18n.tr("Introduzca una ciudad");
                    operationResultLabel.color = UbuntuColors.red;
                } else {
                    // Obtener la unidad de medida de la temperatura elegida
                    var temperatureUnitName = temperatureUnitSelector.model[temperatureUnitSelector.selectedIndex];
                    var res = "";

                    // Actualizar los valores en la tabla de configuración
                    res = Storage.updateConfigParamValue('city', cityField.text);
                    if (res === 'OK') {
                        res = Storage.updateConfigParamValue('temperatureUnit', temperatureUnitName);
                        if (res === 'OK') {
                            operationResultLabel.text = i18n.tr("Operación ejecutada con éxito");
                            operationResultLabel.color = UbuntuColors.green;
                            pageHeader.title = appTitle + " en " + cityField.text;
                        } else {
                            operationResultLabel.text = i18n.tr("¡Error!");
                            operationResultLabel.color = UbuntuColors.red;
                        }
                    } else {
                        operationResultLabel.text = i18n.tr("¡Error!");
                        operationResultLabel.color = UbuntuColors.red;
                    }
                }
            }
        }

        Button {
            text: i18n.tr("Cerrar")
            width: units.gu(14)
            onClicked: {
                PopupUtils.close(appConfigurationDialog)
            }
        }
    }

    Column{
        Label {
            id: operationResultLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: " "
        }
    }

    Component.onCompleted: {
        var savedCity = Storage.getConfigParamValue('city');
        var savedTemperatureUnit = Storage.getConfigParamValue('temperatureUnit');

        // Establece el elemento selector con el valor guardado
        for (var i = 0; i < temperatureUnitSelector.model.length; i++) {
            if (temperatureUnitSelector.model[i] === savedTemperatureUnit) {
                temperatureUnitSelector.selectedIndex = i;
                break;
            }
        }
        cityField.text = savedCity;
    }
}
