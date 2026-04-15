# Changelog

## 1.0.6
- Added manual sync instructions in `readme.md`

## 1.0.5
- Added support for manual sync triggers. Users can now force a sync instantly by creating a `/config/.sync_now` file. Ideal for creating a custom dashboard button using `shell_command`.

## 1.0.4
- Added English, Dutch, and French titles and detailed descriptions to the configuration UI to help users fill out the options correctly.

## 1.0.3
- Add CHANGELOG.md

## 1.0.2
- Changed the add-on description to English for better accessibility.
- Internal documentation updates.

## 1.0.1
- Added support for custom `target_paths`. Users can now specify which files and folders to sync via the configuration UI.
- Improved error handling for missing files.
- Added automatic `git pull` functionality for two-way synchronization.

## 1.0.0
- Initial release.
- Automatic backup of `configuration.yaml` and `template/` folder to GitHub.
- Configurable sync intervals.