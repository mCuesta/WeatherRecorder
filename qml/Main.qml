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

    property string appTitle: i18n.tr("Registros del tiempo")
    property string appVersion: "1.0"

    // El archivo de configuración se guarda en ~userHome/.config/<applicationName>/<applicationName>.conf
    Settings {
        id: settings
        property bool isFirstUse: true
    }

    Component {
        id: productInfoDialoDialog
        ProductInfoDialogue{}
    }

    Component {
        id: appConfigurationDialog
        AppConfiguration{}
    }

    Page {
        id: mainPage

        header: PageHeader {
            id: pageHeader
            title: i18n.tr("Resgistros del tiempo")
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
                        PopupUtils.open(productInfoDialoDialog)
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
    }

    Component.onCompleted: {
        //PluginName.speak()
        if(settings.isFirstUse) {
            Storage.createTables();
            Storage.deleteAllConfigValues();
            Storage.insertDefaultConfigValues();
            PopupUtils.open(appConfigurationDialog);
            settings.isFirstUse = false;
        } else {
            pageHeader.title = appTitle + " en " + Storage.getConfigParamValue('city');
            var aux = Storage.getConfigParamValue('temperatureUnit');
            }
    }
}
