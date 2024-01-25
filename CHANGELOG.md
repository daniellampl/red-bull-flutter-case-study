## 0.4.0
* Implemented file details view
* Added video player for video files
* Added Pixabay API `createdAt` mapping to `FileModel`
* Introduced `RbIcons` and replaced `CupertinoIcons` and image icon
* Introduced `RbNetworkImage` and `RbNetworkVideo` for displaying network video and image source
* Made `Loginview` scrollable for user input
* Added retry functionality for failed file page request to `FolderDetailsView`
* Restructured project files

## 0.3.0 
* Implemented folder details sheet view.
* Added infinite scroll pagination loading.
* Add `RbSheetWrapper` for unified sheet view appearance.
* Introduced `AppNavigator` for accessing navigation functionality throughout the app.
* Copied the source code of the [sheet](https://pub.dev/packages/sheet) package in a separate folder and adjusted the `CupertinoSheetPage` to our needs. (e.g. the `showPrevious` parameter allows us to move a pushed sheet to the very top in order to hide the previous sheet - as seen on the folder details view). The version hosted on  pub.dev does not work with the latest flutter version.

## 0.2.0
* Implemented folders view using a static data set
* Added the following base widgets: `RbListTile`, `RbScaffold`, `RbScaffoldScrollView`, `RbSpinner`

## 0.1.1
* Added Login form reset after successful authentication

## 0.1.0
* Implemented login view
* Added E-Mail and Password form validation to cover specific input [test cases](https://learn.microsoft.com/en-us/archive/blogs/testing123/email-address-test-cases)
* Added preserving user credentials and therefore authentication state in device storage using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storag)
* Added the following base widgets: `RbButton`, `RbTextFormField` 
* Introduced `RbColors` for passing colors down the widgets tree
* Set up navigation using [go_router](https://pub.dev/packages/go_router)