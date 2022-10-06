# README

This demo shows how to integrate VGS Show [iOS](https://github.com/verygoodsecurity/vgs-show-ios) and [Android](https://github.com/verygoodsecurity/vgs-show-android) SDK to your Flutter app.
We don't have official Flutter package. You can easily integrate VGS Show SDK into your mobile crossplatform Flutter apps.

# Table of contents

<!--ts-->

- [Run application](#run-application)

## Run application

1. Required environment:

### Requirements

- Installed <a href="https://flutter.dev/docs/get-started/install" target="_blank">Flutter</a>
- Setup <a href="https://flutter.dev/docs/get-started/editor?tab=androidstudio" target="_blank">IDEA</a>
- Setup <a href="https://flutter.dev/docs/get-started/install/macos#install-xcode" target="_blank">Xcode</a>
- Install <a href="https://cocoapods.org/" target="_blank">Cocoapods</a> for running iOS
- Create your Organization with <a href="https://www.verygoodsecurity.com/">VGS</a>

> **_NOTE:_** Please visit Flutter <a href="https://flutter.dev/docs" target="_blank">documentation</a>
> for more detailed explanation how to setup Flutter and IDEA.</br>
> This sample is compatitable with Flutter 3.2.0 version.</br>
> Check Flutter issues <a href="https://github.com/flutter/flutter/issues" target="_blank">here.</a>

2. Setup routes.

Go to your <a href="https://dashboard.verygoodsecurity.com/" target="_blank">VGS organization</a> and establish <a href="https://www.verygoodsecurity.com/docs/getting-started/quick-integration#securing-inbound-connection" target="_blank">Inbound connection</a>. For this demo you can import pre-built route configuration:

<p align="center">
<img src="images/dashboard_routs.png" width="600">
</p>

- Find the **configuration.yaml** file inside the app repository and download it.
- Go to the **Routes** section on the <a href="https://dashboard.verygoodsecurity.com/" target="_blank">Dashboard</a> page and select the **Inbound** tab.
- Press **Manage** button at the right corner and select **Import YAML file**.
- Choose **configuration.yaml** file that you just downloaded and tap on **Save** button to save the route.

3. Install Flutter packages

```bash
flutter pub get
```

4. `cd` to `ios` folder and run

```bash
  pod install
```

5. `cd` to `lib/utils`. Find `constants.dart` file and set your `vault_id` and `environment`

```dart
class CollectShowConstants {
  static const vaultID = 'vault_id';
  static const environment = 'sandbox';
  static const revealPath = 'post';
}
```

6. Run flutter app:\
   On iOS Simulator (<a href="https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator" target="_blank">Run iOS app Flutter docs</a>).\
   On Android Simulator (<a href="https://docs.flutter.dev/get-started/install/macos#set-up-the-android-emulator" target="_blank">Run Android app Flutter docs</a>).

7. Open tab `Reveal card data with VGSShow`

8. In case of possible issues a common fix is to clean project and reinstall packages:

```bash
  flutter clean
  flutter pub get
```

9. In case of error in VS Code `Flutter VsCode error: You don't have an extension for debugging YAML` please check [this answer:](https://stackoverflow.com/a/68949816)

Click on "open a file", then navigate to the main.dart file and then click debug and run.

<p align="center">
	<img src="images/VGSShow-flutter-demo-iOS.gif?raw=true" width="200" alt="VGS Show iOS Flutter demo">
</p>
