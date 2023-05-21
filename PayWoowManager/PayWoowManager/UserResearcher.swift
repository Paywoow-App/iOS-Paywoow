//
//  UserResearcher.swift
//  
//
//  Created by İsa Yılmaz on 5/31/22.
//

import SwiftUI
import Firebase

class UserResearcher: ObservableObject{
    @Published var gift : Int = 0
    @Published var token : String = ""
    let ref = Firestore.firestore()
    
    func fetchUserDetails(userId: String){
        if userId != "" {
            ref.collection("Users").document(userId).addSnapshotListener { doc, err in
                if  err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    if let gift = doc?.get("gift") as? Int {
                        if let token = doc?.get("token") as? String {
                            self.gift = gift
                            self.token = token
                        }
                    }
                }
            }
        }
    }
}
