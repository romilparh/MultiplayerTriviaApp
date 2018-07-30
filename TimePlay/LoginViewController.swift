//
//  LoginViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-07-23.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    // Need database to login here !!!
    // Need a boolean to verify if the user is logged in and has remember me on so that the email and password is saved in UserDefaults and he or she doesn't need to enter it again, it just directly logs in the user

    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    var fbRef:DatabaseReference!
    var gameId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fbRef = Database.database().reference()
    }
    
    // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func loginUser(_ sender: UIButton) {
        if(eMail.text?.isEmpty)! {
            showAlertMessage(title: "Error", message: "Enter username")
        } else {
            checkQuizTime()
        }
    }

    func checkQuizTime() {
        self.fbRef.child("quiz_time").observe(DataEventType.value, with: {
            (snapshot) in
            if let response = snapshot.value as? [String: AnyObject] {
                let shouldStartPlay = response["should_start_play"] as! String
                let message = response["message"] as! String
                print("shouldStartPlay = " + shouldStartPlay)
                self.gameId = response["game_id"] as? String
                print("gameid = " + self.gameId!)
                if(shouldStartPlay == "1") {
                    self.performSegue(withIdentifier: "loginToQuizIdentifier", sender: self)
                } else {
                    self.showAlertMessage(title: "Game Error:", message: message)
                }
            } else {
                print("Error retrieving data") // snapshot value is nil
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let quizViewConroller = segue.destination as! QuizViewController
        quizViewConroller.gameId = self.gameId
        quizViewConroller.userName = self.eMail.text
    }
    
    func showAlertMessage(title: String, message: String) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
}
