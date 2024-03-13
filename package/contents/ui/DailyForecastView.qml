import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.core as PlasmaCore

GridLayout {
	id: dailyForecastView

	//--- Settings
	readonly property int dateFontSize: plasmoid.configuration.dateFontSize * Screen.devicePixelRatio
	readonly property int minMaxFontSize: plasmoid.configuration.minMaxFontSize * Screen.devicePixelRatio
	
	readonly property int showNumDays: plasmoid.configuration.showNumDays
	readonly property bool showDailyBackground: plasmoid.configuration.showDailyBackground
	readonly property bool showMinTempBelow: plasmoid.configuration.showMinTempBelow

	//---
	columnSpacing: Kirigami.Units.smallSpacing
	rowSpacing: Kirigami.Units.smallSpacing

	// EnvCan has 2 day items for day/night, so we use 2 rows.
	// Other sources only need 1 row.
	readonly property int showNumDayItems: {
		if (weatherData.weatherSourceIsEnvcan) {
			if (weatherData.dataStartsWithNight) {
				return showNumDays * 2 - 1
			} else {
				return showNumDays * 2
			}
		} else {
			return showNumDays
		}
	}
	rows: weatherData.weatherSourceIsEnvcan ? 2 : 1
	flow: GridLayout.TopToBottom

	//--- Layout
	property alias model: dayRepeater.model

	// [EnvCan only] Takes the place of "today" if model starts with "night".
	Item {
		id: placeholderDayItem
		visible: weatherData.dataStartsWithNight
		Layout.fillWidth: true
		Layout.fillHeight: true
	}

	Repeater {
		id: dayRepeater
		model: weatherData.dailyForecastModel

		Item {
			id: dayItem
			implicitWidth: dayItemLayout.implicitWidth + frame.margins.horizontal
			implicitHeight: dayItemLayout.implicitHeight + frame.margins.vertical
			Layout.fillWidth: true
			Layout.fillHeight: true
			property alias dayItemIcon: dayItemIcon
			property alias frame: frame

			visible: {
				if (dailyForecastView.showNumDays == 0) { // Show all
					return true
				} else {
					return (index+1) <= dailyForecastView.showNumDayItems
				}
			}

			KSvg.FrameSvgItem {
				id: frame
				anchors.fill: parent
				visible: dailyForecastView.showDailyBackground
				imagePath: visible ? "widgets/background" : ""
			}

			ColumnLayout {
				id: dayItemLayout
				anchors.fill: parent
				anchors.leftMargin: frame.margins.left
				anchors.rightMargin: frame.margins.right
				anchors.topMargin: frame.margins.top
				anchors.bottomMargin: frame.margins.bottom
				spacing: 0

				WLabel {
					text: modelData.dayLabel || ""

					opacity: forecastLayout.fadedOpacity
					font.pixelSize: dailyForecastView.dateFontSize
					Layout.alignment: Qt.AlignHCenter
				}

				Kirigami.Icon {
					id: dayItemIcon
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignCenter
					source: modelData.forecastIcon
					roundToIconSize: false

					// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
				}

				GridLayout {
					Layout.alignment: Qt.AlignHCenter
					columnSpacing: Kirigami.Units.smallSpacing
					rowSpacing: 0
					flow: dailyForecastView.showMinTempBelow ? GridLayout.TopToBottom : GridLayout.LeftToRight

					WLabel {
						readonly property var value: modelData.tempHigh

						readonly property bool hasValue: !isNaN(value)
						text: hasValue ? weatherData.formatTempShort(value) : ""
						visible: hasValue
						font.pixelSize: dailyForecastView.minMaxFontSize
						Layout.alignment: Qt.AlignHCenter
					}

					WLabel {
						readonly property var value: modelData.tempLow
						opacity: forecastLayout.fadedOpacity

						readonly property bool hasValue: !isNaN(value)
						text: hasValue ? weatherData.formatTempShort(value) : ""
						visible: hasValue
						font.pixelSize: dailyForecastView.minMaxFontSize
						Layout.alignment: Qt.AlignHCenter
					}
				}

				// Top align contents
				Item {
					Layout.fillWidth: true
					Layout.fillHeight: true
				}
			}

			PlasmaCore.ToolTipArea {
				anchors.fill: parent
				mainText: modelData.forecastLabel
			}

		}
	}

}
