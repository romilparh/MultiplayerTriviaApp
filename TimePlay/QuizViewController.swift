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
            
            var questionModelArray = [QuestionModel]()
            
            for snap in snapshot.children {
                let response = snap as! DataSnapshot
                //                    let u = x.key
                //                    let m = x.value as! [String:Any]
                //                    print("question key = \(u), question value = \(m)")
                
                let question = response.childSnapshot(forPath: "question").value as! String
                let option1 = response.childSnapshot(forPath: "a").value as! String
                let option2 = response.childSnapshot(forPath: "b").value as! String
                let option3 = response.childSnapshot(forPath: "c").value as! String
                let option4 = response.childSnapshot(forPath: "d").value as! String
                let correctAnswer = response.childSnapshot(forPath: "answer").value as! String
                
                questionModelArray.append(QuestionModel(question: question, option1: option1, option2: option2, option3: option3, option4: option4, correctAnswer: correctAnswer))
                
            }
            for i in 0..<questionModelArray.count {
                print("question = " + questionModelArray[i].question
                    + ", correctAnswer = " + questionModelArray[i].correctAnswer)
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
    
    class QuestionModel {
        public private(set) var question: String
        public private(set) var optionA: String
        public private(set) var optionB: String
        public private(set) var optionC: String
        public private(set) var optionD: String
        public private(set) var correctAnswer: String
        
        init(question: String, option1: String, option2: String,
             option3: String, option4: String, correctAnswer: String) {
            self.question = question
            self.optionA = option1
            self.optionB = option2
            self.optionC = option3
            self.optionD = option4
            self.correctAnswer = correctAnswer
        }
    }
}
