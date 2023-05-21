//
//  CustomerServicesStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class CustomerServicesStore: ObservableObject {
    @Published var data : [CustomerModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("CustomerServices").addSnapshotListener { snap, err in
            if err == nil {
                self.data.removeAll()
                for doc in snap!.documents {
                    if let bayiId = doc.get("bayiId") as? String {
                        if let createdDate = doc.get("createdDate") as? String {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let isOnline = doc.get("isOnline") as? Bool {
                                        if let pfImage = doc.get("pfImage") as? String {
                                            if let token = doc.get("token") as? String {
                                                let data = CustomerModel(bayiId: bayiId, createdDate: createdDate, firstName: firstName, lastName: lastName, isOnline: isOnline, pfImage: pfImage, token: token, customerId: doc.documentID)
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
