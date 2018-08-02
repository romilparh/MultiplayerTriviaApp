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
    
    var questionModelArray = [QuestionModel]()
    var index: Int = 0
    var points: Int = 0
    
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var optionOne: UILabel!
    @IBOutlet weak var optionTwo: UILabel!
    @IBOutlet weak var optionThree: UILabel!
    @IBOutlet weak var optionFour: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var optionSegmentedControl: UISegmentedControl!
    
    @IBAction func returnSegmentValue(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            self.questionModelArray[index-1].userAnswer = "a"
            self.disableSegmentedControl()
        } else if (sender.selectedSegmentIndex == 1){
            self.questionModelArray[index-1].userAnswer = "b"
            self.disableSegmentedControl()
        } else if(sender.selectedSegmentIndex == 2){
            self.questionModelArray[index-1].userAnswer = "c"
            self.disableSegmentedControl()
        } else if(sender.selectedSegmentIndex == 3){
            self.questionModelArray[index-1].userAnswer = "d"
            self.disableSegmentedControl()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fbRef = Database.database().reference()
        getQuestions()
        buttonOutlet.setTitle("Next", for: .normal)
    }
    
    

    func getQuestions() {
        self.fbRef.child("questions").observe(DataEventType.value, with: {
            (snapshot) in
            
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
                
                self.questionModelArray.append(QuestionModel(question: question, option1: option1, option2: option2, option3: option3, option4: option4, correctAnswer: correctAnswer, userAnswer: ""))
                
            }
            for i in 0..<self.questionModelArray.count {
                print("question = " + self.questionModelArray[i].question
                    + ", correctAnswer = " + self.questionModelArray[i].correctAnswer)
            }
            self.updateQuestions()
        })
    }
    
    func reEnableSegmentedControl(){
        optionSegmentedControl.isUserInteractionEnabled = true
        optionSegmentedControl.alpha = 1
        optionSegmentedControl.selectedSegmentIndex = -1
    }
    
    func disableSegmentedControl(){
        optionSegmentedControl.isUserInteractionEnabled = false
        optionSegmentedControl.alpha = 0.5
    }
    
    @IBAction func onClickSubmitAnswer(_ sender: Any) {
        self.checkButtonIndex()
        
        self.reEnableSegmentedControl()
        
        if(self.index<10){
            self.updateQuestions()
        } else {
            setScore()
            submitAnswer()
        }
    }
    
    func setScore(){
        for indexValue in 1...questionModelArray.count-1{
                if(questionModelArray[indexValue].correctAnswer ==
                    questionModelArray[indexValue].userAnswer){
                    self.points = points + 1
            }
        }
    }
    
    func checkButtonIndex(){
        if(self.index == 9){
            buttonOutlet.setTitle("Submit", for: .normal)
        }
    }
    
    func updateQuestions(){
        self.labelQuestion.text = self.questionModelArray[index].question
        self.optionOne.text = "A. "+self.questionModelArray[index].optionA
        self.optionTwo.text = "B. "+self.questionModelArray[index].optionB
        self.optionThree.text = "C. "+self.questionModelArray[index].optionC
        self.optionFour.text = "D. "+self.questionModelArray[index].optionD
        self.index = self.index + 1
    }
    
    func submitAnswer() {
        let submitUserData = ["username": self.userName as Any , "correct_count": points, "date_time": ServerValue.timestamp()] as [String : Any]
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
        public public(set) var userAnswer: String?
        
        init(question: String, option1: String, option2: String,
             option3: String, option4: String, correctAnswer: String, userAnswer: String) {
            self.question = question
            self.optionA = option1
            self.optionB = option2
            self.optionC = option3
            self.optionD = option4
            self.correctAnswer = correctAnswer
            self.userAnswer = userAnswer
        }
    }
}
