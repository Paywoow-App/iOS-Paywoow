//
//  AgencyRequestStore.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/15/21.
//

import SwiftUI
import FirebaseFirestore

struct AgencyRequestModel : Identifiable{
    var id = UUID()
    var agencyName : String
    var firstName : String
    var lastName : String
    var isComplatedTransactions : Bool
    var isVerifiedAgency : Bool
    var level : Int
    var nickname : String
    var pfImage : String
    var phoneNumber : String
    var platformID : String
    var platformName : String
    var streamers : [String]
    var timeDate : String
    var token : String
    var totalStreamers : Int
    var totalWork : Int
    var docID : String
}

class AgencyRequestStore : ObservableObject {
    let ref = Firestore.firestore()
    @Published var requests : [AgencyRequestModel] = []
    
    init(){
        ref.collection("AgencyRequests").addSnapshotListener { snap, err in
            if err == nil {
                self.requests.removeAll()
                for doc in snap!.documents {
                    if let agencyName = doc.get("agencyName") as? String {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let isComplatedTransactions = doc.get("isComplatedTransactions") as? Bool {
                                    if let isVerifiedAgency = doc.get("isVerifiedAgency") as? Bool {
                                        if let level = doc.get("level") as? Int {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let pfImage = doc.get("pfImage") as? String {
                                                    if let phoneNumber = doc.get("phoneNumber") as? String {
                                                        if let platformID = doc.get("platformId") as? String {
                                                            if let streamer = doc.get("streamers") as? [String] {
                                                                if let timeDate = doc.get("timeDate") as? String {
                                                                    if let token = doc.get("token") as? String {
                                                                        if let totalStreamers = doc.get("totalStreamer") as? Int {
                                                                            if let totalWork = doc.get("totalWork") as? Int {
                                                                                if let platformName = doc.get("platformName") as? String {
                                                                                    let data = AgencyRequestModel(agencyName: agencyName, firstName: firstName, lastName: lastName, isComplatedTransactions: isComplatedTransactions, isVerifiedAgency: isVerifiedAgency, level: level, nickname: nickname, pfImage: pfImage, phoneNumber: phoneNumber, platformID: platformID, platformName: platformName, streamers: streamer, timeDate: timeDate, token: token, totalStreamers: totalStreamers, totalWork: totalWork, docID: doc.documentID)
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
                    }
                }
            }
        }
    }
}
