# Red Bull Pixabay API Case Study

Welcome to my case study project for the "Mobile Software Engineer - Flutter" position at Red Bull!

This project showcases Flutter proficiency, offering Pixabay image and video query capabilities with preview functionalities for authenticated users.

## Getting Started

### Prerequisites

Before you begin, make sure you have the latest Flutter SDK installed on your local machine. See [Flutter install guideline](https://docs.flutter.dev/get-started/install) for more information.

### Environment Variables

This Flutter application relies on the following environment variables:

| Variable Name     | Description                                                                                                                                                                      |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PIXABAY_API_KEY` | A public API key linked to a Pixabay user used for communicating with the Pixabay API. See [the Pixabay API documentation](https://pixabay.com/api/docs/) for more information.  |

Make sure to set them before running the app by passing them via `--dart-define` into the application runtime. Here is a template ready to apply to your 'flutter build' (or 'run') command or to your IDE's run configuration:

```
--dart-define=PIXABAY_API_KEY=[YOUR_PIXABAY_API_KEY]
```

### Download
Don't want to set up the app for development or build it on your local machine? I got you covered! You can download a fresh Android build from [Google Drive](https://drive.google.com/drive/folders/1DTiVM2MQKAS_FdA7y_q8-8DX0lEoaa6N?usp=sharing). 🔥

---

## Features

### Login & Authentication

For the sake of demonstration, the login is not backed by a real authentication provider. Users are therefore considered authenticated if they enter valid user credentials and if the credentials are available in the app's state.

Once users enter valid credentials and submit them, they get redirected to the authenticated section of the application. If they try to navigate to an authenticated route without being authenticated, they will get redirected back to the login.

User credentials are stored in the application's device storage using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) via the iOS [Keychain](https://developer.apple.com/documentation/security/keychain_services#//apple_ref/doc/uid/TP30000897-CH203-TP1) and Android's [EncryptedSharedPreferences](https://developer.android.com/privacy-and-security/security-tips). On start, the app reads previously stored user credentials and sends the user directly to the authenticated section of the app if credentials are available. The stored user credentials are deleted if the user navigates back to the login view.

#### E-Mail Validation

We use the following regular expression for validating user-entered email addresses ([inspired by](https://emailregex.com/index.html)):

```
(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])
```

Valid email examples:
* peter@microsoft.com
* steve.creek@mydomain.net
* daniel@123.123.123.123
* [see more](https://learn.microsoft.com/en-us/archive/blogs/testing123/email-address-test-cases)

#### Password Validation

A password is considered valid if it meets the following conditions:
* at least 8 characters long
* contains at least one special character
* contains at least one uppercase letter
* contains at least one number

We use the following regular expression for validating user-entered passwords:

```
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|:;<>,.?/~`]).{8,}$
```

### Files

