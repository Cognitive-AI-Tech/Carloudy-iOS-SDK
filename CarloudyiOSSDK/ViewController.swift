//
//  ViewController.swift
//  CarloudyiOSSDK
//
//  Created by Cognitive AI Technologies on 5/14/18.
//  Copyright © 2018 zijia. All rights reserved.
//

import UIKit
import CoreLocation
import CarloudyiOS
import Popover

// register your app and get your appId at betastore.carloudy.com
fileprivate let AppID = "86kbwkvk"

class ViewController: UIViewController {
    
    let carloudyBLE = CarloudyBLE.shareInstance
    let carloudySpeech = CarloudySpeech()
    var carloudyLocation = CarloudyLocation(sendSpeed: true, sendAddress: true)
    weak var timer_checkTextIfChanging : Timer?
    var timer_forBaseSiri_inNavigationController = Timer()  ///每0.5秒 检测说的什么
    var textReturnedFromSiri = ""
    
    @IBOutlet weak var pairButton: UIButton!
    @IBAction func pairButtonClicked(_ sender: Any) {
        pairButton.isEnabled = false
        carloudyBLE.pairButtonClicked {[weak self] (pairKey) in
            self?.pairButton.isEnabled = true
            self?.pairButton.setTitle("pair key : \(pairKey)", for: .normal)
        }
    }
    
    @IBAction func startNewSessionAndCreateView(_ sender: Any) {
        carloudyBLE.startANewSession(appId: AppID)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "1", labelTextSize: 32, postionX: 36, postionY: 36, width: 42, height: 00)
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "2", labelTextSize: 32, postionX: 56, postionY: 56, width: 42, height: 00)
    }
    
    @IBAction func getWeatherButtonClicked(_ sender: Any) {
        getWeather()
    }
    
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButtonClicked(_ sender: Any) {
        carloudyBLE.sendMessage(textViewId: "1", message: textLabel.text!)
                carloudyBLE.sendMessage(textViewId: "2", message: "321")
        carloudyBLE.createPictureIDAndImageViewForCarloudyHUD(picID: "ad", postionX: 20, postionY: 20, width: 50, height: 50)
    }
    
    @IBAction func gotoCarloudyClicked(_ sender: Any) {
        carloudyBLE.toCarloudyApp()
    }
    
    @IBOutlet weak var siriButton: UIButton!
    @IBAction func siriButtonClicked(_ sender: Any) {
        siriButtonClicked()
    }
    
    @IBOutlet weak var sendSpeedAndAddress: UIButton!
    @IBAction func sendSpeedAndAddressClicked(_ sender: Any) {
        if sendSpeedAndAddress.titleLabel?.text != "sending"{
            carloudyLocation.delegate = self
            carloudyLocation.locationManager.requestAlwaysAuthorization()
            carloudyLocation.locationManager.startUpdatingLocation()
            carloudyLocation.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            sendSpeedAndAddress.setTitle("sending", for: .normal)
        }else{
            sendSpeedAndAddress.setTitle("sendSpeedAndAddress", for: .normal)
            carloudyLocation.locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func pairHelpButton(_ sender: Any) {
        let text = "First, you need to make sure SDK and Carloudy HUD are already paired.\n\nHOW?\nGo to Carloudy HUD Pair Screen and Choose iPhone Mode, then click this Pair button.\n\nHint: You only need to pair them once, the pair key will be automaticlly saved.\n\nFor help of pairing:\n1. https://gettingstarted.carloudy.com/ios-platform\n2. https://www.youtube.com/watch?v=jK-jlyjAfVw\n3. Check Carloudy iOS App Introduction/Setup page"
        createPopOverView(startView: sender as! UIView, text: text, height: 400)
    }
    
    @IBAction func newSessionButton(_ sender: Any) {
        let text = "This button will send AppId to Carloudy HUD, and create a specfic textView on Carloudy HUD.\n\nMinimum staying alive timer for display session is 60 secs. Without receiving any new message, customized display will exit. After exit, session expires, user must restart a new session"
        createPopOverView(startView: sender as! UIView, text: text, height: 220)
    }
    
    @IBAction func getWeatherHelp(_ sender: Any) {
        let text = "You can type some text or get the weather into the orange textLabel"
        createPopOverView(startView: sender as! UIView, text: text, height: 100)
    }
    
    @IBAction func sendHelpButton(_ sender: Any) {
        let text = "This button will send the text of the orange textLabel to Carloudy HUD. \n\nThe text sent will be shown at the textView you created in Carloudy HUD."
        createPopOverView(startView: sender as! UIView, text: text, height: 150)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.delegate = self
        self.title = "SDK Sample"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Images", style: .plain, target: self, action: #selector(updateImagesButtonClicked))
    }
    
    @objc fileprivate func updateImagesButtonClicked(){
        let updateVC =  UpdateImagesViewController()
        navigationController?.pushViewController(updateVC, animated: true)
    }
    
    fileprivate func createPopOverView(startView : UIView, text : String, height: Int){
        let aView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(height)))
        aView.text = text
        aView.numberOfLines = 0
        aView.textColor = UIColor.darkGray
        aView.adjustsFontSizeToFitWidth = true
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        popover.popoverType = .down
        popover.show(aView, fromView: startView)
    }
}



// MARK:- apicall
extension ViewController{
    fileprivate func getWeather(){
        let str = "http://api.openweathermap.org/data/2.5/weather?lat=41.889249&lon=-87.630182&APPID=76d9dff8a633f10f3c5944948d84bd8b"
        print(str)
        let urlstr = URL(string: str)
        _ = URLRequest(url: urlstr!)
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        session.dataTask(with: urlstr!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            if let result = String.init(data: data!, encoding: String.Encoding.utf8){
                if let data = result.data(using: String.Encoding.utf8) {
                    do {
                        let resultDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let weather : Array<Dictionary<String,AnyObject>> = resultDic!["weather"] as? Array<Dictionary<String,AnyObject>>{
                            let weatherFirst : [String : AnyObject] = weather[0]
                            if let main = weatherFirst["main"] as? String{
                                DispatchQueue.main.async {
                                    self.textLabel.text = main
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            }.resume()
    }
}


// MARK:- CarloudyLocationDelegate
extension ViewController: CarloudyLocationDelegate, UITextFieldDelegate{
    func carloudyLocation(speed: CLLocationSpeed) {
        carloudyBLE.sendMessage(textViewId: "1", message: String(speed), highPriority: true, coverTheFront: false)
    }
    
    func carloudyLocation(locationName: String, street: String, city: String, zipCode: String, country: String) {
        carloudyBLE.sendMessage(textViewId: "1", message: "\(locationName) \(street)")
        print(locationName)
        print("---------")
        print(street)
        print(city)
        print(zipCode)
        print(country)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textLabel.resignFirstResponder()
        return true
    }
}




