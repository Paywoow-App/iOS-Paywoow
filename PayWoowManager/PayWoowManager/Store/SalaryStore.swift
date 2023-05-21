//
//  SalaryStore.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/27/22.
//

import SwiftUI
import FirebaseFirestore

struct StreamerBanksModel : Identifiable {
    var id = UUID()
    var fullname : String
    var bankName : String
    var iban : String
    var userID : String
}

class StreamerBanksStore: ObservableObject{
    @Published var list : [StreamerBanksModel] = []
    
    init(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { users, err in
            if err == nil {
                self.list.removeAll()
                for user in users!.documents {
                    if let isComplatedTax = user.get("isComplatedTax") as? Bool {
                        if isComplatedTax {
                            ref.collection("Users").document(user.documentID).collection("SalaryBankDetails").document(user.documentID).addSnapshotListener { snap, err in
                                if err == nil {
                                    self.list.removeAll()
                                    if let fullname = snap!.get("fullName") as? String {
                                        if let bankName = snap!.get("bankName") as? String {
                                            if let iban = snap!.get("iban") as? String {
                                                let data = StreamerBanksModel(fullname: fullname, bankName: bankName, iban: iban, userID: user.documentID)
                                                self.list.append(data)
                                                print(data)
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
