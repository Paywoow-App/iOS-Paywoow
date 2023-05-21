//
//  BankIbanStore.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 11/4/22.
//

import SwiftUI
import FirebaseFirestore

struct BankIbanModel : Identifiable {
    var id = UUID()
    var bankName : String
    var copiedCount : Int
    var coverImage : String
    var iban : String
    var docID : String
}

class BankIbanStore: ObservableObject {
    @Published var list : [BankIbanModel] = []
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("BankIBANs").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let bankName = doc.get("bankName") as? String {
                        if let copiedCount = doc.get("copiedCount") as? Int {
                            if let coverImage = doc.get("coverImage") as? String {
                                if let iban = doc.get("iban") as? String {
                                    let data = BankIbanModel(bankName: bankName, copiedCount: copiedCount, coverImage: coverImage, iban: iban, docID: doc.documentID)
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
