//
//  OrderWriterBayiiStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/22.
//

import SwiftUI
import FirebaseFirestore

class OrderWriterBayiiStore : ObservableObject {
    
    @Published var bayiiImage : String = ""
    @Published var bayiiName : String = ""
    @Published var balance : Int = 0
    @Published var bigoId : String = ""
    @Published var change : Double = 0
    @Published var giftTotal : Int = 0
    @Published var inputBalance : Int = 0
    @Published var isOnline : Bool = false
    @Published var level : Int = 0
    @Published var star : Int = 0
    @Published var takenDiamond : Int = 0
    @Published var totalBalance : Int = 0
    @Published var willSellDiamond : Int = 0
    @Published var diamondLimit : Int = 0
    @Published var token: String = ""
    
    let ref = Firestore.firestore()
    func getData(bayiId: String, selectedDealler: String){
        if bayiId != "" {
            
            ref.collection("Bayii").document(bayiId).collection("Apps").addSnapshotListener { snaps, err in
                if err == nil {
                    for snap in snaps!.documents {
                        if let platformName = snap.get("platformName") as? String {
                            if platformName == selectedDealler {
                                print("debugg \(platformName)")
                                self.ref.collection("Bayii").document(bayiId).collection("Apps").document(snap.documentID).addSnapshotListener { doc, err in
                                    if err == nil {
                                        if let balance = doc?.get("balance") as? Int {
                                            print("debugg \(balance)")
                                            if let boughtPrice = doc?.get("boughtPrice") as? Int {
                                                if let coverImage = doc?.get("coverImage") as? String {
                                                    if let deallerName = doc?.get("deallerName") as? String {
                                                        print("debug \(deallerName)")
                                                        if let dollar = doc?.get("dollar") as? Double {
                                                            if let giftDiamond = doc?.get("giftDiamond") as? Int {
                                                                if let isActive = doc?.get("isActive") as? Bool {
                                                                    if let maxLimit = doc?.get("maxLimit") as? Int {
                                                                        if let platformImage = doc?.get("platformImage") as? String {
                                                                            if let platformName = doc?.get("platformName") as? String {
                                                                                if let productType = doc?.get("productType") as? String {
                                                                                    if let productTotal = doc?.get("productTotal") as? Int {
                                                                                        if let sellPrice = doc?.get("sellPrice") as? Int {
                                                                                            self.balance = balance
                                                                                            self.takenDiamond = boughtPrice
                                                                                            self.bayiiImage = coverImage
                                                                                            self.bayiiName = deallerName
                                                                                            self.change = dollar
                                                                                            self.giftTotal = giftDiamond
                                                                                            self.isOnline = isActive
                                                                                            self.diamondLimit = maxLimit
                                                                                            self.inputBalance = productTotal
                                                                                            self.willSellDiamond = sellPrice
                                                                                            print("debug fetch \(dollar)")
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
                        }
                    }
                }
            }
        }
    }
}
