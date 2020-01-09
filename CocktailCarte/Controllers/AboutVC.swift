//
//  AboutVC.swift
//  CoctailDB
//
//  Created by Andrey Plygun on 12/4/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var swCheck: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swCheck.isOn = UserDefaults.standard.bool(forKey: "dontShowAgain")
    }
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(swCheck.isOn, forKey: "dontShowAgain")
        dismiss(animated: true, completion: nil)
    }
}
