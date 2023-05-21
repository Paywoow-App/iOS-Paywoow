//
//  SupporterDeallerApplicationsStore.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/21/22.
//

import SwiftUI
import Firebase

struct SupporterDeallerApplicationsModel : Identifiable {
    var id = UUID()
    var balance : String
    var email: String
    var fullname : String
    var gender : String
    var pfImage: String
    var phone: String
    var platform: String
    var timeDate: String
    var userId : String
    var bigoId : String
}


class SupporterDeallerApplicationsStore: ObservableObject {
    @Published var requests: [SupporterDeallerApplicationsModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("SupporterDeallerApplications").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
                
            }
            else {
                self.requests.removeAll()
                
                for doc in snap!.documents {
                    if let balance = doc.get("balance") as? String {
                        if let email = doc.get("email") as? String {
                            if let fullname = doc.get("fullname") as? String{
                                if let gender = doc.get("gender") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let phone = doc.get("phone") as? String {
                                            if let platform = doc.get("platform") as? String {
                                                if let timeDate = doc.get("timeDate") as? String {
                                                    if let userId = doc.get("userId") as? String {
                                                        if let bigoId = doc.get("bigoId") as? String {
                                                            let data = SupporterDeallerApplicationsModel(balance: balance, email: email, fullname: fullname, gender: gender, pfImage: pfImage, phone: phone, platform: platform, timeDate: timeDate, userId: userId, bigoId: bigoId)
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
}



struct StreamerApplicationsModel : Identifiable {
    var id = UUID()
    var email: String
    var fullname : String
    var gender : String
    var pfImage: String
    var phone: String
    var platform: String
    var selectedPlatform: String
    var timeDate: String
    var userId : String
    var bigoId : String
}


class StreamerApplicationsStore: ObservableObject {
    @Published var requests: [StreamerApplicationsModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("StreamerApplications").addSnapshotListener { snap, err in
            if err != nil {
                setCareCcode(dealler: "Main", code: "1244")
                
            }
            else {
                self.requests.removeAll()
                
                for doc in snap!.documents {
                    if let email = doc.get("email") as? String {
                        if let fullname = doc.get("fullname") as? String{
                            if let gender = doc.get("gender") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let phone = doc.get("phone") as? String {
                                        if let platform = doc.get("platform") as? String {
                                            if let timeDate = doc.get("timeDate") as? String {
                                                if let userId = doc.get("userId") as? String {
                                                    if let bigoId = doc.get("bigoId") as? String {
                                                        if let selectedPlatform = doc.get("selectedPlatform") as? String {
                                                         let data = StreamerApplicationsModel(email: email, fullname: fullname, gender: gender, pfImage: pfImage, phone: phone, platform: platform, selectedPlatform: selectedPlatform, timeDate: timeDate, userId: userId, bigoId: bigoId)
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
}
