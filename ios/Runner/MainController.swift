//
//  MainController.swift
//  Runner
//
//  Created by yanxx on 2019/11/15.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit

class MainController: FlutterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load....")
        initChannel()
    }
    
    func initChannel(){
        
        let channel = FlutterMethodChannel(name: "event", binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler { (method, FlutterResult) in
            print("call:"+method.method)
        }
    }

}
