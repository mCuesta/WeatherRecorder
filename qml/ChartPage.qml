import QtQuick 2.4
import QtQuick.Window 2.2
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
/* Thanks to: https://github.com/jwintz/qchart.js for QML bindings for Charts.js */
import "../logica/QChart.js" as Charts
import QtQuick.LocalStorage 2.0
import "../logica/ChartUtils.js" as ChartUtils
import "../logica/DateUtils.js" as DateUtils

Page {
    id: chartPage

    // Imagen de fondo
    Image {
        source: "../assets/snow.jpg"
        anchors.top: pageHeader.bottom
        width: parent.width
        height: parent.height - pageHeader.height
    }

    /* Por defecto es hoy, después se actualiza cuando el usuario elige una fecha con TimePicker */
    property string targetDate : Qt.formatDateTime(new Date(), "yyyy-MM-dd");

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Página analítica")
    }

    Row {
        id: monthSelectorRow
        anchors.top: pageHeader.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: units.gu(1.5)
        spacing: units.gu(2)

        // Crea un PopOver que contiene un DatePicker
        Component {
            id: popoverTargetMonthPicker
            Popover {
                contentWidth: timePicker.width
                DatePicker {
                    id: timePicker
                    mode: "Months|Years"
                    minimum: {
                        var time = new Date()
                        time.setFullYear('2000')
                        return time
                    }
                    Component.onDestruction: {
                        targetMonthSelectorButton.text = Qt.formatDateTime(timePicker.date, "MMMM yyyy");
                        chartPage.targetDate = Qt.formatDateTime(timePicker.date, "yyyy-MM-dd");
                        ChartUtils.mostrarGrafico();
                    }
                }
            }
        }

        // Cuando se hace clic, abre el componente popOver con DatePicker
        Button {
            id: targetMonthSelectorButton
            width: units.gu(20)
            text: Qt.formatDateTime(new Date(), "MMMM yyyy")
            onClicked: {
                PopupUtils.open(popoverTargetMonthPicker, targetMonthSelectorButton)
            }
        }
    }

    // ---------------- Gráfico y leyenda ---------------------
    Grid {
        id: chartAndLegendGridContainer
        columns: 2
        columnSpacing: units.gu(1)
        anchors.top: monthSelectorRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: units.gu(1)
        visible: false

        Rectangle {
            id: temperatureChartContainer
            // Modificamos el ancho acorde a la visibilidad de la leyenda
            width: (chartLegendContainer.visible) ? parent.width - chartLegendContainer.width - units.gu(1) : parent.width
            height: parent.height

            /* La tabla de temperatura mensual */
            QChart {
                id: temperatureChart
                width: parent.width
                height: parent.height - units.gu(1)
                chartAnimated: true
                chartAnimationEasing: Easing.InExpo;
                /* para todas las opciones, vea: QChart.js */
                chartOptions: {"barShowStroke": false}
                /* chartData: establecido cuando el usuario presiona el botón 'Mostrar gráfico' */
                chartType: Charts.ChartType.BAR
            }
        }

        Rectangle {
            id: chartLegendContainer
            width: units.gu(8)
            height: parent.height
            color: "lightGray"

            /* modelo para la leyenda del gráfico */
            ListModel {
                id: customRangeChartListModel
            }

            /* ListView que muestra los valores en la leyenda */
            UbuntuListView {
                id: chartLegendListView
                // Recortar el contenido
                clip: true
                /* deshabilita el arrastre de los elementos de la lista modelo */
                boundsBehavior: Flickable.StopAtBounds
                anchors.fill: parent
                model: customRangeChartListModel
                /* 'delegate' es el componente que define el diseño utilizado para mostrar el valor del ListModel */
                delegate: Component {
                    id: customReportChartLegend
                    Rectangle {
                        height: legendEntry.height
                        border.color: UbuntuColors.graphite
                        border.width: units.gu(0.5)

                        Label {
                            id: legendEntry
                            text: date + " : " + temp
                            textSize: Label.Small
                        }
                    }
                }
            }

            Scrollbar {
                flickableItem: chartLegendListView
                align: Qt.AlignTrailing
            }
        }
    }

    Component.onCompleted: {
      //  Screen.setOrientationUpdateMask = Qt.LandscapeOrientation;
        if(Screen.primaryOrientation === Qt.PortraitOrientation) {
            chartLegendContainer.visible = false;
        }

        ChartUtils.mostrarGrafico();
    }

    Screen.onPrimaryOrientationChanged: {
        chartLegendContainer.visible = !chartLegendContainer.visible;
    }
}
