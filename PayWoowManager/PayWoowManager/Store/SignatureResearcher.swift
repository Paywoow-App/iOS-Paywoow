//
//  SignatureResearcher.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/20/21.
//

import SwiftUI
import Firebase

class SignatureResearcher : ObservableObject {
    @Published var acceptedSignature : String = ""
    @Published var idCard : String = ""
    let ref = Firestore.firestore()
    
    func getAcceptedSignature(userId : String){
        ref.collection("AccountConfirmation").document(userId).addSnapshotListener { snap, err in
            if err != nil {
                print("can not fetch the signature")
            }
            else {
                if let signature = snap?.get("siganture") as? String {
                    self.acceptedSignature = signature
                }
                if let idCard = snap?.get("idCard") as? String {
                    self.idCard = idCard
                }
            }
        }
    }
}
