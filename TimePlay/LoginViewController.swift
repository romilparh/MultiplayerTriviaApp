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

    @IBOutlet weak var eMail: UITextField!
    
    var fbRef:DatabaseReference!
    var gameId: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fbRef = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func loginUser(_ sender: UIButton) {
        if(eMail.text?.isEmpty)! {
            showAlertMessage(title: "Error", message: "Enter username")
        } else if(isValidEmail(testStr: eMail.text!)) {
            self.email = toLowerCaseEMail(email: eMail.text!)
            checkQuizTime()
        } else{
            showAlertMessage(title: "Error", message: "EMail Not Valid")
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
                print("Error retrieving data")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let quizViewConroller = segue.destination as! QuizViewController
        quizViewConroller.gameId = self.gameId
        quizViewConroller.userName = self.email
    }
    
    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
