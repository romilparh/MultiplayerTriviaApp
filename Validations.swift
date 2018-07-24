//
//  Validations.swift
//  TimePlay
//
//  Created by Romil on 2018-07-24.
//  Copyright © 2018 Romil. All rights reserved.
//

import Foundation

func isValidPassword(password: String) -> Bool {
    if(password.count>7){
        return true
    }
    else {
        return false
    }
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidName(name: String) -> Bool {
    if(name.count>0){
        return true
    } else{
        return false
    }
}


