import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.5 as Kirigami
import org.kde.private.kquickcontrols 2.0 as KQuickControlsPrivate

import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	KQuickControlsPrivate.TranslationContext {
		id: weatherDomain
		domain: 'plasma_applet_org.kde.plasma.weather'
	}

	WeatherStationPickerDialog {
		id: stationPicker

		onAccepted: {
			plasmoid.configuration.source = source
		}
	}

	Kirigami.FormLayout {
		Layout.fillWidth: true

		RowLayout {
			Kirigami.FormData.label: weatherDomain.i18nc("@label", "Location:")
			Label {
				id: locationDisplay
				Layout.fillWidth: true
				elide: Text.ElideRight

				text: {
					var sourceDetails = plasmoid.configuration.source.split('|')
					if (sourceDetails.length > 2) {
						return weatherDomain.i18nc("A weather station location and the weather service it comes from", "%1 (%2)",
							sourceDetails[2], sourceDetails[0])
					}
					return weatherDomain.i18nc("no weather station", "-")
				}
			}
			Button {
				id: selectButton
				iconName: "edit-find"
				text: weatherDomain.i18nc("@action:button", "Select")
				onClicked: stationPicker.visible = true
			}
		}
		ConfigSpinBox {
			Kirigami.FormData.label: weatherDomain.i18nc("@label:spinbox", "Update every:")
			configKey: "updateInterval"
			suffix: weatherDomain.i18nc("@item:valuesuffix spacing to number + unit (minutes)", " min")
			stepSize: 5
			minimumValue: 30
			maximumValue: 3600
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

		ConfigCheckBox {
			configKey: "showBackground"
			text: i18n("Desktop Widget: Show background")
		}
	}

}
