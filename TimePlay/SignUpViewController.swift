//
//  SignUpViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-07-23.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
 
    // Need database to sign up !!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

}
