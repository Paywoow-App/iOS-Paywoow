//
//  VIPOrderStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/30/22.
//

import SwiftUI
import Firebase
import Foundation

struct VIPOrderModel: Identifiable{
    var id = UUID()
    var cardNo : String
    var cardType : String
    var diamond: Int
    var fullname : String
    var level : Int
    var pfImage : String
    var timeDate : String
    var token : String
    var uploadID : String
    var userID : String
    var userName : String
    var result : String
    var dealler: String
    var docId : String
}

class VIPOrderStore: ObservableObject {
    @Published var orders : [VIPOrderModel] = []
    let ref = Firestore.firestore()
    init(){
        
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCardOrders").addSnapshotListener { snap, err in
                if err != nil {
                    
                }
                else {
                    self.orders.removeAll(keepingCapacity: false)
                    for doc in snap!.documents {
                        if let cardNo = doc.get("cardNo") as? String {
                            if let cardType = doc.get("cardType") as? String{
                                if let diamond = doc.get("diamond") as? Int {
                                    if let fullname = doc.get("fullname") as? String{
                                        if let level = doc.get("level") as? Int {
                                            if let pfImage = doc.get("pfImage") as? String {
                                                if let timeDate = doc.get("timeDate") as? String {
                                                    if let token = doc.get("token") as? String {
                                                        if let uplaodID = doc.get("uploadID") as? String {
                                                            if let userID = doc.get("userID") as? String {
                                                                if let userName = doc.get("userName") as? String {
                                                                    if let result = doc.get("result") as? String {
                                                                        if let dealler = doc.get("dealler") as? String {
                                                                            let data = VIPOrderModel(cardNo: cardNo, cardType: cardType, diamond: diamond, fullname: fullname, level: level, pfImage: pfImage, timeDate: timeDate, token: token, uploadID: uplaodID, userID: userID, userName: userName, result: result, dealler: dealler, docId: doc.documentID)
                                                                            self.orders.append(data)
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
