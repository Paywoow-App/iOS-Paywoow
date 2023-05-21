//
//  CustomerServiceStore.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 9/10/22.
//

import SwiftUI
import FirebaseFirestore

struct CustomerServiceModel: Identifiable {
    var id = UUID()
    var bayiId : String
    var createdDate : String
    var firstName : String
    var lastName : String
    var isNew : Bool
    var isOnline : Bool
    var lat : Double
    var long : Double
    var password : String
    var pfImage : String
    var token : String
    var customerId : String
}

class CustomerServiceStore : ObservableObject {
    let ref = Firestore.firestore()
    @Published var data : [CustomerServiceModel] = []
    
    init(){
        ref.collection("CustomerServices").addSnapshotListener { snap, err in
            if err == nil {
                self.data.removeAll()
                for doc in snap!.documents {
                    if let bayiId = doc.get("bayiId") as? String {
                        if let createdDate = doc.get("createdDate") as? String {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let isNEw = doc.get("isNew") as? Bool {
                                        if let isOnline = doc.get("isOnline") as? Bool {
                                            if let lat = doc.get("lat") as? Double {
                                                if let long = doc.get("long") as? Double {
                                                    if let password = doc.get("password") as? String {
                                                        if let pfImage = doc.get("pfImage") as? String {
                                                            if let token = doc.get("token") as? String {
                                                                let data = CustomerServiceModel(bayiId: bayiId, createdDate: createdDate, firstName: firstName, lastName: lastName, isNew: isNEw, isOnline: isOnline, lat: lat, long: long, password: password, pfImage: pfImage, token: token, customerId: doc.documentID)
                                                                self.data.append(data)
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
