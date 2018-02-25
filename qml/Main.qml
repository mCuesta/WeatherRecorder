import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import "../logica/Storage.js" as Storage
//import PluginName 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'weatherrecorder.macuhe'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property string appVersion: "1.0"

    // El archivo de configuración se guarda en ~userHome/phablet/.config/<applicationName>/<applicationName>.conf
    // y ejecutando clickable --desktop se guarda en /tmp/clickable/config/<applicationName>/<applicationName>.conf
    Settings {
        id: settings
        property bool isFirstUse: true
    }

    Component {
        id: operationSuccessDialog
        OperationResultDialog{msg:i18n.tr("Operación ejecutada con éxito"); labelColor:UbuntuColors.green}
    }

    Component {
        id: invalidInputDialog
        OperationResultDialog{msg:i18n.tr("ERROR: valor de entrada inválido"); labelColor:UbuntuColors.red}
    }

    Component {
        id: valueAlreadyInsertedDialog
        OperationResultDialog{msg:i18n.tr("Valor ya insertado para el día: edítelo"); labelColor:UbuntuColors.red}
    }

    Component {
        id: productInfoDialog
        ProductInfoDialogue{}
    }

    Component {
        id: appConfigurationDialog
        AppConfiguration{}
    }

    Component {
        id: insertPage
        InsertPage{}
    }

    PageStack {
        id: pageStack

        // Establecer la primera página de la aplicación
        Component.onCompleted: {
            pageStack.push(mainPage)
        }

        // Página de inicio de la aplicación
        Page {
            id: mainPage

            Image {
                source: "../assets/snow.jpg"
                anchors.top: pageHeader.bottom
                width: parent.width
                height: parent.height - pageHeader.height
            }

            header: PageHeader {
                id: pageHeader
                title: i18n.tr("Resgistro de temperaturas")
                StyleHints {
                    backgroundColor: "transparent"
                }

                // Acciones disponibles en leadingActionBar (la del lado izquierdo)
                leadingActionBar.actions: [
                    Action {
                        // Nota: 'iconName son nombres de archivos en /usr/share/icons/suru/actions/scalable
                        iconName: "info"
                        text: i18n.tr("Acerca de")
                        onTriggered: {
                            PopupUtils.open(productInfoDialog)
                        }
                    }
                ]

                // Acciones disponibles en trailingActionBar (la del lado derecho)
                trailingActionBar.actions: [
                    Action {
                        iconName: "settings"
                        text: i18n.tr("Ajustes")
                        onTriggered: {
                            PopupUtils.open(appConfigurationDialog)
                        }
                    }
                ]
            }

            Row {
                id: row1
                anchors.left: parent.left
                anchors.top: pageHeader.bottom
                anchors.margins: units.gu(1)
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Ciudad:")
                    textSize: Label.Large
                    font.bold: true
                }

                Label {
                    id: temperatureCityLabel
                    textSize: Label.Large
                }
            }

            Row {
                id: row2
                anchors.left: parent.left
                anchors.top: row1.bottom
                anchors.margins: units.gu(1)
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Escala predeterminada:")
                    textSize: Label.Large
                    font.bold: true
                }

                Label {
                    id: temperatureUnitLabel
                    textSize: Label.Large
                }
            }

            Row {
                id: row3
                anchors.left: parent.left
                anchors.top: row2.bottom
                anchors.margins: units.gu(1)
                spacing: units.gu(1)

                Button {
                    text: i18n.tr("Añadir temperatura")
                    onClicked: {
                        pageStack.push(insertPage)
                    }
                }

                Button {
                    text: i18n.tr("Buscar temperatura")
                }
            }

            Row {
                anchors.left: parent.left
                anchors.top: row3.bottom
                anchors.margins: units.gu(1)

                Button {
                    text: i18n.tr("Analíticas")
                }
            }

            Component.onCompleted: {
                //PluginName.speak()
                if(settings.isFirstUse) {
                    Storage.createTables();
                    Storage.deleteAllConfigValues();
                    Storage.insertDefaultConfigValues();
                    PopupUtils.open(appConfigurationDialog);
                    settings.isFirstUse = false;
                }
                temperatureCityLabel.text = Storage.getConfigParamValue('city');
                var aux = Storage.getConfigParamValue('temperatureUnit');
                switch (aux) {
                    case "Celsius":
                        temperatureUnitLabel.text = "ºC";
                        break;
                    case "Fahrenheit":
                        temperatureUnitLabel.text = "ºF";
                        break;
                    }
            }
        }
    }
}
