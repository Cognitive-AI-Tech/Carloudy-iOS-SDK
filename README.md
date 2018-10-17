# Carloudy-iOS-SDK

## Description
This SDK allows a third-party developer to develop a third-party app `iOS-Swift` to use Carloudy HUD `Android` and display information customized by the developer.

## Features
* Sending messages from iOS device to Carloudy HUD.
* Speech to text
* get user location and current speed

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
To install Carloudy-iOS-SDK using [CocoaPods](https://cocoapods.org/):
1. Create a [Podfile](https://guides.cocoapods.org/syntax/podfile.html) with the following specification:
   ```ruby
   pod 'CarloudyiOS', '1.04.5'
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
   1. **appId**: (8) provided by Carloudy after user registered account(register your app and get appId at http://betastore.carloudy.com). Will define folders and start a new session belongs to the specific app.
   1. **textViewId**: (1) [0-9, a-z] ex:0, 5, c, or x. User defined display section id for distinguishing among other display sections
   1. **picId**: (2) [0-9, a-z] ex:2c, x5, 80, or az. Unique id for picture to display. **The picId must be the same as the picture name uploaded by the user** at http://betastore.carloudy.com/details
   1. For more details about format of appId, textViewId, picID, commandID, labelTextSize, postionsX,Y, width, height, please see `Notification Project.docx`.
   ```swift
   
    open func pairButtonClicked(finish: @escaping ((String)->()))
    open func startANewSession(appId: String)
    open func createIDAndViewForCarloudyHud(textViewId: String, labelTextSize: Int, postionX: Int, postionY: Int, width: Int, height: Int)
    open func createPictureIDAndImageViewForCarloudyHUD(picID: String, postionX: Int, postionY: Int, width: Int, height: Int)
    open func sendMessage(textViewId: String, message : String)
    open func sendAppCommand(commandID: String, AppID: String)
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
1. Create your own app with Carloudy-iOS-SDK installed, get an APIKey, and pair with Carloudy HUD.
    - Install Carloudy-iOS-SDK by cocoapods
    - Resgiter and grab an APIID with your app name at http://betastore.carloudy.com.
    - Pair your app with Carloudy HUD by Carloudy-iOS-SDK function.
1. You will be able to customize your app with connecting to Carloudy HUD 

## Examples
This repository also contains a sample program that exercise a variety of Carloudy-iOS-SDK features:
1. Clone the repository or download the [zip file](https://github.com/Cognitive-AI-Tech/Carloudy-iOS-SDK/archive/master.zip).
1. Open `CarloudyiOSSDK.xcodeproj`.
1. Build and run

## Contributing

We welcome feedback and code contributions! 

## License
## submit images to Server
1. http://betastore.carloudy.com
1. go signup and login
1. resgiter your app and get your app id
1. submit your images

## review images in Carloudy
1. https://github.com/Cognitive-AI-Tech/Carloudy-iOS-SDK/blob/master/Images%20Review%20Instruction.pdf


