//
//  RecoveryCodeEnterViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-07-23.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit

class RecoveryCodeEnterViewController: UIViewController {

    // Fetch Recovery code from online database and check it here!! put value in boolean: isSameCode
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

}
