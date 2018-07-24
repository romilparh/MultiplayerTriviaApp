//
//  RecoveryEmailEnterViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-07-23.
//  Copyright © 2018 Romil. All rights reserved.
//
import Foundation
import UIKit
import MessageUI

class RecoveryEmailEnterViewController: UIViewController {

    // HAVE TO ADD A CHECK IF THE USER IS REGISTERED THROUGH DATABASE IN THIS VIEW !!
    
    var eMailEnteredByUser: String = ""
    var recoveryInteger: Int = 1000
    var recoveryGrid: Int = 0

    
    @IBOutlet weak var eMailEntered: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if mail service is available or not
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        // End of checking this shit
    }
    
   // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // Generate a four digit recovery integer that is random
    func generateRecoveryCode() {
        let randomNo: Int = Int(arc4random_uniform(8999))
        print(randomNo)
        recoveryGrid = recoveryInteger + randomNo
        print(recoveryGrid)
        
        // Push this recovery grid value to the server database and then retrive it from database to check if it's same value as the user entered int the recovery verification
    }
    
    func sendEmail() {
        eMailEnteredByUser = eMailEntered.text!
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        // Configure the fields of the interface.
        composeVC.setToRecipients(["\(eMailEnteredByUser)"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello, your recovery code is \(recoveryGrid).", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "codeController")
        self.present(newViewController, animated: true, completion: nil)
    }

    @IBAction func sendRecoveryEMail(_ sender: UIButton) {
        sendEmail()
        // Go to next page: Code Verifier
    }
}

