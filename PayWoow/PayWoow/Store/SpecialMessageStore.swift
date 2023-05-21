//
//  Messages.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/7/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class SpecialMessageStore: ObservableObject{
    @Published var users : [SpecialMessageUserModel] = []
    @Published var messages : [SpecialMessageModel] = []
    let ref = Firestore.firestore()
    
    @Published var count : Int = 0
    @Published var lastMessage: String = ""
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.users.removeAll()
                for doc in snap!.documents {
                    if let userID = doc.get("userId") as? String {
                        print("firstName \(userID)")
                        self.ref.collection("Users").document(userID).addSnapshotListener { docc, err in
                            if let pfImage = docc?.get("pfImage") as? String {
                                if let token = docc?.get("token") as? String {
                                    if let  firstName = docc?.get("firstName") as? String {
                                        if let lastName = docc?.get("lastName") as? String {
                                            if let nickName = docc?.get("nickname") as? String {
                                                if let platformId = docc?.get("bigoId") as? String {
                                                    if let level = docc?.get("level") as? Int {
                                                        let updateData = [
                                                            "firstName" : firstName,
                                                            "lastName" : lastName,
                                                            "pfImage" : pfImage,
                                                            "token" : token,
                                                            "nickname" : nickName,
                                                            "platformId" : platformId,
                                                            "level" : level,
                                                        ] as [String : Any]
                                                        self.ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(userID).setData(updateData, merge: true)
                                                        
                                                      
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let firstName = doc.get("firstName") as? String {
                            print("firstName \(firstName)")
                            if let lastName = doc.get("lastName") as? String {
                                if let nickname = doc.get("nickname") as? String {
                                    print("data here   \(nickname)")
                                    if let platformId = doc.get("platformId") as? String {
                                        if let pfImage = doc.get("pfImage") as? String {
                                            if let time = doc.get("time") as? String {
                                                if let date = doc.get("date") as? String {
                                                    if let lastMessage = doc.get("lastMessage") as? String {
                                                        if let isRead = doc.get("isRead") as? Bool {
                                                            if let level = doc.get("level") as? Int {
                                                                let data = SpecialMessageUserModel(userID: userID, firstName: firstName, lastName: lastName, nickname: nickname, platformId: platformId, pfImage: pfImage, time: time, date: date, lastMessage: lastMessage, isRead: isRead, level: level, docID: doc.documentID)
                                                                
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
            }
        }
    }
    
    func getChat(senderId: String){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SpecialMessages").document(senderId).collection("Messages").order(by: "fulldate", descending: false).addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.messages.removeAll()
                for doc in snap!.documents {
                    if let  date = doc.get("date") as? String {
                        if let fulldate = doc.get("fulldate") as? String {
                            if let time = doc.get("time") as? String {
                                if let userId = doc.get("userId") as? String {
                                    if let isRead = doc.get("isRead") as? Bool {
                                        if let message = doc.get("message") as? String {
                                            self.count = self.count + 1
                                            let mes = SpecialMessageModel(date: date, fulldate: fulldate, isRead: isRead, message: message, time: time, userId: userId, docID: doc.documentID, tag: self.count)
                                            self.lastMessage = message
                                            self.messages.append(mes)
                                            
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
