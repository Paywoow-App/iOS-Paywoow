//
//  TokenResearcher.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/13/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class TokenResearcher: ObservableObject {
    @Published var userToken : String = ""
    let ref = Firestore.firestore()
    func getToken(userId: String){
        ref.collection("Users").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                for doc in snap!.documents {
                    if doc.documentID == userId {
                        if let token = doc.get("token") as? String {
                            self.userToken = token
                            print("userToken \(self.userToken)")
                        }
                    }
                }
            }
        }
    }
}
