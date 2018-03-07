import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3
import QtQuick.LocalStorage 2.0
import "../logica/Storage.js" as Storage
import "../logica/ValidationUtils.js" as ValidationUtils
import "../logica/DateUtils.js" as DateUtils

Page {
    id: insertPage

    // Imagen de fondo
    Image {
        source: "../assets/snow.jpg"
        anchors.top: pageHeader.bottom
        width: parent.width
        height: parent.height - pageHeader.height
    }

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Añadir temperatura")
    }

    Row {
        id: insertHeader
        anchors.top: pageHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(2)

        Image {
            id: img
            width: units.gu(4); height: units.gu(4)
            fillMode: Image.PreserveAspectFit
            source: "../assets/temperature.png"
        }
        
        Text {
            anchors.verticalCenter: img.verticalCenter
            text: i18n.tr("Insercción de temperatura")
            font.bold: true
            color: UbuntuColors.graphite
            font.pointSize: units.gu(1.5)
        }
    }

    Column {
        id: insertForm
        anchors.top: insertHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.gu(1.5)
        spacing: units.gu(1)

        Row {
            spacing: units.gu(1)

            TextField {
                id: temperatureField
                width: units.gu(10)
            }

            // Selector de escala
            ComboButton {
                id: escala
                width: units.gu(10)
                expandedHeight: collapsedHeight + units.gu(13)
                onClicked: expanded = false

                ListModel {
                    id: temp
                    ListElement {
                        item: "ºC"
                    }
                    ListElement {
                        item: "ºF"
                    }
                }

                ListView {
                    model: temp
                    delegate: Standard {
                        text: modelData
                        onClicked: {
                            escala.text = modelData
                            escala.expanded = false
                        }
                    }
                }

            }
        }

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
                text: i18n.tr("Añadir")
                width: insertForm.width
                onClicked: {
                    if(ValidationUtils.isEmptyValue(temperatureField.text) || ValidationUtils.hasInvalidTemp(temperatureField.text)) {
                        PopupUtils.open(invalidInputDialog);
                    } else if(Storage.getTemperatureValueByDate(temperatureDateButton.text) === "N/A") {
                        Storage.insertTemperature(temperatureDateButton.text, temperatureField.text, escala.text);
                        temperatureField.text = "";
                        PopupUtils.open(operationSuccessDialog);
                    } else {
                        PopupUtils.open(valueAlreadyInsertedDialog);
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        var aux = Storage.getConfigParamValue('temperatureUnit');
        switch (aux) {
            case "Celsius":
                escala.text = "ºC";
                break;
            case "Fahrenheit":
                escala.text = "ºF";
                break;
            }
    }
}
