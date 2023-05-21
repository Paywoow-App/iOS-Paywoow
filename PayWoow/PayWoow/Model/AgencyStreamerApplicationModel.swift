//
//  AgencyStreamerApplicationModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/1/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AgencyStreamerApplicationModel: Identifiable{
    var id = UUID()
    var agencyUserId: String
    var pfImage : String
    var firstName : String
    var lastName: String
    var nickname : String
    var platformID: String
    var platformName : String
    var token : String
    var timeDate : String
    var agencyName : String
    var agencyID : String
}


class AgencyStreamerApplicationStore: ObservableObject{
    @Published var requests : [AgencyStreamerApplicationModel] = []
    let ref = Firestore.firestore()
    init(){
        if Auth.auth().currentUser != nil {
            self.fetchData()
        }
    }
    
    func fetchData(){
        self.ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyStreamerApplications").addSnapshotListener { snap, err in
            if err == nil {
                self.requests.removeAll()
                for doc in snap!.documents {
                    if let firstName = doc.get("firstName") as? String {
                        if let lastName = doc.get("lastName") as? String {
                            if let pfImage = doc.get("pfImage") as? String {
                                if let token = doc.get("token") as? String {
                                    if let nickname = doc.get("nickname") as? String {
                                        if let platformId = doc.get("platformId") as? String {
                                            if let platformName = doc.get("platformName") as? String {
                                                if let timeDate = doc.get("timeDate") as? String {
                                                    if let agencyID = doc.get("agencyID") as? String {
                                                        let data = AgencyStreamerApplicationModel(agencyUserId: doc.documentID, pfImage: pfImage, firstName: firstName, lastName: lastName, nickname: nickname, platformID: platformId, platformName: platformName, token: token, timeDate: timeDate, agencyName: "", agencyID: agencyID)
                                                        self.requests.append(data)
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
