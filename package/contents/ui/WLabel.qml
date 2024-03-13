import QtQuick
import org.kde.plasma.components as PlasmaComponents3

PlasmaComponents3.Label {
	font.pointSize: -1
	font.pixelSize: 12 * Screen.devicePixelRatio
	font.family: forecastLayout.fontFamily
	font.weight: forecastLayout.fontBold
	color: forecastLayout.textColor
	style: forecastLayout.showOutline ? Text.Outline : Text.Normal
	styleColor: forecastLayout.outlineColor
}
