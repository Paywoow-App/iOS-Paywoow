//
//  r.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/17/22.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ReferanceStore : ObservableObject{
    @Published var users: [ReferanceUserModel] = []
    @Published var totalUser = 0
    @Published var totalUserSoldPrice = 0
    @Published var totalUserGivenGift = 0
    @Published var totalStreamerGift = 0
    @Published var grapich : [Double] = []

    let ref = Firestore.firestore()
    
    init(){

    }
    
    func getUsers(refCode: String){
        ref.collection("Reference").document(refCode).collection("Users").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.users.removeAll()
                self.grapich.removeAll()
                self.totalUser = self.totalUser + 1
                self.totalStreamerGift = 0
                self.totalUserGivenGift = 0
                self.totalUserSoldPrice = 0 // if you remove the old data it will calculate wrongly
                for doc in snap!.documents {
                    if let profileImage = doc.get("profileImage") as? String {
                        if let streamerGivenGift = doc.get("streamerGivenGift") as? Int {
                            if let userBigoId = doc.get("userBigoId") as? String {
                                if let userFullname = doc.get("userFullname") as? String {
                                    if let userGivenGift = doc.get("userGivenGift") as? Int {
                                        if let userId = doc.get("userId") as? String {
                                            if let userSoldPrice = doc.get("userSoldPrice") as? Int {
                                                let data = ReferanceUserModel(profileImage: profileImage, streamerGivenGift: streamerGivenGift, userBigoId: userBigoId, userFullname: userFullname, userGivenGift: userGivenGift, userId: userId, userSoldPrice: userSoldPrice)
                                                self.users.append(data)
                                                self.totalUser = self.totalUser + 1
                                                self.totalStreamerGift = self.totalStreamerGift + streamerGivenGift
                                                self.totalUserGivenGift = self.totalUserGivenGift + userGivenGift
                                                self.totalUserSoldPrice = self.totalUserSoldPrice + userSoldPrice
                                                self.grapich.append(Double(streamerGivenGift))
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
