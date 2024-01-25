# Red Bull Pixabay API Case Study

## Known Issues
* Flutter does not provide a way to display iOS-style "card bottom sheets". The only third-party solution hosted on [pub.dev](https://pub.dev/packages/sheet/versions/1.0.0-pre) is not working with the latest Flutter version. Because of that, we are using an adjusted version of this package located inside the `sheet` feature folder.
* Passing the title information (as seen in Flutter's `CupertinoPage`) to and from `CupertinoSheetPage` is not yet supported. Therefore, the sheets cannot display the title of the previous page in the back button of the `CupertinoSliverNavigationBar` and `CuperintoNavigationBar`.
* The file details view cannot be accessed via URL. Pixabay does not provide an endpoint for fetching a source via its id, which means that the information provided by the page's url (folder id and Pixabay file id) is not enough information to restore the view data. Because of that, we open the view by pushing a `CupertinoSheetPage` via `GoRouter`on top of the existing page stack.
* Sorting images and videos by their names is not possible, because Pixabay does not offer sorting by anything else than "popular" or "latest" (see [Pixabay API reference](https://pixabay.com/api/docs/).
* The [video_player](https://pub.dev/packages/video_player) package sometimes has problems streaming video sources provided by Pixabay.