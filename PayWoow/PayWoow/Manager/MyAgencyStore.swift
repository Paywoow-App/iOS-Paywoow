//
//  MyAgencyStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/5/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MyAgencyMessageModel : Identifiable {
    var id = UUID()
    var images : [String]
    var isRead : [String]
    var message : String
    var selection : String
    var sender : String
    var timeStamp : Int
    var docId : String
    var index : Int
}

class MyAgencyStore: ObservableObject {
    //MARK: Agency Info
    @Published var agencyName : String = ""
    @Published var coverImage : String = ""
    @Published var platform : String = ""
    @Published var streamers : [String] = []
    
    //MARK: Agency and Manager Chat
    @Published var messages : [MyAgencyMessageModel] = []
    @Published var tokenList : [String] = []
    @Published var messageCount : Int = 0
    
    let ref = Firestore.firestore()
    
    func getData(agencyId: String){
        ref.collection("Agencies").document(agencyId).addSnapshotListener { doc, err in
            if err == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    if let coverImage = doc?.get("coverImage") as? String {
                        if let platform = doc?.get("platform") as? String {
                            if let streamers = doc?.get("streamers") as? [String] {
                                self.agencyName = agencyName
                                self.coverImage = coverImage
                                self.platform = platform
                                self.streamers = streamers
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMessages(agencyId: String){
        ref.collection("Agencies").document(agencyId).collection("Chat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.messages.removeAll()
                for doc in snap!.documents {
                    if let images = doc.get("images") as? [String] {
                        if let isRead = doc.get("isRead") as? [String] {
                            if let message = doc.get("message") as? String {
                                if let selection = doc.get("selection") as? String {
                                    if let sender = doc.get("sender") as? String {
                                        if let timeStamp = doc.get("timeStamp") as? Int {
                                            self.messageCount = self.messageCount + 1
                                            let data = MyAgencyMessageModel(images: images, isRead: isRead, message: message, selection: selection, sender: sender, timeStamp: timeStamp, docId: doc.documentID, index: self.messageCount)
                                            self.messages.append(data)
                                            
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
