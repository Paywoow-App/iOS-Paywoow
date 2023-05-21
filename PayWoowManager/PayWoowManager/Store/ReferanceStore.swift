//
//  ReferanceStore.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/22/21.
//

import SwiftUI
import Firebase

struct ReferanceModel: Identifiable {
    var id = UUID()
    var contactUserID : String
    var fullname : String
    var pfImage : String
    var referanceCode : String
    var bigoId : String
}


struct ReferanceUserModel: Identifiable{
    var id = UUID()
    var profileImage : String
    var streamerGivenGift : Int
    var userBigoId : String
    var userFullname : String
    var userGivenGift : Int
    var userId : String
    var userSoldPrice : Int
}

class ReferanceStore : ObservableObject{
    @Published var references : [ReferanceModel] = []
    @Published var referenceUsers : [ReferanceUserModel] = []
    @Published var totalStreamerGivenGift = 0
    @Published var totalUserGivenGift = 0
    @Published var totalUserSoldPrice = 0
    @Published var totalUser = 0
    let ref = Firestore.firestore()
    init(){
        ref.collection("Reference").addSnapshotListener { snaps, err in
            if err != nil {
                setCareCcode(dealler: "Main", code: "8809")
            }
            else {
                self.references.removeAll()
                
                for snap in snaps!.documents {
                    if let contactId = snap.get("contactUserId") as? String {
                        if let fullname = snap.get("fullname") as? String{
                            if let pfImage = snap.get("pfImage") as? String {
                                if let referenceCode = snap.get("referenceCode") as? String {
                                    if let bigoId = snap.get("bigoId") as? String {
                                        let data = ReferanceModel(contactUserID: contactId, fullname: fullname, pfImage: pfImage, referanceCode: referenceCode, bigoId: bigoId)
                                        self.references.append(data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getUserList(referenceCode: String){
        ref.collection("Reference").document(referenceCode).collection("Users").addSnapshotListener { snap, err in
            if err != nil {
                setCareCcode(dealler: "Main", code: "8809")
            }
            else {
                self.referenceUsers.removeAll()
                self.totalUser = 0
                self.totalStreamerGivenGift = 0
                self.totalUserGivenGift = 0
                self.totalUserSoldPrice = 0
                for doc in snap!.documents{
                    if let profileImage = doc.get("profileImage") as? String {
                        if let streamerGivenGift = doc.get("streamerGivenGift") as? Int {
                            if let userBigoId = doc.get("userBigoId") as? String {
                                if let userFullname = doc.get("userFullname") as? String {
                                    if let userGivenGift = doc.get("userGivenGift") as? Int {
                                        if let userId = doc.get("userId") as? String {
                                            if let userSoldPrice = doc.get("userSoldPrice") as? Int {
                                                
                                                self.totalUser = self.totalUser + 1
                                                self.totalStreamerGivenGift = self.totalStreamerGivenGift + streamerGivenGift
                                                self.totalUserSoldPrice = self.totalUserSoldPrice + userSoldPrice
                                                self.totalUserGivenGift = self.totalUserGivenGift + userGivenGift
                                                
                                                let data = ReferanceUserModel(profileImage: profileImage, streamerGivenGift: streamerGivenGift, userBigoId: userBigoId, userFullname: userFullname, userGivenGift: userGivenGift, userId: userId, userSoldPrice: userSoldPrice)
                                                self.referenceUsers.append(data)
                                                
                                                print("ref Deatils \(data)")
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
