//
//  LoginViewModel.swift
//  MVVM-Example
//
//  Created by Nitesh on 21/03/22.
//

import Foundation

struct LoginViewModel {
    
    private(set) var errorMessage: Box<String?> = Box(nil)
    private(set) var canSubmit: Box<Bool> = Box(false)

//    var canSubmit: Bool {
//        return userNameIsValidFormat && passwordIsValidFormat
//    }
    var email: String = ""{
        didSet{
            emailIsValid = email.isValidEmail
            canSubmit.value = emailIsValid && passwordIsValid
        }
    }
    var password: String = ""{
        didSet{
            passwordIsValid = self.validatePasswordFormat(password)
            canSubmit.value = emailIsValid && passwordIsValid
        }
    }
    private var passwordIsValid: Bool = false
    private var emailIsValid: Bool = false
    
    private func validatePasswordFormat(_ password: String) -> Bool{
         let trimmedString = password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
         return trimmedString.count >= 8 &&  trimmedString.count <= 15
     }
    
    func validateLogin() -> Bool{
        if email.isEmpty{
            self.errorMessage.value = "Please enter your email address"
            return false
        }else if !email.isValidEmail{
            self.errorMessage.value = "Please enter a valid email address"
            return false
        }else if password.isEmpty{
            self.errorMessage.value = "Please enter your password"
            return false
        }else if !validatePasswordFormat(password){
            self.errorMessage.value = "Please enter valid password"
            return false
        }
        return true
    }

}
