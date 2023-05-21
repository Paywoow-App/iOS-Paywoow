//
//  OwnStreammerStore.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/27/22.
//

import SwiftUI
import Firebase

struct OwnStreammerModel: Identifiable {
    var id = UUID()
    var firstName : String
    var lastName : String
    var bigoId : String
    var pfImage : String
    var userId : String
    var phone : String
}

class OwnStreammerStore : ObservableObject {
    @Published var myStreammers: [OwnStreammerModel] = []
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("Users").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.myStreammers.removeAll()
                for doc in snap!.documents {
                    if let isStreammer = doc.get("isOwnStreammer") as? Bool {
                        if isStreammer == true {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let bigoId = doc.get("bigoId") as? String {
                                        if let pfImage = doc.get("pfImage") as? String {
                                            if let phone = doc.get("phoneNumber") as? String {
                                                let data = OwnStreammerModel(firstName: firstName, lastName: lastName, bigoId: bigoId, pfImage: pfImage, userId: doc.documentID, phone: phone)
                                                self.myStreammers.append(data)
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
