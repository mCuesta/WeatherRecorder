import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import QtQuick.LocalStorage 2.0
import "../logica/Storage.js" as Storage
import "../logica/ValidationUtils.js" as ValidationUtils
import "../logica/DateUtils.js" as DateUtils

Page {
    id: searchPage

    // Imagen de fondo
    Image {
        source: "../assets/snow.jpg"
        anchors.top: pageHeader.bottom
        width: parent.width
        height: parent.height - pageHeader.height
    }

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Buscar temperatura")
    }

    Component {
        id: confirmDeleteDialog
        ConfirmDeleteDialog{temperatureDate: temperatureDateButton.text}
    }
    
    Row {
        id: searchHeader
        anchors.top: pageHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(2)

        Image {
            id: img
            width: units.gu(4); height: units.gu(4)
            fillMode: Image.PreserveAspectFit
            source: "../assets/search.png"
        }
        
        Text {
            anchors.verticalCenter: img.verticalCenter
            text: i18n.tr("Búsqueda de temperaturas")
            font.bold: true
            color: UbuntuColors.graphite
            font.pointSize: units.gu(1.5)
        }
    }

    Column {
        id: searchForm
        anchors.top: searchHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(1.5)
        spacing: units.gu(1)

        Row {
            // Crea un PopOver que contiene un DatePicker
            Component {
                id: popoverTemperatureDatePicker
                Popover {
                    contentWidth: timePicker.width
                    DatePicker {
                        id: timePicker
                        mode: "Days|Months|Years"
                        minimum: {
                            var time = new Date()
                            time.setFullYear('2000')
                            return time
                        }
                        Component.onDestruction: {
                            temperatureDateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                        }
                    }
                }
            }

            // Cuando se hace clic, abre el componente popOver con DatePicker
            Button {
                id: temperatureDateButton
                width: units.gu(20)
                text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                onClicked: {
                    PopupUtils.open(popoverTemperatureDatePicker, temperatureDateButton)
                }
            }
        }

        Row {
            Button {
                text: i18n.tr("Buscar")
                width: searchForm.width
                onClicked: {
                    //var searchDate = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                    temperatureFoundField.text = Storage.getTemperatureValueByDate(temperatureDateButton.text, temperatureUnitFoundLabel.text);
                    resultForm.visible= true;
                    if(temperatureFoundField.text === "N/A") {
                        resultHeader.text = i18n.tr("Temperatura no encontrada");
                        resultHeader.color = UbuntuColors.red;
                        resultForm.enabled = false;
                    } else {
                        resultHeader.text = i18n.tr("Temperatura encontrada");
                        resultHeader.color = UbuntuColors.graphite;
                        resultForm.enabled = true;
                    }
                }
            }
        }
    }

    Row {
        id: linea
        anchors.top: searchForm.bottom
        anchors.topMargin: units.gu(1.5)
        Rectangle {
            color: "grey"
            height: units.gu(0.1)
            width: searchPage.width
        }
    }

    // -------------FORMULARIO RESULTADO-------------
    Column {
        id: resultForm
        anchors.top: linea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(1.5)
        spacing: units.gu(1)
        visible: false

        Row {
            Text {
                id: resultHeader
                font.bold: true
                font.pointSize: units.gu(1.5)
            }
        }

        Row {
            spacing: units.gu(1)

            TextField {
                id: temperatureFoundField
                width: units.gu(10)
                // Solo se permiten dígitos.
                inputMethodHints: Qt.ImhDigitsOnly
            }

            Label {
                id: temperatureUnitFoundLabel
                anchors.verticalCenter: temperatureFoundField.verticalCenter
                width: units.gu(3)
                font.bold: true
                font.pointSize: units.gu(1.5)
            }

            Button {
                text: i18n.tr("Actualizar")
                onClicked: {
                    if(ValidationUtils.isEmptyValue(temperatureFoundField.text) || ValidationUtils.hasInvalidTemp(temperatureFoundField.text)) {
                        PopupUtils.open(invalidInputDialog);
                    } else {
                        var affectedRow = Storage.updateTemperature(temperatureDateButton.text,temperatureFoundField.text, temperatureUnitFoundLabel.text);
                        if(affectedRow === 0)
                            Storage.insertTemperature(temperatureDateButton.text,temperatureFoundField.text, temperatureUnitFoundLabel.text)
                        PopupUtils.open(operationSuccessDialog);
                        resultForm.visible = false;
                    }
                } 
            }

            Button {
                text: i18n.tr("Borrar")
                onClicked: {
                    if(ValidationUtils.isEmptyValue(temperatureFoundField.text) || ValidationUtils.hasInvalidTemp(temperatureFoundField.text)) {
                        PopupUtils.open(invalidInputDialog);
                    } else {
                        PopupUtils.open(confirmDeleteDialog);
                    }
                } 
            }
        }
    }

    Component.onCompleted: {
        var aux = Storage.getConfigParamValue('temperatureUnit');
        switch (aux) {
            case "Celsius":
                temperatureUnitFoundLabel.text = "ºC";
                break;
            case "Fahrenheit":
                temperatureUnitFoundLabel.text = "ºF";
                break;
            }
    }
}