We utilize the [Pixabay API](https://pixabay.com/api/docs/) for querying images and videos. Both image and video responses are parsed into model objects representations, which are then used throughout the application.

```dart
@immutable
abstract class FileModel {
  const FileModel({
    required this.id,
    required this.height,
    required this.url,
    required this.thumbnail,
    required this.width,
    this.createdAt,
  });

  final DateTime? createdAt;
  final int height;
  final int id;
  final Uri thumbnail;
  final Uri url;
  final int width;

  double get aspectRatio => width / height;
  String get filename;
  String get resolution => '${width}x$height';
}

@immutable
class PhotoFileModel extends FileModel {
  const PhotoFileModel._({
    required super.height,
    required super.id,
    required super.url,
    required super.thumbnail,
    required super.width,
    super.createdAt,
  });

  @override
  String get filename => ...;
}

@immutable
class VideoFileModel extends FileModel {
  const VideoFileModel._({
    required this.duration,
    required super.height,
    required super.id,
    required super.thumbnail,
    required super.url,
    required super.width,
    super.createdAt,
  });

  final Duration duration;

  @override
  String get filename => ...;
}
```

The following table explains how the values received from the [Pixabay API](https://pixabay.com/api/docs/) gets mapped to our models:

| Model field             | Pixabay image property                                                                                       | Pixabay video property                                                                                              |
|-------------------------|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| `createdAt`             | Extracted from `previewURL` </br> (e.g., https://cdn.pixabay.com/photo/2018/04/20/09/49/sky-3335585_150.jpg) | Extracted from `userImageURL` </br> (e.g., https://cdn.pixabay.com/user/2013/11/05/02-10-23-764_250x250.jpg)        |
| `filename`              | File name of the `thumbnail`                                                                                 | File name of the `url` from the `large` video source in the `videos` list (`large` is optional - fallback `medium`) |
| `height`                | `imageHeight`                                                                                                | `height` from the `large` video source in the `videos` list (`large` is optional - fallback `medium`)               |
| `id`                    | `id`                                                                                                         | `id`                                                                                                                |
| `url`                   | `largeImageURL`                                                                                              | `url` from the `large` video source in the `videos` list (`large` is optional - fallback `medium`)                  |
| `thumbnail`             | `previewURL`                                                                                                 | `picture_id` combined with `https://i.vimeocdn.com/video/{ PICTURE_ID }_250x250.jpg`                                |
| `width`                 | `imageWidth`                                                                                                 | `width` from the `large` video source in the `videos` list (`large` is optional - fallback `medium`)                | 
| `duration` (video only) | -                                                                                                            | `duration` in seconds                                                                                               |

---

## Styling and UI

### Colors

In order to centrally define colors and provide them to the widget tree, we use a custom `InheritedWidget`called `RBColors`. This allows us 
switch out the color configuration, if the state of the app changes (e.g. user switches from light, to dark mode).

To make it accessible for all descendants (even the navigation) we wrap the  widget tree as far top as possible. To access the colors, all 
we need to do is access the nearest `RbColors` instance via the `BuildContext`:

```dart
Container(
  color: RbColors.of(context).primary,
  child: ...
),
```

### Fonts

Globally defined `TextStyle`s can be used by calling a font styles corresponding "accessor" function using the `BuildContext`.

```dart
Text(
  'some text',
  style: textSmallOf(context)
)
```

Since font definitions use `RbColors` for defining their colors, we can only access the `TextStyle` by providing a `BuildContext`.

The letter spacing of Flutter's default `TextStyle` for the cupertino `navLargeTitleTextStyle` arguably looks a a little bit of. To fix that we overwrite the 
`CupertinoThemeData` with our own `TextStyle` provided by the `titleBigOf` accessor.

```dart
CupertinoApp(
  // ...
  theme: CupertinoThemeData(
    // ...
    navLargeTitleTextStyle: titleBigOf(context),
  ),
)
```

### Icons

All vectors used in the prototype got transformed into a custom icon using [icomoon.io](https://icomoon.io/). The reason for this is, that Flutter does not support svg rendering 
without the help of a third party package (like [flutter_svg](https://pub.dev/packages/flutter_svg)).

The icon font gets loaded as a flutter asset...

```yaml
flutter:
  assets:
    - ...
    - assets/fonts/
  fonts:
    - family: RbIcons
      fonts:
        - asset: assets/fonts/icons.ttf
```

... and exposed via a custom class called `RbIcons` by access the `codePoint` of every icon in the
icon font.

```dart
class RbIcons {
  // ...
  
  static const IconData mail = IconData(0xe900, fontFamily: 'RbIcons');
  // ...
}
```

Using an icon font is more performant and plugs directly into Flutter's intended way of displaying icons (`IconData` rendered by the `Icon`
widget). Plus, the icons will automatically use a color provided via an `IconTheme` widget above (like `CupertinoApp` does it).

```dart
Icon(
  RbIcons.mail,
  ...
)
```

---

## Known Issues
* Flutter does not provide a way to display iOS-style "card bottom sheets". The only third-party solution hosted on [pub.dev](https://pub.dev/packages/sheet/versions/1.0.0-pre) is not working with the latest Flutter version. Because of that, we are using an adjusted version of this package located inside the `sheet` feature folder.
* Passing the title information (as seen in Flutter's `CupertinoPage`) to and from `CupertinoSheetPage` is not yet supported. Therefore, the sheets cannot display the title of the previous page in the back button of the `CupertinoSliverNavigationBar` and `CupertinoNavigationBar`. This results in the file details view showing 'close' as the leading action, instead of a back button with the previousPageTitle being the title of the previous page in the navigation stack.
* The file details view cannot be accessed via URL. Pixabay does not provide an endpoint for fetching a source via its ID, which means that the information provided by the page's URL (folder ID and Pixabay file ID) is not enough information to restore the view data. Because of that, we open the view by pushing a `CupertinoSheetPage` via `GoRouter` on top of the existing page stack.
* Sorting images and videos by their names is not possible because Pixabay does not offer sorting by anything else than "popular" or "latest" (see [Pixabay API reference](https://pixabay.com/api/docs/)).
* The [video_player](https://pub.dev/packages/video_player) package sometimes has problems streaming video sources provided by Pixabay.

---

## Contributing
If you would like to contribute to this project, feel free to do so. Our contribution guidelines (for now) are common sense 😉

If you come across any bugs or other problems or if you have a feature request, feel free to file an issue. Any help is very appreciated.

---

Mady with 💙 by Daniel Lampl