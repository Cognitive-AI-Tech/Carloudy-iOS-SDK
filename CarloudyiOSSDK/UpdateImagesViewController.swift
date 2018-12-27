//
//  UpdateImagesViewController.swift
//  CarloudyiOSSDK
//
//  Created by Zijia Zhai on 12/27/18.
//  Copyright © 2018 zijia. All rights reserved.
//

import UIKit
import CarloudyiOS

class UpdateImagesViewController: UIViewController {
    
    let carloudyBLE = CarloudyBLE.shareInstance

    let textLabel1: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "1. If you want to display image on Carloudy HUD, you need upload the image at betastore.carloudy.com first. \n\n2. After pair your Carloudy App and Carloudy HUD\n\n3. Send your WIFi to Carloudy"
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Send Wifi", for: .normal)
        button.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let textLabel2: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "4. Check your Carloudy HUD, after you see WIFI Connected Successfully, you can update images to Carloudy"
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    let textLabel3: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = "5. Check your Carloudy HUD, after you see Image Download Successfully, you can test(send the same picID with image name) and see the images in Carloudy"
        tl.font = UIFont.boldSystemFont(ofSize: 15)
        tl.textColor = .black
        return tl
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Update images", for: .normal)
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI(){
        self.view.backgroundColor = UIColor.background
        let zjScreenWidth = UIScreen.main.bounds.size.width
        
        self.view.addSubview(textLabel1)
        textLabel1.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
        self.view.addSubview(sendButton)
        sendButton.anchor(top: textLabel1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 50)
        self.view.addSubview(textLabel2)
        textLabel2.anchor(top: sendButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
        self.view.addSubview(downloadButton)
        downloadButton.anchor(top: textLabel2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 50)
        self.view.addSubview(textLabel3)
        textLabel3.anchor(top: downloadButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth - 40, height: 0)
    }
    
    @objc func sendButtonClicked(){
        carloudyBLE.alertViewToUpdateImagesFromServer()
    }
    
    @objc fileprivate func downloadButtonClicked(){
        //startANewSession also let Carloudy HUD download the images
        carloudyBLE.startANewSession(appId: "86kbwkvk")
        carloudyBLE.startANewSession(appId: "86kbwkvk")
    }
}



extension UIColor{
    class var background: UIColor {
        //        return UIColor(r: 242, g: 242, b: 242)
        return UIColor(displayP3Red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

