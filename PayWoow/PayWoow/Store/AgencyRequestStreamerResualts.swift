//
//  AgencyRequestStreamerResualts.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyRequestStreamerResultsModel: Identifiable{
    var id = UUID()
    var firstName : String
    var lastName : String
    var pfImage : String
    var token : String
    var isAccepted : Int
    var level : Int
    var userId : String
    var nickname : String
}

class AgencyRequestStreamerResultStore: ObservableObject{
    let ref = Firestore.firestore()
    @Published var streamers : [AgencyRequestStreamerResultsModel] = []
    @Published var acceptedCount : Int = 0
    
    func getData(){
        ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).collection("Streamers").addSnapshotListener { snap, err in
            if err == nil {
                self.acceptedCount = 0
                self.streamers.removeAll()
                for doc in snap!.documents {
                    if let userId = doc.get("userId") as? String {
                        self.ref.collection("Users").document(userId).addSnapshotListener { docc, err in
                            if err == nil {
                                if let firstName = docc?.get("firstName") as? String {
                                    if let lastName = docc?.get("lastName") as? String {
                                        if let pfImage = docc?.get("pfImage") as? String {
                                            if let token = docc?.get("token") as? String {
                                                if let level = docc?.get("level") as? Int {
                                                    if let nickname = docc?.get("nickname") as? String {
                                                        let data = [
                                                            "firstName" : firstName,
                                                            "lastName" : lastName,
                                                            "pfImage" : pfImage,
                                                            "token" : token,
                                                            "level" : level,
                                                            "nickname" : nickname
                                                        ] as [String : Any]
                                                        self.ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).collection("Streamers").document(userId).setData(data, merge: true)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let token = doc.get("token") as? String {
                                        if let level = doc.get("level") as? Int {
                                            if let userId = doc.get("userId") as? String {
                                                if let isAccepted = doc.get("isAccepted") as? Int {
                                                    if let nickname = doc.get("nickname") as? String {
                                                        let data = AgencyRequestStreamerResultsModel(firstName: firstName, lastName: lastName, pfImage: pfImage, token: token, isAccepted: isAccepted, level: level, userId: userId, nickname: nickname)
                                                        self.streamers.append(data)
                                                        
                                                        if isAccepted == 2 {
                                                            self.acceptedCount = self.acceptedCount + 1
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
