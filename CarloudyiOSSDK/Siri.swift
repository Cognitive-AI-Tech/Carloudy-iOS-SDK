//
//  Siri.swift
//  CarloudyiOSSDK
//
//  Created by Zijia Zhai on 12/27/18.
//  Copyright © 2018 zijia. All rights reserved.
//

import UIKit

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
            if self.carloudySpeech.audioEngine.isRunning == true{
                self.createTimerForBaseSiri_checkiftextChanging()
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
        siriButtonUNClicked()
    }
    
}
