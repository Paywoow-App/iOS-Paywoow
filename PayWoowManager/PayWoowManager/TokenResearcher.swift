//
//  TokenResearcher.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 5/27/22.
//

import SwiftUI
import Firebase

class TokenResearcher: ObservableObject{
    @Published var fetchedToken: String = ""
    let ref = Firestore.firestore()
    func findToken(userId: String){
        ref.collection("Users").document(userId).addSnapshotListener { doc, err in
            if err != nil {
                print("user token is empty")
            }
            else {
                if let token = doc?.get("token") as? String {
                    self.fetchedToken = token
                    print(token)
                }
            }
        }
    }
}
