//
//  OrderStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/19/21.
//

import SwiftUI
import FirebaseFirestore

struct OrderModel: Identifiable {
    var id = UUID()
    var userID : String
    var platformID : String
    var platform : String
    var price : Int
    var timeStamp : String
    var transferType : String
    var signatureURL : String
    var hexCodeTop : String
    var hexCodeBottom : String
    var refCode : String
    var result : Int
    var product : Int
    var streamerGivenGift : Int
    var month : String
    var year : String
    var deallerID : String
    var docId : String
}


//Admin's Orders
class OrderStore: ObservableObject {
    @Published var list : [OrderModel] = []
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("Orders").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let deallerID = doc.get("deallerID") as? String {
                        if let userID = doc.get("userID") as? String {
                            if let platformID = doc.get("platformID") as? String {
                                if let platform = doc.get("platform") as? String {
                                    if let price = doc.get("price") as? Int {
                                        if let timeStamp = doc.get("timeStamp") as? String {
                                            if let transferType = doc.get("transferType") as? String {
                                                if let signatureURL = doc.get("signatureURL") as? String {
                                                    if let hexCodeTop = doc.get("hexCodeTop") as? String {
                                                        if let hexCodeBottom = doc.get("hexCodeBottom") as? String {
                                                            if let refCode = doc.get("refCode") as? String {
                                                                if let product = doc.get("product") as? Int {
                                                                    if let stremaerGivenGift = doc.get("streamerGivenGift") as? Int {
                                                                        if let month = doc.get("month") as? String {
                                                                            if let year = doc.get("year") as? String {
                                                                                if let result = doc.get("result") as? Int {
                                                                                    let data = OrderModel(userID: userID, platformID: platformID, platform: platform, price: price, timeStamp: timeStamp, transferType: transferType, signatureURL: signatureURL, hexCodeTop: hexCodeTop, hexCodeBottom: hexCodeBottom, refCode: refCode, result: result, product: product, streamerGivenGift: stremaerGivenGift, month: month, year: year, deallerID: deallerID, docId: doc.documentID)
                                                                                    self.list.append(data)
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
