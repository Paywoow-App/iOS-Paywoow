//
//  SwapRequestStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/11/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SwapRequestStore : ObservableObject {
    let ref = Firestore.firestore()
    @Published var list : [SwapRequestModel] = []
    
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SwapRequests").addSnapshotListener { snap, err in
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                    else {
                        self.list.removeAll(keepingCapacity: false)
                        for doc in snap!.documents {
                            self.list.removeAll(keepingCapacity: false)
                            if let userID = doc.get("userID") as? String {
                                if let product = doc.get("product") as? Int {
                                    if let productType = doc.get("productType") as? String {
                                        if let timeStamp = doc.get("timeStamp") as? Int {
                                            if let platform = doc.get("platform") as? String {
                                                if let country = doc.get("country") as? String {
                                                    let data = SwapRequestModel(userID: userID, product: product, productType: productType, timeStamp: timeStamp, platform: platform, country: country, docID: doc.documentID)
                                                    self.list.append(data)
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
