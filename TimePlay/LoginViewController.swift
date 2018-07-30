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
        checkQuizTime()
        getQuestions()
    }
    
    // To toggle software keyboard when clicked outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func loginUser(_ sender: UIButton) {
        let x = ["username": "chitrang@gmail.com" , "correct_count": 7 , "date_time": ServerValue.timestamp()] as [String : Any]
        
        self.fbRef.child(self.gameId!).childByAutoId().setValue(x)
    }

    func checkQuizTime() {
        self.fbRef.child("quiz_time").observe(DataEventType.value, with: {
            (snapshot) in
            let x = snapshot.value as! [String:Any]
            
            let u = x["message"]
            let m = x["shoul_play"]
            self.gameId = x["game_id"] as? String
            
            print("message = \(u!), shoul_play = \(m!)")
            self.resultObserver()
            
        })
    }
    
    func getQuestions() {
        self.fbRef.child("questions").observe(DataEventType.value, with: {
            (snapshot) in
            
            for snap in snapshot.children {
                let x = snap as! DataSnapshot
                let u = x.key
                let m = x.value as! [String:Any]
                
                print("question key = \(u), question value = \(m["answer"])")
            }
        })
    }
    
    func resultObserver() {
        self.fbRef.child(self.gameId!)
            .queryOrdered(byChild: "correct_count")
//            .queryOrdered(byChild: "date_time")
            .queryLimited(toFirst: 10)
            .observe(DataEventType.value, with: {
            (snapshot) in
            
            for snap in snapshot.children {
                let x = snap as! DataSnapshot
                let u = x.key
                let m = x.value as! [String:Any]
                
                print("result key = \(u), result value = \(m)")
            }
        })
    }
}
