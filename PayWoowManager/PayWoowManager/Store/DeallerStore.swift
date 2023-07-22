//
//  BayiiMainStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/5/21.
//

import SwiftUI
import FirebaseFirestore

class DeallerStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var isActiveSecure : Bool = false
    @Published var isLive : Bool = false
    @Published var password : String = ""
    @Published var phoneNumber : String = ""
    @Published var token : String = ""
    @AppStorage("storeNick") var storeNick : String = ""
    @AppStorage("storeSelectedApp") var storeSelectedApp : String = ""
    
    init(){
        if self.storeNick.count > 6{
                        
            
            ref.collection("Bayii").document(storeNick).addSnapshotListener { doc, err in
                if let error = err {
                    print(error.localizedDescription)
                }
                
                let isActiveSecure = doc?.get("isActiveSecure") as? Bool ?? false
                let isLive = doc?.get("isLive") as? Bool ?? false
                let password = doc?.get("password") as? String ?? ""
                let phoneNumber = doc?.get("phoneNumber") as? String ?? ""
                let token = doc?.get("token") as? String ?? ""
                let selectedApp = doc?.get("selectedApp") as? String ?? ""
                print("PayWoowManagerSystem: OBOOĞ \(selectedApp)")
                self.isActiveSecure = isActiveSecure
                self.isLive = isLive
                self.password = password
                self.phoneNumber = phoneNumber
                self.token = token
                self.storeSelectedApp = selectedApp
            }
        }
    }
}
