//
//  PayTRStore.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 5/29/22.
//

import SwiftUI
import Firebase

class PayTRStore: ObservableObject{
    let ref = Firestore.firestore()
    @Published var merchant_salt = ""
    @Published var merchant_key = ""
    @Published var merchant_id = ""
    @Published var merchant_ok_url = ""
    @Published var merchant_fail_url = ""
    @Published var post_url = ""
    init(){
        ref.collection("GeneralInfo").document("PAYTR").addSnapshotListener { doc, err in
            if let merchant_salt = doc?.get("merchant_salt") as? String{
                if let merchant_key = doc?.get("merchant_key") as? String {
                    if let merchant_id = doc?.get("merchant_id") as? String {
                        if let merchant_ok_url = doc?.get("merchant_ok_url") as? String {
                            if let merchant_fail_url = doc?.get("merchant_fail_url") as? String {
                                if let post_url = doc?.get("post_url") as? String {
                                    self.merchant_id = merchant_id
                                    self.merchant_key = merchant_key
                                    self.merchant_salt = merchant_salt
                                    self.merchant_ok_url = merchant_ok_url
                                    self.merchant_fail_url = merchant_fail_url
                                    self.post_url = post_url
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

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
