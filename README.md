# Flutter integration with VGS Show/Collect SDK demo

These examples show how you can easily integrate VGS Collect/Show SDKs into your Flutter application and secure sensitive data with VGS.

> **_NOTE:_** VGS has native iOS & Android SDKs. This demo is just an example of how native VGS Collect/Show SDKs can be integrated into your Flutter application.

<p align="center">
    <img src="images/filled.png" width="200" height="450">    
    <img src="images/revealed.png" width="200" height="450"> 
    <img src="images/iOS/ios-filled.png" width="200" height="450" alt="ios-collect-show-flutter-bridge-sample-filled">    
    <img src="images/iOS/ios-revealed.png" width="200" height="450" alt="ios-collect-show-flutter-bridge-sample-revealed">      
</p>

## How to run it?

### Requirements

- Installed <a href="https://flutter.dev/docs/get-started/install" target="_blank">Flutter</a>
- Setup <a href="https://flutter.dev/docs/get-started/editor?tab=androidstudio" target="_blank">IDEA</a>
- Setup <a href="https://flutter.dev/docs/get-started/install/macos#install-xcode" target="_blank">Xcode</a>
- Install <a href="https://cocoapods.org/" target="_blank">Cocoapods</a> for running iOS
- Create your Organization with <a href="https://www.verygoodsecurity.com/">VGS</a>

> **_NOTE:_** Please visit Flutter <a href="https://flutter.dev/docs" target="_blank">documentation</a>
> for more detailed explanation how to setup Flutter and IDEA.</br>
> iOS sample is compatitable with Flutter 1.22.6 version.</br>
> Check Flutter issues <a href="https://github.com/flutter/flutter/issues" target="_blank">here.</a>

#### Step 1

Go to your <a href="https://dashboard.verygoodsecurity.com/" target="_blank">VGS organization</a> and establish <a href="https://www.verygoodsecurity.com/docs/getting-started/quick-integration#securing-inbound-connection" target="_blank">Inbound connection</a>. For this demo you can import pre-built route configuration:

<p align="center">
<img src="images/dashboard_routs.png" width="600">
</p>

- Find the **configuration.yaml** file inside the app repository and download it.
- Go to the **Routes** section on the <a href="https://dashboard.verygoodsecurity.com/" target="_blank">Dashboard</a> page and select the **Inbound** tab.
- Press **Manage** button at the right corner and select **Import YAML file**.
- Choose **configuration.yaml** file that you just downloaded and tap on **Save** button to save the route.

#### Step 2

Clone demo application repository.

`git clone git@github.com:verygoodsecurity/vgs-collect-show-flutter-demo.git`

#### Step 3

Setup `"<VAULT_ID>"`.

Find `MainActivity.kt` in `android` package and replace `VAULT_ID` constant with your <a href="https://www.verygoodsecurity.com/docs/terminology/nomenclature#vault" target="_blank">vault id</a>.

Find `DemoAppConfig.swift` in `iOS` package and replace `vaultId` constant with your <a href="https://www.verygoodsecurity.com/docs/terminology/nomenclature#vault" target="_blank">vault id</a>.

#### Step 4

#### Android

Run the Android application (<a href="https://flutter.dev/docs/get-started/test-drive?tab=androidstudio" target="_blank">Run Android app Flutter docs</a>).

#### iOS

Before running iOS project `cd` to flutter sample project directory, `cd ios` and run:

```ruby
pod update
```

`cd..` back to flutter sample project directory.

Run the iOS application on Simulator (<a href="https://flutter.dev/docs/get-started/install/macos#set-up-the-ios-simulator" target="_blank">Run iOS app Flutter docs</a>).

#### Step 5

Submit and reveal the form then go to the Logs tab on a Dashboard find a request and secure a payload.
Instruction for this step you can find <a href="https://www.verygoodsecurity.com/docs/getting-started/quick-integration#securing-inbound-connection" target="_blank">here</a>.
