//
//  HELP.swift
//  iBeacon
//
//  Created by i-Mac on 2020/10/06.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class HELP: UIViewController {
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBAction func SETTING_VC(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
}
