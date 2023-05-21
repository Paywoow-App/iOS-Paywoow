//
//  AuthResearchers.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/11/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore


//MARK: Son Yapilanalar

class Auth_Reseracher: ObservableObject {
    let ref = Firestore.firestore()
    @Published var password : String = ""
    @Published var userID : String = ""
    @Published var isReady : Bool = false
    @Published var userCanUseEmail = false
    @Published var userCanUserPlatformId : Bool = false
    @Published var pfImage : String = ""
    @Published var vipType : String = ""
    @Published var email : String = ""
    func searchEmail(searchEmail: String){
        self.isReady = false
        if searchEmail != "" {
            ref.collection("Users").addSnapshotListener { snap, err in
                if err == nil {
                    for doc in snap!.documents {
                        if let email = doc.get("email") as? String {
                            if email == searchEmail {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let vipType = doc.get("vipType") as? String {
                                        if let password = doc.get("password") as? String {
                                            if let email = doc.get("email") as? String {
                                                self.password = password
                                                self.userID = doc.documentID
                                                self.isReady = true
                                                self.userCanUseEmail = false
                                                self.pfImage = pfImage
                                                self.vipType = vipType
                                                self.email = email
                                                print("I Find the this email adress")
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                if email.contains(".com") {
                                    self.userCanUseEmail = true
                                }
                                else {
                                    self.userCanUseEmail = false
                                }// for register
                            }
                        }
                    }
                }
            }
        }
        else {
            self.userCanUseEmail = false
        }
    }
    
    func searchPhoneNumber(searchPhoneNumber: String){
        self.isReady = false
        self.pfImage = ""
        self.email = ""
        self.userID = ""
        self.password = ""
        if searchPhoneNumber != "" {
            ref.collection("Users").addSnapshotListener { snap, err in
                if err != nil {
                    
                }
                else {
                    for doc in snap!.documents {
                        if let phoneNumber = doc.get("phoneNumber") as? String {
                            if phoneNumber == searchPhoneNumber {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let vipType = doc.get("vipType") as? String {
                                        if let password = doc.get("password") as? String {
                                            if let email = doc.get("email") as? String {
                                                self.password = password
                                                self.userID = doc.documentID
                                                self.isReady = true
                                                self.pfImage = pfImage
                                                self.vipType = vipType
                                                self.email = email
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func searchAppleId(searchAppleId: String){
        self.isReady = false
        if searchAppleId != "" {
            ref.collection("Users").addSnapshotListener { snap, err in
                if err != nil {
                    
                }
                else {
                    for doc in snap!.documents {
                        if let appleId = doc.get("appleId") as? String {
                            if appleId == searchAppleId {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let vipType = doc.get("vipType") as? String {
                                        if let password = doc.get("password") as? String {
                                            if let email = doc.get("email") as? String {
                                                self.password = password
                                                self.userID = doc.documentID
                                                self.isReady = true
                                                self.pfImage = pfImage
                                                self.vipType = vipType
                                                self.email = email
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func searchBigoId(platformId: String){
        self.userCanUserPlatformId = false
        if platformId != "" {
            ref.collection("Users").addSnapshotListener { snap, err in
                if err != nil {
                    
                }
                else {
                    for doc in snap!.documents {
                        if let bigoId = doc.get("bigoId") as? String {
                            if bigoId == platformId {
                                self.userCanUserPlatformId = false
                            }
                            else {
                                self.userCanUserPlatformId = true
                            }
                        }
                    }
                }
            }
        }
    }
}
