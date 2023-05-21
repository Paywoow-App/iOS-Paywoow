//
//  SpecialChatUserResearcher.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/15/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import SDWebImageSwiftUI

class SpecialChatUserReseracher: ObservableObject{
    let ref = Firestore.firestore()
    @Published var pfImage = ""
    @Published var level = 0
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var platformId = ""
    @Published var notification = 0
    @Published var gender = ""
    @Published var nickname = ""
    @Published var isOnline = false
    @Published var levelPoint = 0
    @Published var current = ""
    @Published var isLive = false
    func getUserData(contactId: String){
        ref.collection("Users").document(contactId).addSnapshotListener { doc, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                if let pfImage = doc?.get("pfImage") as? String {
                    if let level = doc?.get("level") as? Int {
                        if let firstName = doc?.get("firstName") as? String {
                            if let lastName = doc?.get("lastName") as? String {
                                if let platformId = doc?.get("bigoId") as? String {
                                    if let notification = doc?.get("notification") as? Int {
                                        if let gender = doc?.get("gender") as? String {
                                            if let nickname = doc?.get("nickname") as? String {
                                                if let isOnline = doc?.get("isOnline") as? Bool {
                                                    if let levelPoint = doc?.get("levelPoint") as? Int {
                                                        if let current = doc?.get("current") as? String {
                                                            if let isLive = doc?.get("live") as? Bool {
                                                                self.pfImage = pfImage
                                                                self.level = level
                                                                self.firstName = firstName
                                                                self.lastName = lastName
                                                                self.platformId = platformId
                                                                self.notification = notification
                                                                self.gender = gender
                                                                self.nickname = nickname
                                                                self.isOnline = isOnline
                                                                self.levelPoint = levelPoint
                                                                self.current = current
                                                                self.isLive = isLive
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
                }
            }
        }
    }
}

