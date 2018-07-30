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
            //            .queryOrdered(byChild: "date_time")
            .queryLimited(toFirst: 5)
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
