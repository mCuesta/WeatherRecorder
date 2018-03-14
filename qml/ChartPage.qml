import QtQuick 2.4
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

        Button {
            id: showChartButton
            width: units.gu(15)
            text: i18n.tr("Mostrar gráfico")
            onClicked: {
                /* extraer el año, mes y día de la variable 'targetDate' que contiene un valor aaaa-mm-dd */
                var dateParts = chartPage.targetDate.split("-");

                /* construye un objeto de fecha JS usando tokens de cadena (el mes está basado en 0) */
                var date = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);

                /* calcula el primer y último día del mes */
                var firstDayMonth = new Date(date.getFullYear(), date.getMonth(), 1);
                var lastDayMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

                /* establece el conjunto de datos en el gráfico y hace visible el gráfico y la leyenda */
                temperatureChart.chartData = ChartUtils.getChartData(firstDayMonth,lastDayMonth);
                chartAndLegendGridContainer.visible = true;
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
            width: parent.width - chartLegendContainer.width - units.gu(1)
            height: parent.height

            /* La tabla de temperatura mensual */
            QChart {
                id: temperatureChart
                width: parent.width
                height: parent.height
                chartAnimated: false
                /* para todas las opciones, vea: QChart.js */
                chartOptions: {"barStrokeWidth": 0}
                /* chartData: establecido cuando el usuario presiona el botón 'Mostrar gráfico' */
                chartType: Charts.ChartType.BAR
            }
        }

        Rectangle {
            id: chartLegendContainer
            width: units.gu(18)
            height: parent.height

            /* modelo para la leyenda del gráfico */
            ListModel {
                id: customRangeChartListModel
            }

            /* ListView que muestra los valores en la leyenda */
            UbuntuListView {
                id: chartLegendListView
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
                            fontSize: Label.XSmall
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
}
