//
//  DevilRequestStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/16/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class DevilRequestStore: ObservableObject {
    @Published var devils : [DevilRequestModel] = []
    let ref = Firestore.firestore()
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DevilRequests").addSnapshotListener { snap, err in
                    if err != nil {
                        
                    }
                    else {
                        self.devils.removeAll(keepingCapacity: false)
                        for doc in snap!.documents {
                            if let userID = doc.get("userId") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let firstName = doc.get("firstName") as? String {
                                        if let lastName = doc.get("lastName") as? String {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let token = doc.get("token") as? String {
                                                    if let classs = doc.get("class") as? String {
                                                        if let when = doc.get("when") as? String {
                                                            if let point = doc.get("point") as? Int {
                                                                if let diamond = doc.get("diamond") as? Int {
                                                                    if let level = doc.get("level") as? Int {
                                                                        if let sender = doc.get("sender") as? String {
                                                                            let data = DevilRequestModel(userID: userID, pfImage: pfImage, firstName: firstName, lastName: lastName, nicknaame: nickname, level: level, token: token, classs: classs, when: when, point: point, diamond: diamond, sender: sender)
                                                                            self.devils.append(data)
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
    }
}



class AngelRequestStore: ObservableObject {
    @Published var angels : [DevilRequestModel] = [] //same
    let ref = Firestore.firestore()
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AngelRequests").addSnapshotListener { snap, err in
                    if err != nil {
                        
                    }
                    else {
                        self.angels.removeAll(keepingCapacity: false)
                        for doc in snap!.documents {
                            if let userID = doc.get("userId") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let firstName = doc.get("firstName") as? String {
                                        if let lastName = doc.get("lastName") as? String {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let token = doc.get("token") as? String {
                                                    if let classs = doc.get("class") as? String {
                                                        if let when = doc.get("when") as? String {
                                                            if let point = doc.get("point") as? Int {
                                                                if let diamond = doc.get("diamond") as? Int {
                                                                    if let level = doc.get("level") as? Int {
                                                                        if let sender = doc.get("sender") as? String {
                                                                            let data = DevilRequestModel(userID: userID, pfImage: pfImage, firstName: firstName, lastName: lastName, nicknaame: nickname, level: level, token: token, classs: classs, when: when, point: point, diamond: diamond, sender: sender)
                                                                            self.angels.append(data)
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
    }
}
