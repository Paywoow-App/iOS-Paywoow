//
//  PhoneProvider.swift
//  Customer
//
//  Created by İsa Yılmaz on 4/30/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class PhoneProvider: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoadingVerify: Bool = false

    @Published var phoneNumber: String = ""
    @Published var isVerify: Bool = false
    @Published var isVerified: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
    let ref = Firestore.firestore()
}

extension PhoneProvider {
    
    func sendCode() {
        
        self.isLoading.toggle()
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            
            self.isLoading.toggle()
            
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            
            UserDefaults.standard.set(verificationId, forKey: "verificationId")
            self.isVerify.toggle()
        }
    }
    
    func verifyCode(code: String) {
        
        self.isLoadingVerify.toggle()
        
        let verificationId = UserDefaults.standard.string(forKey: "verificationId") ?? ""
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code) 
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            self.isLoadingVerify.toggle()
            
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            
            self.isVerify.toggle()
            self.isVerified.toggle()
        }

    }
}


/*
 self.isLoadingVerify.toggle()
 
 if error != nil {
     self.isError.toggle()
     self.errorMsg = error?.localizedDescription ?? ""
     self.isVerifiedPhone = false
     return
 }
 
 print(authResult ?? "")
 self.isVerify.toggle()
 self.isVerified.toggle()
 self.isVerifiedPhone = true
 self.isVerifiedPhoneNumber = self.phoneNumber
 print(self.isVerifiedPhoneNumber)
 */
