//
//  GroupSwapStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/9/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class GroupSwapUserStore: ObservableObject{
    let ref = Firestore.firestore()
    
    @Published var users : [GroupSwapUserModel] = []
    
    init(){
        ref.collection("Groups").document("BigoLive").collection("BenimAjansım").document("Swaps").collection("WaitingSwaps").document(Auth.auth().currentUser!.uid).collection("RequestUsers").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.users.removeAll()
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if let diamond = doc.get("diamond") as? Int {
                            if let fullname = doc.get("fullname") as? String {
                                if let level = doc.get("level") as? Int {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let timeDate = doc.get("timeDate") as? String {
                                            if let userId = doc.get("userId") as? String {
                                                let data = GroupSwapUserModel(bigoId: bigoId, diamond: diamond, fullname: fullname, level: level, pfImage: pfImage, timeDate: timeDate, userId: userId)
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
}


class GroupSwapStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var swaps: [GroupMatchedSwapModel] = []
    
    init(){
        ref.collection("Groups").document("BigoLive").collection("ValentinoAgency").document("Swaps").collection("MatchedSwaps").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.swaps.removeAll()
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if let diamond = doc.get("diamond") as? Int {
                            if let fullname = doc.get("fullname") as? String {
                                if let level = doc.get("level") as? Int {
                                    if let timeDate = doc.get("timeDate") as? String {
                                        if let userId = doc.get("userId") as?  String {
                                            if let pfImage = doc.get("pfImage") as? String {
                                                if let secondUserId = doc.get("secondUserId") as? String {
                                                    if let secondPfImage = doc.get("secondPfImage") as? String {
                                                        let data = GroupMatchedSwapModel(bigoId: bigoId, diamond: diamond, fullname: fullname, level: level, timeDate: timeDate, userId: userId, pfImage: pfImage, secondUserId: secondUserId, secondPfImage: secondPfImage)
                                                        self.swaps.append(data)
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
