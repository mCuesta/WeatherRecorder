import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import PluginName 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'weatherrecorder.macuhe'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property string appVersion: "1.0"

    Component {
        id: productInfoDialoDialog
        ProductInfoDialogue{}
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
		}
    }

    //Component.onCompleted: PluginName.speak()
}
