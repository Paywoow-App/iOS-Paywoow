//
//  AgencyApplicationQuestion.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AgencyApplicationQuestionModel: Identifiable {
    var id = UUID()
    var agencyName : String
    var firstName : String
    var lastName : String
    var level : Int
    var nickname : String
    var pfImage : String
    var token : String
    var userId : String
}

class AgencyApplicationQuestionStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var req : [AgencyApplicationQuestionModel] = []
    
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyApplicationQuestion").addSnapshotListener { snap, err in
                    if err == nil {
                        self.req.removeAll()
                        for doc in snap!.documents {
                            if let agencyName = doc.get("agencyName") as? String {
                                if let firstName = doc.get("firstName") as? String {
                                    if let lastName = doc.get("lastName") as? String {
                                        if let level = doc.get("level") as? Int {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let pfImage = doc.get("pfImage") as? String {
                                                    if let token = doc.get("token") as? String {
                                                        if let userId = doc.get("userId") as? String {
                                                            let data = AgencyApplicationQuestionModel(agencyName: agencyName, firstName: firstName, lastName: lastName, level: level, nickname: nickname, pfImage: pfImage, token: token, userId: userId)
                                                            self.req.append(data)
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
