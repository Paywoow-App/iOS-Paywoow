//
//  UserStore.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/22/21.
//

import SwiftUI
import Firebase

struct UserContentModel: Identifiable, Codable {
    var id = UUID()
    var firstName : String
    var lastName : String
    var pfImage : String
    var level : Int
    var accountCreatedDate : Int
    var city : String
    var town : String
    var platform : String
    var platformId : String
    var gender : String
    var email : String
    var isOnline : Bool
    var totalSoldDiamond : Int
    var phoneNumber : String
    var gift : Int
    var block : Bool
    var lat: Double
    var long: Double
    var userId : String
}

struct UserLocationModel: Identifiable {
    var id = UUID()
    var userId : String
    var lat: Double
    var long: Double
}

class UserStore: ObservableObject{
    @Published var users : [UserContentModel] = []
    @Published var usersLocation : [UserLocationModel] = []
    let ref = Firestore.firestore()
    
    init() {

    }
    
    func getUser() {
            ref.collection("Users").order(by: "accountCreatedDate", descending: true).addSnapshotListener { snaps, err in
                if err != nil {
                    setCareCcode(dealler: "Main", code: "4108")
                }
                else {
                    self.users.removeAll()
                    self.usersLocation.removeAll()
                    for doc in snaps!.documents {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let level = doc.get("level") as? Int {
                                        if let accountCreatedDate = doc.get("accountCreatedDate") as? Int {
                                            if let city = doc.get("city") as? String {
                                                if let town = doc.get("town") as? String {
                                                    if let platform = doc.get("selectedPlatform") as? String {
                                                        if let platformId = doc.get("platformID") as? String {
                                                            if let gender = doc.get("gender") as? String {
                                                                if let gift = doc.get("gift") as? Int {
                                                                    if let email = doc.get("email") as? String {
                                                                        if let isOnline = doc.get("isOnline") as? Bool {
                                                                            if let totalSoldDiamond = doc.get("totalSoldDiamond") as? Int {
                                                                                if let phoneNumber = doc.get("phoneNumber") as? String {
                                                                                    if let lat = doc.get("lat") as? Double {
                                                                                        if let long = doc.get("long") as? Double {
                                                                                            if let block = doc.get("block") as? Bool {
                                                                                                let data = UserContentModel(firstName: firstName, lastName: lastName, pfImage: pfImage, level: level, accountCreatedDate: accountCreatedDate, city: city, town: town, platform: platform, platformId: platformId, gender: gender, email: email, isOnline: isOnline, totalSoldDiamond: totalSoldDiamond, phoneNumber: phoneNumber, gift: gift, block: block,lat: lat, long: long, userId: doc.documentID)
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
                                }
                            }
                        }
                    }
                }
            }
    }
}
