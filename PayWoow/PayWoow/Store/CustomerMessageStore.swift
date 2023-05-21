//
//  File.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/25/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class CustomerMessageStore : ObservableObject {
    @Published var messages : [CustomerMessageModel] = []
    let ref = Firestore.firestore()
    @Published var count = 0
    func getChat(customerId: String){
        ref.collection("CustomerServices").document(customerId).collection("Users").document(Auth.auth().currentUser!.uid).collection("Chat").order(by: "timeDate", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.count = 0
                self.messages.removeAll()
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let message = doc.get("message") as? String {
                            if let isRead = doc.get("isRead") as? Int {
                                if let timeDate = doc.get("timeDate") as? String {
                                    self.count = self.count + 1
                                    let data = CustomerMessageModel(sender: sender, message: message, isRead: isRead, timeDate: timeDate, mesID: doc.documentID, index: self.count)
                                    self.messages.append(data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

