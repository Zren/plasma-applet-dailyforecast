import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.3 as Kirigami
import org.kde.plasma.private.weather 1.0 as WeatherPlugin

import "../lib"
import "../libweather"

ConfigPage {
	id: page
	showAppletVersion: true

	Kirigami.FormLayout {
		Layout.fillWidth: true

		ConfigWeatherStationPicker {
			configKey: 'source'
		}
		WeatherStationCredits {
			id: weatherStationCredits
		}

		ConfigSpinBox {
			Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label:spinbox", "Update every:")
			configKey: "updateInterval"
			suffix: i18ndc("plasma_applet_org.kde.plasma.weather", "@item:valuesuffix spacing to number + unit (minutes)", " min")
			stepSize: 5
			minimumValue: 30
			maximumValue: 3600
		}

		ConfigCheckBox {
			configKey: "showWarnings"
			text: i18n("Show weather warnings")
		}

		ConfigCheckBox {
			configKey: "showBackground"
			text: i18n("Desktop Widget: Show background")
		}

		ConfigCheckBox {
			configKey: "showDailyBackground"
			text: i18n("Show background around each day")
		}

		ConfigSpinBox {
			id: showNumDays
			Kirigami.FormData.label: i18n("Days Visible:")
			configKey: "showNumDays"
			stepSize: 1
			minimumValue: 0
			maximumValue: 14
			
			readonly property bool isShowingAll: showNumDays.configValue == 0

			SystemPalette {
				id: syspal
			}

			Rectangle {
				id: showAllRect
				radius: 2 * Kirigami.Units.devicePixelRatio
				color: showNumDays.isShowingAll ? syspal.highlight : syspal.window
				Behavior on color { ColorAnimation { duration: Kirigami.Units.longDuration } }
				implicitWidth: showingAllLabel.implicitWidth + showingAllLabel.anchors.margins*2
				implicitHeight: showingAllLabel.implicitHeight + showingAllLabel.anchors.margins*2

				Label {
					id: showingAllLabel
					anchors.fill: parent
					anchors.margins: 4 * Kirigami.Units.devicePixelRatio
					color: showNumDays.isShowingAll ? syspal.highlightedText : syspal.text
					Behavior on color { ColorAnimation { duration: Kirigami.Units.longDuration } }
					text: i18n("0 = Show all available data")
				}
			}
		}

		Kirigami.Separator {
			Kirigami.FormData.isSection: true
		}

		ConfigUnitComboBox {
			id: temperatureComboBox
			configKey: 'temperatureUnitId'
			Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label:listbox", "Temperature:")
			model: WeatherPlugin.TemperatureUnitListModel

			DisplayUnits { id: displayUnits }
			function serializeWith(nextValue) {
				displayUnits.setTemperatureUnitId(nextValue)
			}
			Component.onCompleted: {
				temperatureComboBox.populateWith(displayUnits.temperatureUnitId)
			}
		}

		Kirigami.Separator {
			Kirigami.FormData.isSection: true
		}

		RowLayout {
			Kirigami.FormData.label: i18n("Font Family:")
			ConfigFontFamily {
				configKey: 'fontFamily'
			}
			ConfigTextFormat {
				boldConfigKey: 'bold'
			}
		}

		ConfigSpinBox {
			Kirigami.FormData.label: i18n("Date:")
			configKey: "dateFontSize"
			suffix: i18nc("font size suffix", "pt")
		}

		ConfigSpinBox {
			Kirigami.FormData.label: i18n("Min/Max Temp:")
			configKey: "minMaxFontSize"
			suffix: i18nc("font size suffix", "pt")
		}

		Kirigami.Separator {
			Kirigami.FormData.isSection: true
		}

		ConfigColor {
			Kirigami.FormData.label: i18n("Text:")
			configKey: "textColor"
			defaultColor: PlasmaCore.Theme.textColor
			label: ""
		}

		ConfigColor {
			Kirigami.FormData.label: i18n("Outline:")
			configKey: "outlineColor"
			defaultColor: PlasmaCore.Theme.backgroundColor
			label: ""

			property string checkedConfigKey: "showOutline"
			Kirigami.FormData.checkable: true
			Kirigami.FormData.checked: checkedConfigKey ? plasmoid.configuration[checkedConfigKey] : false
			Kirigami.FormData.onCheckedChanged: {
				if (checkedConfigKey) {
					plasmoid.configuration[checkedConfigKey] = Kirigami.FormData.checked
				}
			}
			enabled: Kirigami.FormData.checked
		}
	}

}
