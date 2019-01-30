import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0

Item {
	id: widget

	WeatherData {
		id: weatherData
	}

	Plasmoid.icon: weatherData.currentConditionIconName
	Plasmoid.toolTipMainText: weatherData.currentConditions

	Plasmoid.fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		implicitWidth: forecastLayout.implicitWidth
		implicitHeight: forecastLayout.implicitHeight
		Layout.minimumWidth: implicitWidth
		Layout.minimumHeight: implicitHeight

		PlasmaComponents.Button {
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Configure...")
			onClicked: plasmoid.action("configure").trigger()
		}

		RowLayout {
			id: forecastLayout
			anchors.fill: parent
			spacing: units.smallSpacing
			opacity: weatherData.hasData ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 1000 } }

			readonly property string fontFamily: plasmoid.configuration.fontFamily || theme.defaultFont.family
			readonly property var fontBold: plasmoid.configuration.bold ? Font.Bold : Font.Normal

			ColumnLayout {
				spacing: units.smallSpacing

				PlasmaComponents.Label {
					readonly property var value: weatherData.todaysTempHigh
					text: isNaN(value) ? "" : i18n("%1°", value)
					
					font.pointSize: -1
					font.pixelSize: 14 * units.devicePixelRatio
					font.family: forecastLayout.fontFamily
					font.weight: forecastLayout.fontBold
					Layout.alignment: Qt.AlignHCenter
				}

				Rectangle {
					visible: !isNaN(weatherData.todaysTempHigh) || !isNaN(weatherData.todaysTempLow)
					color: theme.textColor
					implicitWidth: 20 * units.devicePixelRatio
					implicitHeight: 1 * units.devicePixelRatio
					Layout.alignment: Qt.AlignHCenter
				}


				PlasmaComponents.Label {
					readonly property var value: weatherData.todaysTempLow
					text: isNaN(value) ? "" : i18n("%1°", value)

					font.pointSize: -1
					font.pixelSize: 14 * units.devicePixelRatio
					font.family: forecastLayout.fontFamily
					font.weight: forecastLayout.fontBold
					Layout.alignment: Qt.AlignHCenter
				}
			}
			ColumnLayout {
				spacing: 0

				Item {
					implicitWidth: currentTempLabel.contentWidth
					Layout.minimumWidth: implicitWidth
					Layout.minimumHeight: 18 * units.devicePixelRatio

					Layout.fillHeight: true
					Layout.fillWidth: true

					// Note: wettercom does not have a current temp
					PlasmaComponents.Label {
						id: currentTempLabel
						anchors.centerIn: parent
						readonly property var value: weatherData.currentTemp
						readonly property bool hasValue: !isNaN(value)
						text: hasValue ? i18n("%1°", value) : ""
						font.pointSize: -1
						font.pixelSize: parent.height
						font.family: forecastLayout.fontFamily
						font.weight: forecastLayout.fontBold
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignBottom

						// Rectangle { anchors.centerIn: parent; color: "transparent"; border.width: 1; border.color: "#ff0"; width: parent.contentWidth; height: parent.contentHeight}
					}

					// Note: wettercom does not have a current temp so use an icon instead
					PlasmaCore.IconItem {
						id: currentForecastIcon
						anchors.fill: parent
						visible: !currentTempLabel.hasValue
						source: weatherData.currentConditionIconName
					}

					// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
				}

				PlasmaComponents.Label {
					text: weatherData.todaysForecastLabel
					font.pointSize: -1
					font.pixelSize: 12 * units.devicePixelRatio
					font.family: forecastLayout.fontFamily
					font.weight: forecastLayout.fontBold
					Layout.alignment: Qt.AlignHCenter

					// Rectangle { anchors.fill: parent; color: "transparent"; border.width: 1; border.color: "#f00"}
				}
			}

		}

	}


	Component.onCompleted: {
		// plasmoid.action("configure").trigger()
	}
}
