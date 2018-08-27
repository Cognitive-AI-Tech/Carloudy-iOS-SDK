# Carloudy-iOS-SDK

## Description
This SDK allows a third-party developer to develop a third-party app `iOS-Swift` to use Carloudy HUD `Android` and display information customized by the developer.

For developers who want Android SDK ~~[click here](https://google.com)~~

For developers who want Carloudy HUD SDK ~~[click here](https://google.com)~~

## Features
* Sending messages from iOS device to Carloudy HUD.
* Speech to text
* get user location and current speed

## Installation

### Using CocoaPods

To install Carloudy-iOS-SDK using [CocoaPods](https://cocoapods.org/):
1. Create a [Podfile](https://guides.cocoapods.org/syntax/podfile.html) with the following specification:
   ```ruby
   pod 'CarloudyiOS', '1.04.3'
   ```

1. Run `pod repo update && pod install` and open the resulting Xcode workspace.

```swift
import CarloudyiOS
import CoreLocation  //for CarloudyLocation
```
```swift
let carloudyBLE = CarloudyBLE.shareInstance
let carloudySpeech = CarloudySpeech()
var carloudyLocation = CarloudyLocation(sendSpeed: true, sendAddress: true)
```

###### Class of CarloudyBLE
   ```swift
   
    open func pairButtonClicked(finish: @escaping ((String)->()))
    //pair your app with Carloudy HUD
    open func sendMessageForSplit(prefix : String, message : String, highPriority : Bool = false, coverTheFront: Bool = false)
    // customize your own prefix and message string, and calling method of `sendMessageForSplit` will send message to Carloudy HUD
    open func savePairKey()      
    open func getPairKey()
    //Carloudy-iOS-SDK will save and get your pairKey automatically, which means you just need call `pairButtonClicked` once
    open func toCarloudyApp()    
    //This will jump to Carloudy iOS APP
   ```
###### Class of CarloudySpeech
   ```swift
   open func microphoneTapped()
   open func endMicroPhone()
   open func checkText() ->String
   open func checkTextChanging() -> Bool
   ```
###### Class of CarloudyLocation
   ```swift
   public protocol CarloudyLocationDelegate {
      func carloudyLocation(speed : CLLocationSpeed)
      func carloudyLocation(locationName: String, street: String, city: String, zipCode: String, country: String)
   }
   ```

## Requirements
1. Get one [Carloudy HUD](http://www.carloudy.com/). 
1. Download iOS Carloudy app by following [the instruction](http://gettingstarted.carloudy.com/ios-platform), get an APIKey, and pair with Carloudy HUD.
    - Resgiter Carloudy-iOS-SDK and **grab an APIKey** with your app name, url scheme, and app icon image in iOS Carloudy app.
    - Launtch iOS Carloudy app, find your app name, and click, which will jump into your app. That is how your app get the   **pair key with Carloudy HUD**
1. You will be able to customize your app with connecting to Carloudy HUD 

## Examples
This repository also contains a sample program that exercise a variety of Carloudy-iOS-SDK features:
1. Clone the repository or download the [zip file](https://github.com/Cognitive-AI-Tech/Carloudy-iOS-SDK/archive/master.zip).
1. Open `CarloudyiOSSDK.xcodeproj`.
1. Build and run

## Contributing

We welcome feedback and code contributions! Please see ??????? for details.

## License

Carloudy-iOS-SDK is released under the ??????? License. See ??????? for details.
