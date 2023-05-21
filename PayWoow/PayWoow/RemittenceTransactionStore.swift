//
//  RemittenceTransactionStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/5/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RemittenceTransactionModel: Identifiable {
    var id = UUID()
    var bank : String
    var iban : String
    var result : Int
    var timeStamp : Int
    var price : Int
    var merchantDOCID : String
    var isUploadedPrice : Bool
    var isDeclinedPrice : Bool
}

class RemittenceTransactionStore: ObservableObject {
    @Published var list : [RemittenceTransactionModel] = []
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("RemittenceHistory").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let bank = doc.get("bank") as? String {
                        if let iban = doc.get("iban") as? String {
                            if let result = doc.get("result") as? Int {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let price = doc.get("price") as? Int {
                                        if let isUploadedPrice = doc.get("isUploadedPrice") as? Bool {
                                            if let isDeclinedPrice = doc.get("isDeclinedPrice") as? Bool {
                                                let data = RemittenceTransactionModel(bank: bank, iban: iban, result: result, timeStamp: timeStamp, price: price, merchantDOCID: doc.documentID, isUploadedPrice: isUploadedPrice, isDeclinedPrice: isDeclinedPrice)
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
