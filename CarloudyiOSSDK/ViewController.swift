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



class ViewController: UIViewController, CarloudyLocationDelegate {
    
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
        // register your app and get your appId at betastore.carloudy.com
        carloudyBLE.startANewSession(appId: "a5ef3350")
        carloudyBLE.createIDAndViewForCarloudyHud(textViewId: "1", labelTextSize: 32, postionX: 36, postionY: 36, width: 42, height: 00)
    }
    
    @IBAction func getWeatherButtonClicked(_ sender: Any) {
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
                print(error)
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
    
    @IBOutlet weak var textLabel: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        carloudyBLE.sendMessage(textViewId: "1", message: textLabel.text!)
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
            sendSpeedAndAddress.setTitle("sending", for: .normal)
        }else{
            sendSpeedAndAddress.setTitle("sendSpeedAndAddress", for: .normal)
            carloudyLocation.locationManager.stopUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
}


///do siri stuff
extension ViewController{
    
    func siriButtonClicked(){
        carloudySpeech.microphoneTapped()
        self.createTimerForBaseSiri_checkText()
        self.delay3Seconds_createTimer()
        siriButton.setTitle("listening", for: .normal)
        siriButton.setTitleColor(UIColor.red, for: .normal)
        siriButton.isEnabled = false
    }
    
    func siriButtonUNClicked(){
        carloudySpeech.endMicroPhone()
        siriButton.setTitle("end", for: .normal)
        siriButton.isEnabled = true
        timer_checkTextIfChanging?.invalidate()
        timer_forBaseSiri_inNavigationController.invalidate()
    }
    
    fileprivate func delay3Seconds_createTimer(){
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            // 因为这里要延迟2秒。会出现已经说yes， 已经invalidate timer 然后进来 重新创建timer情况， 所以先判断audioengine isrunning
            if self.carloudySpeech.audioEngine.isRunning == true{
                self.createTimerForBaseSiri_checkiftextChanging()   // 延长3秒 在check 是否user 还在说
            }
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkiftextChanging(){
        if timer_checkTextIfChanging == nil{
            timer_checkTextIfChanging?.invalidate()
            timer_checkTextIfChanging = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkTextIsChanging), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkText(){
        timer_forBaseSiri_inNavigationController.invalidate()
        timer_forBaseSiri_inNavigationController = Timer(timeInterval: 0.5, repeats: true, block: { [weak self](_) in
            self?.textReturnedFromSiri = (self?.carloudySpeech.checkText().lowercased())!
            self?.textLabel.text = self?.textReturnedFromSiri
            if self?.textReturnedFromSiri != ""{
                self?.createTimerForBaseSiri_checkiftextChanging()
            }
        })
        RunLoop.current.add(timer_forBaseSiri_inNavigationController, forMode: .commonModes)
    }
    
    @objc func checkTextIsChanging(){
        guard carloudySpeech.checkTextChanging() == false else {return}
        // 如果user 不说话了
        siriButtonUNClicked() // 如果不说话了， 现在先销毁timer
    }
    
}


