//
//  AgencyListStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/22.
//

import SwiftUI
import FirebaseFirestore

struct ManagerAgencyModel: Identifiable {
    var id = UUID()
    var agencyName : String
    var coverImage : String
    var owner : String
    var agencyId : String
    var streamers : [String]
    var platform : String
}

struct ManagerAgencyMessageModel: Identifiable{
    var id = UUID()
    var docID : String
    var images : [String]
    var isRead : [String]
    var sender : String
    var timeStamp : Int
    var message : String
    var index : Int
    var selection : String
}

struct ManagerModel: Identifiable {
    var id = UUID()
    var firstName : String
    var lastName : String
    var pfImage : String
    var nickname : String
    var token : String
    var userId : String
}

class ManagerAgencyStore : ObservableObject {
    @Published var list : [ManagerAgencyModel] = []
    @Published var messageList : [ManagerAgencyMessageModel] = []
    @Published var tokenList : [String] = []
    @Published var agencyIdList : [String] = []
    @Published var messageCount : Int = 0
    let ref = Firestore.firestore()
    init(){
        ref.collection("Agencies").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.list.removeAll()
                self.agencyIdList.removeAll()
                for doc in snap!.documents {
                    if let agencyName = doc.get("agencyName") as? String {
                        if let coverImage = doc.get("coverImage") as? String {
                            if let owner = doc.get("owner") as? String {
                                if let streamers = doc.get("streamers") as? [String] {
                                    if let platform = doc.get("platform") as? String {
                                        let data = ManagerAgencyModel(agencyName: agencyName, coverImage: coverImage, owner: owner, agencyId: doc.documentID, streamers: streamers, platform: platform)
                                        self.list.append(data)
                                        self.agencyIdList.append(doc.documentID)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMessageList(agencyId: String){
        ref.collection("Agencies").document(agencyId).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.messageList.removeAll(keepingCapacity: false)
                self.messageCount = 0
                for doc in snap!.documents {
                    if let images = doc.get("images") as? [String] {
                        if let isRead = doc.get("isRead") as? [String] {
                            if let sender = doc.get("sender") as? String{
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let message = doc.get("message") as? String {
                                        if let selection = doc.get("selection") as? String {
                                            self.messageCount = self.messageCount + 1
                                            let data = ManagerAgencyMessageModel(docID: doc.documentID, images: images, isRead: isRead, sender: sender, timeStamp: timeStamp, message: message, index: self.messageCount, selection: selection)
                                            self.messageList.append(data)
                                         
                                            self.ref.collection("Users").document(sender).addSnapshotListener { snap2, err in
                                                if err == nil {
                                                    if let token = snap2?.get("token") as? String {
                                                        if !self.tokenList.contains(token) {
                                                            self.tokenList.append(token)
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
