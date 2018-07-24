//
//  LoginViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-07-23.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Need database to login here !!!
    // Need a boolean to verify if the user is logged in and has remember me on so that the email and password is saved in UserDefaults and he or she doesn't need to enter it again, it just directly logs in the user

    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func loginUser(_ sender: UIButton) {
        
    }

}
