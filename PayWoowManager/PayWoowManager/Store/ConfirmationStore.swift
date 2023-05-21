//
//  ConfirmationStore.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/22/21.
//

import SwiftUI
import Firebase

struct ConfirmationModel : Identifiable{
    var id = UUID()
    var signature : String
    var pfImage : String
    var idCard : String
    var fullname : String
    var userId : String
    var email : String
}

class ConfirmationStore : ObservableObject{
    let ref = Firestore.firestore()
    @Published var confirms : [ConfirmationModel] = []
    
    init(){
        ref.collection("AccountConfirmation").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                self.confirms.removeAll()
                for doc in snap!.documents {
                    if let fullname = doc.get("fullname") as? String {
                        if let pfImage = doc.get("pfImage") as? String {
                            if let idCard = doc.get("idCard") as? String {
                                if let siganture = doc.get("siganture") as? String {
                                    if let email = doc.get("email") as? String {
                                        let data = ConfirmationModel(signature: siganture, pfImage: pfImage, idCard: idCard, fullname: fullname, userId: doc.documentID, email: email)
                                        
                                        self.confirms.append(data)
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
