//
//  StreamerSalaryInfoStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/4/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class StreamerSalaryInfoStore : ObservableObject {
    @Published var bankName : String = ""
    @Published var iban : String = ""
    @Published var fullName : String = ""
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SalaryBankDetails").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
            if err == nil {
                if let bankName = doc?.get("bankName") as? String {
                    if let iban = doc?.get("iban") as? String {
                        if let fullName = doc?.get("fullName") as? String {
                            self.bankName = bankName
                            self.iban = iban
                            self.fullName = fullName
                        }
                    }
                }
            }
            else {
                print(err!.localizedDescription)
            }
        }
    }
}
