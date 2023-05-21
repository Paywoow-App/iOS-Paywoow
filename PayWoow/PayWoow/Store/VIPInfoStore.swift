//
//  VIPInfo.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/22/22.
//

import SwiftUI
import Firebase

class VIPInfo: ObservableObject {
    @AppStorage("userId") var userId: String = "RKuzitS3oaU2P3SI7VHNSCeuTRE2"
    let ref = Firestore.firestore()
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var angelType : String = ""
    @Published var cardNo : String = ""
    @Published var diamond : Int = 0
    @Published var password : String = ""
    @Published var totalPoint : Int = 0
    @Published var vipType : String = ""
    @Published var pfImage : String = ""
    @Published var platformId: String = ""
    @Published var token : String = ""
    @Published var level : Int = 0
    init(){
        ref.collection("VIP").document(self.userId).addSnapshotListener { doc, err in
            if let firstName = doc!.get("firstName") as? String {
                if let lastName = doc!.get("lastName") as? String {
                    if let angelType = doc!.get("angelType") as? String{
                        if let cardNo = doc!.get("cardNo") as? String {
                            if let diamond = doc!.get("diamond") as? Int {
                                if let password = doc!.get("password") as? String {
                                    if let totalPoint = doc!.get("totalPoint") as? Int {
                                        if let vipType = doc!.get("vipType") as? String{
                                            if let pfImage = doc!.get("pfImage") as? String {
                                                if let platformId = doc!.get("platformId") as? String {
                                                    if let token = doc!.get("token") as? String {
                                                        if let level = doc!.get("level") as? Int{
                                                            self.firstName = firstName
                                                            self.lastName = lastName
                                                            self.angelType = angelType
                                                            self.cardNo = cardNo
                                                            self.diamond = diamond
                                                            self.password = password
                                                            self.totalPoint = totalPoint
                                                            self.vipType = vipType
                                                            self.pfImage = pfImage
                                                            self.platformId = platformId
                                                            self.token = token
                                                            self.level = level
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

