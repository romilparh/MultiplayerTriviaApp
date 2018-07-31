//
//  ResultViewController.swift
//  TimePlay
//
//  Created by Chitrang Patel on 2018-07-30.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResultViewController: UIViewController {

    var fbRef:DatabaseReference!
    var gameId: String?
    
    @IBOutlet weak var resultTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fbRef = Database.database().reference()
        print("gameid r = " + self.gameId!)
        resultObserver()
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

    func resultObserver() {
        self.fbRef.child(self.gameId!)
            .queryOrdered(byChild: "correct_count")
                        .observe(DataEventType.value, with: {
                (snapshot) in
                var resultModelArray = [ResultModel]()
                            
                for snap in snapshot.children {
                    let response = snap as! DataSnapshot
//                    let u = response.key
//                    let m = response.value as! [String:Any]
//                    print("result key = \(u), result value = \(m)")
                    
                    let userName = response.childSnapshot(forPath: "username").value as! String
                    let correctCount = response.childSnapshot(forPath: "correct_count").value as! Int
                    let dateTime = response.childSnapshot(forPath: "date_time").value as! Double

                    resultModelArray.append(ResultModel(userName: userName,
                                                        correctCount: correctCount,
                                                        dateTime: dateTime))
                    
                }
                            resultModelArray.sort(by: {$0.correctCount > $1.correctCount})
                                    self.resultTV.text = ""
                for i in 0..<resultModelArray.count {
                    print("userName = " + resultModelArray[i].userName
                    + ", correctCount = " + String(resultModelArray[i].correctCount))
                    self.resultTV.text.append("userName = " + resultModelArray[i].userName
                        + ", correctCount = " + String(resultModelArray[i].correctCount) + "\n")
                }
            })
    }
    
    class ResultModel {
        public private(set) var userName: String
        public private(set) var correctCount: Int
        public private(set) var dateTime: Double
        
        init(userName: String, correctCount: Int, dateTime: Double) {
         self.userName = userName
            self.correctCount = correctCount
            self.dateTime = dateTime
        }
    }
}
