//
//  GiftRequestAdminStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/21.
//

import SwiftUI
import Firebase

struct GiftRequestAdminModel: Identifiable{
    var id = UUID()
    var userId : String
    var bigoId : String
    var email : String
    var firstName : String
    var lastName : String
    var gift : Int
    var giftDate : String
    var level : Int
    var pfImage : String
    var result : String
}

class GiftRequestAdminStore : ObservableObject {
    @Published var store : [GiftRequestAdminModel] = []
    let ref = Firestore.firestore()
    func getData(dealler: String){
        
            ref.collection("GiftRequest").order(by: "giftDate").addSnapshotListener { snap, error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    self.store.removeAll(keepingCapacity: false)
                    for doc in snap!.documents {
                        if let bigoId = doc.get("bigoId") as? String {
                            if let email = doc.get("email") as? String {
                                if let firstName = doc.get("firstName") as? String {
                                    if let lastName = doc.get("lastName") as? String {
                                        if let gift = doc.get("gift") as? Int {
                                            if let giftDate = doc.get("giftDate") as? String {
                                                if let level = doc.get("level") as? Int {
                                                    if let pfImage = doc.get("pfImage") as? String {
                                                        if let result = doc.get("result") as? String {
                                                            let data = GiftRequestAdminModel(userId: doc.documentID, bigoId: bigoId, email: email, firstName: firstName, lastName: lastName, gift: gift, giftDate: giftDate, level: level, pfImage: pfImage, result: result)
                                                            
                                                            self.store.append(data)
                                                            print(data)
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
