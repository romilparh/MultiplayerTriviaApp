//
//  QuizViewController.swift
//  TimePlay
//
//  Created by Chitrang Patel on 2018-07-30.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class QuizViewController: UIViewController {

    var fbRef:DatabaseReference!
    var gameId: String?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fbRef = Database.database().reference()
        getQuestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    @IBAction func onClickSubmitAnswer(_ sender: Any) {
        submitAnswer()
    }
    
    func submitAnswer() {
        let totalCorrectAnswers = arc4random_uniform(10) + 1;
        let submitUserData = ["username": self.userName as Any , "correct_count": totalCorrectAnswers, "date_time": ServerValue.timestamp()] as [String : Any]
        print("gameid = " + self.gameId!)
        self.fbRef.child(self.gameId!).childByAutoId().setValue(submitUserData)
        self.performSegue(withIdentifier: "quizToResultIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let resultViewConroller = segue.destination as! ResultViewController
        resultViewConroller.gameId = self.gameId
    }
}
