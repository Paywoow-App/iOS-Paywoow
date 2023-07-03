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
    var platformID: String
    var pfImage: String
}

class StreamerBanksStore: ObservableObject{
    @Published var list : [StreamerBanksModel] = []
    
    init(){
        let ref = Firestore.firestore()
        
        ref.collection("Users").addSnapshotListener { users, err in
            if err == nil {
                self.list.removeAll()
                guard let docs = users?.documents else { return }
                for doc in docs {
                    if let isCompletedTax = doc.get("isComplatedTax") as? Bool {
                        if isCompletedTax {
                            let userID = doc.documentID
                            let firstName = doc.get("firstName") as? String ?? ""
                            let lastName = doc.get("lastName") as? String ?? ""
                            let platfomID = doc.get("platformID") as? String ?? ""
                            let pfImage = doc.get("pfImage") as? String ?? ""
                            
                            ref.collection("Users").document(userID).collection("BankInformations").document(platfomID).addSnapshotListener { snap, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                
                                let bankName = snap?.get("bankName") as? String ?? ""
                                let iban = snap?.get("iban") as? String ?? ""
                                
                                let data = StreamerBanksModel(fullname: "\(firstName) \(lastName)",
                                                              bankName: bankName,
                                                              iban: iban,
                                                              userID: userID,
                                                              platformID: platfomID,
                                                              pfImage: pfImage)
                                print("IDLOSKİ \(userID)")
                                guard iban.isEmpty != true else { print("ERROR HEREYO"); return }
                                self.list.append(data)
                            }
                        }
                    }
                }
            }
        }
    }
}


//for user in users!.documents {
//    if let isComplatedTax = user.get("isComplatedTax") as? Bool {
//        if isComplatedTax {
//            ref.collection("Users").document(user.documentID).collection("SalaryBankDetails").document(user.documentID).addSnapshotListener { snap, err in
//                if err == nil {
//                    self.list.removeAll()
//                    if let fullname = snap!.get("fullName") as? String {
//                        if let bankName = snap!.get("bankName") as? String {
//                            if let iban = snap!.get("iban") as? String {
//                                let data = StreamerBanksModel(fullname: fullname, bankName: bankName, iban: iban, userID: user.documentID)
//                                self.list.append(data)
//                                print("OKOKOKO \(data)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
