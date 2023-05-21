//
//  VIPCardSStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/25/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class VIPCardStore: ObservableObject{
    let ref = Firestore.firestore()
    @AppStorage("vipType") var vipType : String = "Nil"
    @Published var cardNo : String = ""
    @Published var cardType : String = ""
    @Published var totalPrice : Int = 0
    @Published var expiryDate : String = ""
    @Published var cardPassword: String = ""
    @Published var twoFactor : Bool = false
    @Published var isActivated : Bool = false
    
    init() {
        if Auth.auth().currentUser != nil {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document(vipType).addSnapshotListener { doc, err in
                if err == nil {
                    if let cardNo = doc?.get("cardNo") as? String {
                        if let cardType = doc?.get("cardType") as? String {
                            if let totalPrice = doc?.get("totalPrice") as? Int {
                                if let expiryDate = doc?.get("expiryDate") as? String {
                                    if let cardPassword = doc?.get("cardPassword") as? String {
                                        if let twoFactor = doc?.get("twoFactor") as? Bool {
                                            if let isActivated = doc?.get("isActivated") as? Bool {
                                                self.cardNo = cardNo
                                                self.cardType = cardType
                                                self.totalPrice = totalPrice
                                                self.expiryDate = expiryDate
                                                self.cardPassword = cardPassword
                                                self.twoFactor = twoFactor
                                                self.isActivated = isActivated
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
