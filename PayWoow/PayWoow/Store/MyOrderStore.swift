//
//  MyOrderStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MyOrdersStore : ObservableObject {
    @Published var orders : [MyOrderModel] = []
    @Published var vipOrders : [MyOrderModel] = []
    @Published var lastOrders : [MyOrderModel] = []
    @Published var lastOrderResult : Int = 0
    @Published var lastDealler : String = ""
    @Published var reloaded = false
    let ref = Firestore.firestore()
    
    init() {
        if Auth.auth().currentUser != nil {
            
                ref.collection("Orders").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
                    if err == nil {
                        self.orders.removeAll()
                        for doc in snap!.documents {
                            if let userID = doc.get("userID") as? String {
                                if userID == Auth.auth().currentUser!.uid {
                                    if let platformID = doc.get("platformID") as? String {
                                        if let platform = doc.get("platform") as? String {
                                            if let price = doc.get("price") as? Int {
                                                if let timeStamp = doc.get("timeStamp") as? Int {
                                                    if let transferType = doc.get("transferType") as? String {
                                                        if let signatureURL = doc.get("signatureURL") as? String {
                                                            if let hexCodeTop = doc.get("hexCodeTop") as? String {
                                                                if let hexCodeBottom = doc.get("hexCodeBottom") as? String {
                                                                    if let refCode = doc.get("refCode") as? String {
                                                                        if let product = doc.get("product") as? Int {
                                                                            if let streamerGivenGift = doc.get("streamerGivenGift") as? Int {
                                                                                if let month = doc.get("month") as? String {
                                                                                    if let year = doc.get("year") as? String {
                                                                                        if let deallerID = doc.get("deallerID") as? String {
                                                                                            if let result = doc.get("result") as? Int {
                                                                                                if transferType == "VIP Card" {
                                                                                                    let data = MyOrderModel(userId: userID, platformID: platformID, platform: platform, price: price, timeStamp: timeStamp, transferType: transferType, signatureURL: signatureURL, hexCodeTop: hexCodeTop, hexCodeBottom: hexCodeBottom, refCode: refCode, product: product, streamerGivenGift: streamerGivenGift, month: month, year: year, deallerID: deallerID, result: result)
                                                                                                    self.vipOrders.append(data)
//                                                                                                    self.lastOrders.removeAll()
//                                                                                                    self.lastOrders.append(data)
//                                                                                                    self.lastOrderResult = result
                                                                                                }
                                                                                                else {
                                                                                                    let data = MyOrderModel(userId: userID, platformID: platformID, platform: platform, price: price, timeStamp: timeStamp, transferType: transferType, signatureURL: signatureURL, hexCodeTop: hexCodeTop, hexCodeBottom: hexCodeBottom, refCode: refCode, product: product, streamerGivenGift: streamerGivenGift, month: month, year: year, deallerID: deallerID, result: result)
                                                                                                    self.orders.append(data)
                                                                                                    self.lastOrders.removeAll()
                                                                                                    self.lastOrders.append(data)
                                                                                                    self.lastOrderResult = result
                                                                                                    self.lastDealler = deallerID
                                                                                                    print(self.lastOrderResult)
                                                                                                    print(self.lastDealler)
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

