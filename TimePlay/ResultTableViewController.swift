//
//  ResultTableViewController.swift
//  TimePlay
//
//  Created by Romil on 2018-08-02.
//  Copyright © 2018 Romil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResultTableViewController: UITableViewController {

    var fbRef:DatabaseReference!
    var gameId: String?
    
    var resultDictionary = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbRef = Database.database().reference()
        print("gameid r = " + self.gameId!)
        resultObserver()
    }

    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginView")
        self.present(newViewController, animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.resultDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = self.resultDictionary[indexPath.row]
        return cell
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
                for i in 0..<resultModelArray.count {
                    self.resultDictionary.append(resultModelArray[i].userName
                        + " (" + String(resultModelArray[i].correctCount)+")")
                }
                self.tableView.reloadData()
            })
    }
    
}
