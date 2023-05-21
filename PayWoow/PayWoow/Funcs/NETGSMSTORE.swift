//
//  NETGSMSTORE.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 5/30/22.
//

import SwiftUI
import Firebase

class NETGSMStore: ObservableObject{
    let ref = Firestore.firestore()
    @Published var usercode = ""
    @Published var password = ""
    @Published var header = ""
    init(){
        ref.collection("GeneralInfo").document("NETGSM").addSnapshotListener { doc, err in
            if let usercode = doc?.get("usercode") as? String{
                if let password = doc?.get("password") as? String {
                    if let header = doc?.get("header") as? String {
                        self.password = password
                        self.usercode = usercode
                        self.header = header
                    }
                }
            }
        }
    }
}
