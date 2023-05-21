//
//  OrderResultListener.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/31/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class OrderResultListener : ObservableObject{
    @Published var result : Int = 0
    let ref = Firestore.firestore()
    
    func listen(merchant_oid: String){
        ref.collection("OnlineOrder").document(merchant_oid).addSnapshotListener { snap, err in
            if err == nil {
                if let result = snap?.get("result") as? Int {
                    self.result = result
                    if result == 0 {
                        print("Yanit Bekleniyor.....")
                    }
                    else if result == 1 {
                        print("Ödeme Onaylandı")
                    }
                    else if result == 2 {
                        print("Ödeme Reddedildi!")
                    }
                }
            }
        }
    }
}
