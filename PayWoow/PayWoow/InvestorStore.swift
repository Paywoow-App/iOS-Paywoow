//
//  InvestorStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/24/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct InvestHistoryModel: Identifiable {
    var id = UUID()
    var dealler : String
    var dollar : Double
    var platform : String
    var price : Int
    var timeStamp : Int
    var uploadID : String
    var userID : String
    var profitForInvest : Int
    var index : Int
}

class InvestorStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var totalPrice : Int = 0
    @Published var totalSold : Int = 0
    @Published var isActive : Bool = false
    @Published var selectedPlatforms : [String] = []
    @Published var createdDate : Int = 0
    @Published var currency : String = ""
    @Published var currentySymbol : String = ""
    @Published var blockLimit : Int = 0
    @Published var percent : Int = 0
    @Published var totalProfit : Int = 0
    
    @Published var saleList : [InvestHistoryModel] = []
    
    init(){
        if Auth.auth().currentUser != nil {
            
            ref.collection("Investories").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
                if err == nil {
                    if let totalPrice = doc?.get("totalPrice") as? Int {
                        if let totalSold = doc?.get("totalSold") as? Int {
                            if let isActive = doc?.get("isActive") as? Bool {
                                if let selectedPlatforms = doc?.get("selectedPlatforms") as? [String] {
                                    if let createdDate = doc?.get("createdDate") as? Int {
                                        if let currency = doc?.get("currency") as? String {
                                            if let currencySymbol = doc?.get("currencySymbol") as? String {
                                                if let blockLimit = doc?.get("blockLimit") as? Int {
                                                    if let percent = doc?.get("percent") as? Int {
                                                        self.totalPrice = totalPrice
                                                        self.totalSold = totalSold
                                                        self.isActive = isActive
                                                        self.selectedPlatforms = selectedPlatforms
                                                        self.createdDate = createdDate
                                                        self.currency = currency
                                                        self.currentySymbol = currencySymbol
                                                        self.blockLimit = blockLimit
                                                        self.percent = percent
                                                        self.getList()
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
    
    func getList(){
        ref.collection("Investories").document(Auth.auth().currentUser!.uid).collection("History").addSnapshotListener { snap, err in
            if err == nil {
                if err == nil {
                    self.saleList.removeAll()
                    self.totalProfit = 0
                    var index = 0
                    for doc in snap!.documents {
                        if let dealler = doc.get("dealler") as? String {
                            if let dollar = doc.get("dollar") as? Double {
                                if let platform = doc.get("platform") as? String {
                                    if let price = doc.get("price") as? Int {
                                        if let timeStamp = doc.get("timeStamp") as? Int {
                                            if let uploadID = doc.get("uploadID") as? String {
                                                if let userID = doc.get("userID") as? String {
                                                    let step1 = price / 100
                                                    let step2 = step1 * 6
                                                    let step3 = step2 / 100
                                                    let step4 = step3 * self.percent
                                                    print(step1)
                                                    print(step2)
                                                    print(step3)
                                                    print(step4)
                                                    index = index + 1
                                                    self.totalProfit = self.totalProfit + step4
                                                    let data = InvestHistoryModel(dealler: dealler, dollar: dollar, platform: platform, price: price, timeStamp: timeStamp, uploadID: uploadID, userID: userID, profitForInvest: step4, index: index)
                                                    self.saleList.append(data)
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
