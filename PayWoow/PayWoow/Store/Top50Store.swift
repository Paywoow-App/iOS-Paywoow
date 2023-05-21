//
//  Top50Store.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/17/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class Top50Store: ObservableObject{
    @AppStorage("accountLevelStore") var accountLevelStore : Int = 0
    
    @Published var users : [Top50Model] = []
    @Published var index = 0
    let ref = Firestore.firestore()
    init(){
        ref.collection("Users").order(by: "totalSoldDiamond", descending: true).addSnapshotListener { snap, err in
            if err != nil {
                
            }
            else {
                    self.index = 0
                    self.users.removeAll(keepingCapacity: false)
                    for doc in snap!.documents {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let totalSoldDiamond = doc.get("totalSoldDiamond") as? Int {
                                    if let platformId = doc.get("platformID") as? String {
                                        if let pfImage = doc.get("pfImage") as? String {
                                            if let gift = doc.get("gift") as? Int {
                                                if let accountLevel = doc.get("accountLevel") as? Int {
                                                    if let level = doc.get("level") as? Int {
                                                        if let verify = doc.get("verify") as? Bool {
                                                            if let nickname = doc.get("nickname") as? String {
                                                                if let vipType = doc.get("vipType") as? String {
                                                                    if let casper = doc.get("casper") as? Bool {
//                                                                        if accountLevel == self.accountLevelStore {
//
//
//                                                                        }
                                                                        
                                                                        if !nickname.contains("konuk") {
                                                                            let currentIndex = self.index + 1
                                                                            self.index = currentIndex
                                                                            let data = Top50Model(fullname: "\(firstName) \(lastName)", totalSoldDiamond: totalSoldDiamond, platformId: platformId, pfImage: pfImage, userId: doc.documentID, gift: gift, index: self.index, accountLevel: accountLevel, level: level, verify: verify, nickname: nickname, vipType: vipType, casper: casper)
                                                                            
                                                                                self.users.append(data)
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
