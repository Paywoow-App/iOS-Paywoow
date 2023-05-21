//
//  PKStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/3/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class PKStoreOLD: ObservableObject {
    let ref = Firestore.firestore()
    @Published var users: [PKModelOLD] = []
    
    
    init(){
        ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("GroupInfo").collection("Users").document(Auth.auth().currentUser!.uid).collection("PK").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.users.removeAll()
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if let level = doc.get("level") as? Int {
                            if let pfImage = doc.get("pfImage") as? String {
                                if let timeDate = doc.get("timeDate") as? String {
                                    if let userId = doc.get("userId") as? String {
                                        if let fullname = doc.get("fullname") as? String {
                                            let data = PKModelOLD(bigoId: bigoId, fullname: fullname, level: level, pfImage: pfImage, timeDate: timeDate, userId: userId)
                                            self.users.append(data)
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
