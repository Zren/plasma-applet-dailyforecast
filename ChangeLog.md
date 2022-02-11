## v6 - February 13 2022

* Port to `QtQuick.Controls 2.0`, `PlasmaComponents 3.0`, and `Kirigami` config. Should work in Ubuntu 20.04 with Qt 5.12 and KDE Frameworks 5.68.
* Merge changes to weather widget from upstream KDE weather widget.
* Port missing `ServiceListModel` in Plasma 5.24 to use the `weatherDataSource.data['ions']` to get the list of weather data websites.
* Use PlasmaCore Unit/Theme singletons.
* Refactor dailyForecastModel to check if data exists.
* Update i18n scripts.
* Add Croatian translations by @VladimirMikulic (synced from simpleweather)
* Add Slovenian translations by @Ugowsky (synced from simpleweather)
* Updated Russian translations by @Morion-Self (synced from condensedweather)

## v5 - May 6 2020

* Revert min/max temp shown in a column (v4) instead of a single row (v3 and below).

## v4 - May 5 2020

* Support changing units (eg: Celsius to Fahrenheit) (https://github.com/Zren/plasma-applet-simpleweather/issues/15)
* Use 2 rows for EnvCan (day/night).
* Only show 5 days at most by default.
* Add "Refresh" to the contextmenu.
* Fix scrollbar overlap in settings.

## v3 - November 12 2019

* Show forecast label when hovering in a tooltip.
* Add ability to show weather warnings (envcan only) like simpleweather, however it's disabled by default.
* Add ability to change the text color (Issue #5) + text outline.
* Add ability to change font sizes.
* Sync weather code with simpleweather.
* Updated Dutch translations by @Vistaus (Pull Request #4 + #6)
* Reuse common translations from simpleweather.

## v2 - February 2 2019

* Fixed compatibility with openSUSE Leap with Plasma 5.12 / KDE Frameworks 5.45 / Kirigami 2.4 (Issue #1)
* Added Dutch translation (Pull Request #2)

## v1 - February 1 2019

* Forked from "Simple Weather" widget v2.
* Display daily forecast icon + min/max temp.
* Optionally show an individual background behind each day.
* Optionally limit the number of days visible.
