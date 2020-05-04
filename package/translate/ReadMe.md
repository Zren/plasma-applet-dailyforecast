> Version 6 of Zren's i18n scripts.

With KDE Frameworks v5.37 and above, translations are bundled with the `*.plasmoid` file downloaded from the store.

## Install Translations

Go to `~/.local/share/plasma/plasmoids/com.github.zren.dailyforecast/translate/` and run `sh ./build --restartplasma`.

## New Translations

1. Fill out [`template.pot`](template.pot) with your translations then open a [new issue](https://github.com/Zren/plasma-applet-dailyforecast/issues/new), name the file `spanish.txt`, attach the txt file to the issue (drag and drop).

Or if you know how to make a pull request

1. Copy the `template.pot` file and name it your locale's code (Eg: `en`/`de`/`fr`) with the extension `.po`. Then fill out all the `msgstr ""`.

## Scripts

* `sh ./merge` will parse the `i18n()` calls in the `*.qml` files and write it to the `template.pot` file. Then it will merge any changes into the `*.po` language files.
* `sh ./build` will convert the `*.po` files to it's binary `*.mo` version and move it to `contents/locale/...` which will bundle the translations in the `*.plasmoid` without needing the user to manually install them.
* `sh ./plasmoidlocaletest` will run `./build` then `plasmoidviewer` (part of `plasma-sdk`).

## Links

* https://techbase.kde.org/Development/Tutorials/Localization/i18n_Build_Systems

## Examples

* https://websvn.kde.org/trunk/l10n-kf5/fr/messages/kde-workspace/
* https://github.com/psifidotos/nowdock-plasmoid/tree/master/po
* https://github.com/kotelnik/plasma-applet-redshift-control/tree/master/translations

## Status
|  Locale  |  Lines  | % Done|
|----------|---------|-------|
| Template |      16 |       |
| de       |    3/16 |   18% |
| el       |    3/16 |   18% |
| es       |   10/16 |   62% |
| fr       |    3/16 |   18% |
| id       |    2/16 |   12% |
| ko       |    2/16 |   12% |
| nl_NL    |   14/16 |   87% |
| pl       |    3/16 |   18% |
| pt_BR    |    6/16 |   37% |
| ru       |    3/16 |   18% |
| uk       |    3/16 |   18% |
| zh_CN    |    3/16 |   18% |
