import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami

import "../libweather" as LibWeather
import "../libconfig" as LibConfig

Kirigami.FormLayout {
	Layout.fillWidth: true

	LibWeather.ConfigWeatherStationPicker {
		configKey: 'source'
	}
	LibWeather.WeatherStationCredits {
		id: weatherStationCredits
	}

	LibConfig.SpinBox {
		Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label:spinbox", "Update every:")
		configKey: "updateInterval"
		suffix: i18ndc("plasma_applet_org.kde.plasma.weather", "@item:valuesuffix spacing to number + unit (minutes)", " min")
		stepSize: 5
		from: 30
		to: 3600
	}

	LibConfig.CheckBox {
		configKey: "showWarnings"
		text: i18n("Show weather warnings")
	}

	LibConfig.CheckBox {
		configKey: "showBackground"
		text: i18n("Desktop Widget: Show background")
	}

	LibConfig.CheckBox {
		configKey: "showDailyBackground"
		text: i18n("Show background around each day")
	}

	RowLayout {
		Kirigami.FormData.label: i18n("Days Visible:")

		LibConfig.SpinBox {
			id: showNumDays
			configKey: "showNumDays"
			stepSize: 1
			from: 0
			to: 14
			
			readonly property bool isShowingAll: showNumDays.configValue == 0
		}

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

			QQC2.Label {
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

	RowLayout {
		Kirigami.FormData.label: i18n("Font Family:")
		LibConfig.FontFamily {
			configKey: 'fontFamily'
		}
		LibConfig.TextFormat {
			boldConfigKey: 'bold'
		}
	}

	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Date:")
		configKey: "dateFontSize"
		suffix: i18nc("font size suffix", "pt")
	}

	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Min/Max Temp:")
		configKey: "minMaxFontSize"
		suffix: i18nc("font size suffix", "pt")
	}

	Kirigami.Separator {
		Kirigami.FormData.isSection: true
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Text:")
		configKey: "textColor"
		defaultColor: PlasmaCore.Theme.textColor
	}


	RowLayout {
		Kirigami.FormData.label: i18n("Outline:")
		Layout.fillWidth: true
		LibConfig.CheckBox {
			id: showOutline
			configKey: "showOutline"
		}
		LibConfig.ColorField {
			Layout.fillWidth: true
			configKey: "outlineColor"
			defaultColor: PlasmaCore.Theme.backgroundColor
			enabled: showOutline.checked
		}
	}
}
