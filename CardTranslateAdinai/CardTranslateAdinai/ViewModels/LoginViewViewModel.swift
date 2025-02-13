//
//  LoginViewViewModel.swift
//  snackstore1
//
//  Created by marzhan on 21/11/24.
//

import Foundation
import FirebaseAuth
class LoginViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    init(){}
    func login() {
        guard validate() else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
        
    }
    
   private func validate() -> Bool {
       errorMessage = ""
       guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
             !password.trimmingCharacters(in: .whitespaces).isEmpty else{
           errorMessage = "Please fill in all fields"
           return false
       }
      
       guard email.contains("@") && email.contains(".") else {
           errorMessage = "Please Enter valid email"
           return false
       }
       return true
   }
    
}

