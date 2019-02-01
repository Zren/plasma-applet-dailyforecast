import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0

RowLayout {
	id: forecastLayout
	anchors.fill: parent
	spacing: units.smallSpacing
	opacity: weatherData.hasData ? 1 : 0
	Behavior on opacity { NumberAnimation { duration: 1000 } }

	readonly property string fontFamily: plasmoid.configuration.fontFamily || theme.defaultFont.family
	readonly property var fontBold: plasmoid.configuration.bold ? Font.Bold : Font.Normal
	
	property alias model: dayRepeater.model
	readonly property real fadedOpacity: 0.7
	readonly property int showNumDays: plasmoid.configuration.showNumDays

	readonly property int minItemWidth: {
		var minWidth = 0
		for (var i = 0; i < dayRepeater.count; i++) {
			var item = dayRepeater.itemAt(i)
			if (i == 0 || item.width < minWidth) {
				minWidth = item.width
			}
		}
		return minWidth
	}

	Repeater {
		id: dayRepeater
		model: weatherData.dailyForecastModel

		ColumnLayout {
			spacing: 0
			visible: {
				if (forecastLayout.showNumDays == 0) { // Show all
					return true
				} else {
					return (index+1) <= forecastLayout.showNumDays
				}
			}

			PlasmaComponents.Label {
				text: modelData.dayLabel || ""

				opacity: forecastLayout.fadedOpacity

				font.pointSize: -1
				font.pixelSize: 14 * units.devicePixelRatio
				font.family: forecastLayout.fontFamily
				font.weight: forecastLayout.fontBold
				Layout.alignment: Qt.AlignHCenter
			}

			PlasmaCore.IconItem {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.maximumWidth: forecastLayout.minItemWidth
				Layout.maximumHeight: forecastLayout.minItemWidth
				Layout.alignment: Qt.AlignCenter
				source: modelData.forecastIcon
				roundToIconSize: false
				width: parent.width * 1.2
				height: parent.width * 1.2

				// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
			}

			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				spacing: units.smallSpacing

				PlasmaComponents.Label {
					readonly property var value: modelData.tempHigh

					readonly property bool hasValue: !isNaN(value)
					text: hasValue ? i18n("%1°", value) : ""
					visible: hasValue
					font.pointSize: -1
					font.pixelSize: 14 * units.devicePixelRatio
					font.family: forecastLayout.fontFamily
					font.weight: forecastLayout.fontBold
					Layout.alignment: Qt.AlignHCenter
				}

				PlasmaComponents.Label {
					readonly property var value: modelData.tempLow
					opacity: forecastLayout.fadedOpacity

					readonly property bool hasValue: !isNaN(value)
					text: hasValue ? i18n("%1°", value) : ""
					visible: hasValue
					font.pointSize: -1
					font.pixelSize: 14 * units.devicePixelRatio
					font.family: forecastLayout.fontFamily
					font.weight: forecastLayout.fontBold
					Layout.alignment: Qt.AlignHCenter
				}
			}

			// Top align contents
			Item {
				Layout.fillWidth: true
				Layout.fillHeight: true
			}
		}
	}
}
