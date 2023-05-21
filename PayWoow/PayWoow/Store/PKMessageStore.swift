//
//  MessageStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/8/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

//------------------------------- PK Users -----------------------------------//

struct PKUserModel: Identifiable {
    var id = UUID()
    var fullname: String
    var isRead: String
    var lastMessage: String
    var pfImage: String
    var platformId: String
    var userId: String
}

class PKUserStore: ObservableObject {
    @Published var users : [PKUserModel] = []
    let ref = Firestore.firestore()
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("PKMessages").addSnapshotListener { snap, err in
            if err != nil {
                
            } else {
                self.users.removeAll()
                for doc in snap!.documents {
                    if let fullname = doc.get("fullname") as? String {
                        if let isRead = doc.get("isRead") as? String {
                            if let lastMessage = doc.get("lastMessage") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let platformId = doc.get("platformId") as? String {
                                        if let userId = doc.get("userId") as? String {
                                            let data = PKUserModel(fullname: fullname, isRead: isRead, lastMessage: lastMessage, pfImage: pfImage, platformId: platformId, userId: userId)
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

//----------------------------- PK Messages ---------------------------------//


struct PK_MessagesModel: Identifiable {
    var id = UUID()
    var fullname: String
    var isRead: String
    var message: String
    var month: String
    var pfImage: String
    var platformId: String
    var time: String
    var timeDate: String
    var userId: String
}

class PKMesagesStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var messages: [PK_MessagesModel] = []
    
    func getMessages(senderUserId: String){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("PKMessages").document(senderUserId).collection("Messages").addSnapshotListener { snap, err in
            if err != nil {
                
            }
            else {
                self.messages.removeAll()
                for doc in snap!.documents {
                    if let fullname = doc.get("fullname") as? String {
                        if let isRead = doc.get("isRead") as? String {
                            if let message = doc.get("message") as? String {
                                if let month = doc.get("month") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let platformId = doc.get("platformId") as? String {
                                            if let time = doc.get("time") as? String {
                                                if let timeDate = doc.get("timeDate") as? String {
                                                    if let userId = doc.get("userId") as? String {
                                                        let data = PK_MessagesModel(fullname: fullname, isRead: isRead, message: message, month: month, pfImage: pfImage, platformId: platformId, time: time, timeDate: timeDate, userId: userId)
                                                        self.messages.append(data)
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



//------------------------------- Direct Message -----------------------------------//

struct DirectMessageUserModel: Identifiable {
    var id = UUID()
    var fullname: String
    var isRead: String
    var lastMessage: String
    var pfImage: String
    var platformId: String
    var userId: String
    var token: String
}

class DirectMessageUserStore: ObservableObject {
    @Published var users : [DirectMessageUserModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DirectMessage").addSnapshotListener { snap, err in
            if err != nil {
                
            } else {
                self.users.removeAll()
                for doc in snap!.documents {
                    if let userId = doc.get("userId") as? String {
                        if let fullname = doc.get("fullname") as? String {
                            if let isRead = doc.get("isRead") as? String {
                                if let lastMessage = doc.get("lastMessage") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let platformId = doc.get("platformId") as? String {
                                            if let token = doc.get("token") as? String {
                                                let data = DirectMessageUserModel(fullname: fullname, isRead: isRead, lastMessage: lastMessage, pfImage: pfImage, platformId: platformId, userId: userId, token: token)
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
