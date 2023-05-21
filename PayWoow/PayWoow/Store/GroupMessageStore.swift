//
//  MessageStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/1/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class GroupMessageStore: ObservableObject{
    let ref = Firestore.firestore()
    @Published var message : [MessageModel] = []
    @Published var info : [GroupInfoModel] = []
    @Published var users : [GroupUserModel] = []
    var id = 0
  
    
    func getData(agency: String){
        
            
            ref.collection("Groups").document("BigoLive").collection(agency).order(by: "fulldate", descending: false).addSnapshotListener { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    self.id = 0
                    self.message.removeAll()
                    for doc in snap!.documents {
                        if let message = doc.get("message") as? String {
                            if let fullname = doc.get("fullname") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let timeDate = doc.get("timeDate") as? String {
                                        if let userId = doc.get("userId") as? String {
                                            if let platformId = doc.get("platformId") as? String {
                                                if let gender = doc.get("gender") as? String {
                                                    if let time = doc.get("time") as? String {
                                                        if let month = doc.get("month") as? String {
                                                            if let level = doc.get("level") as? Int {
                                                                if let addedUser = doc.get("addedUser") as? String {
                                                                    print("added  user \(addedUser)")
                                                                    let customId = self.id + 1
                                                                    self.id = customId
                                                                    let data = MessageModel(message: message, fullname: fullname, pfImage: pfImage, timeDate: timeDate, userId: userId, platformId: platformId, messageId: doc.documentID, gender: gender, customId: customId, time: time, month: month, level: level, addedUser: addedUser)
                                                                    self.message.append(data)
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
            
            ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").addSnapshotListener { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    self.info.removeAll()
                    if let createdDate = snap?.get("createdDate") as? String {
                        if let groupImage = snap?.get("groupImage") as? String {
                            if let groupName = snap?.get("groupName") as? String {
                                if let slider1 = snap?.get("slider1") as? String {
                                    if let slider2 = snap?.get("slider2") as? String {
                                        if let slider3 = snap?.get("slider3") as? String {
                                            if let slider4 = snap?.get("slider4") as? String {
                                                if let leader = snap?.get("leader") as? String {
                                                    let data = GroupInfoModel(createdDate: createdDate, groupImage: groupImage, groupName: groupName, slider1: slider1, slider2: slider2, slider3: slider3, slider4: slider4, leader: leader)
                                                    self.info.append(data)
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
            
            
            ref.collection("Groups").document("BigoLive").collection(agency).document("GroupInfo").collection("Users").addSnapshotListener { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    self.users.removeAll()
                    for doc in snap!.documents {
                        if let userId = doc.get("userId") as? String {
                            if let fullname = doc.get("fullname") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let bigoId = doc.get("bigoId") as? String {
                                        if let loginDate = doc.get("loginDate") as? String {
                                            if let isSlient = doc.get("isSlient") as? Bool {
                                                if let managerLevel = doc.get("managerLevel") as? Int {
                                                    let data = GroupUserModel(userId: userId, fullname: fullname, pfImage: pfImage, bigoId: bigoId, loginDate: loginDate, isSlient: isSlient, managerLevel: managerLevel)
                                                    self.users.append(data)
                                                    print("logindate \(loginDate)")
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
