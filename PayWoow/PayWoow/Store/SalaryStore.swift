//
//  SalaryStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/25/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class SalaryStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [SalaryModel] = []
    @Published var totalWaitingSalary = 0
    
    init(){
        ref.collection("StreammerSalaries").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let userID = doc.get("userID") as? String {
                        if userID == Auth.auth().currentUser!.uid {
                            if let bankName = doc.get("bankName") as? String {
                                if let IBAN = doc.get("IBAN") as? String {
                                    if let timeStamp = doc.get("timeStamp") as? Int {
                                        if let month = doc.get("month") as? String {
                                            if let year = doc.get("year") as? String {
                                                if let day = doc.get("day") as? String {
                                                    if let progress = doc.get("progress") as? Int {
                                                        if let price = doc.get("price") as? Int {
                                                            if let currency = doc.get("currency") as? String {
                                                                let data = SalaryModel(userID: userID, bankName: bankName, IBAN: IBAN, timeStamp: timeStamp, month: month, year: year, day: day, progress: progress, price: price, currency: currency)
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
