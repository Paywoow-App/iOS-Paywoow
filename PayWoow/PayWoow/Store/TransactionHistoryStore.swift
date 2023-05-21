//
//  TransactionHistoryStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/26/22.
//

import SwiftUI
import Firebase

class TransactionHistoryStore: ObservableObject{
    
    @Published var users: [TransactionUserModel] = []
    let ref = Firestore.firestore()
    @Published var totalDiamond : Int = 0
    @Published var totalUsers: Int = 0
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document("VIPGold").collection("History").addSnapshotListener { snap, err in
            if err != nil {
                
            }
            else {
                self.users.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let userID = doc.get("userId") as? String {
                        if let pfImage = doc.get("pfImage") as? String {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let token = doc.get("token") as? String {
                                        if let diamond = doc.get("diamond") as? Int {
                                            if let timeDate = doc.get("timeDate") as? String{
                                                if let platformId = doc.get("platformId") as? String {
                                                    if let platformName = doc.get("platformName") as? String {
                                                        if let ownerUserId = doc.get("ownerUserId") as? String {
                                                            if let ownerCardNo = doc.get("ownerCardNo") as? String {
                                                                if let latitude = doc.get("latitude") as? Double {
                                                                    if let longitude = doc.get("langitude") as? Double {
                                                                        if let device = doc.get("device") as? String {
                                                                            if let cardType = doc.get("cardType") as? String {
                                                                                if let dealler = doc.get("dealler") as? String {
                                                                                    if let result = doc.get("result") as? String {
                                                                                        if let userName = doc.get("userName") as? String {
                                                                                            if let lastDiamond = doc.get("lastDiamond") as? Int {
                                                                                                let data = TransactionUserModel(userID: userID, pfImage: pfImage, firstName: firstName, lastName: lastName, token: token, diamond: diamond, timeDate: timeDate, platformId: platformId, platformName: platformName, ownerCardNo: ownerCardNo, ownerUserId: ownerUserId, latitude: latitude, longitude: longitude, device: device, cardType: cardType, dealler: dealler, docID: doc.documentID, result: result, userName: userName, lastDiamond: lastDiamond)
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
                    }
                }
            }
        }
    }
}
