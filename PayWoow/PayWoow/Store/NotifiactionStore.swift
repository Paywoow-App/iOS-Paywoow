//
//  NotifiactionStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/1/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class NotificationsStore: ObservableObject {
    @Published var notifications : [NotificationsModel] = []
    @Published var noifyCount : Int = 0
    @Published var message : String = ""
    @Published var bayiiname : String = ""
    
    let ref = Firestore.firestore()
//    init() {
//        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Notifications").order(by: "date", descending: true).addSnapshotListener { snap, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            else {
//                self.notifications.removeAll(keepingCapacity: false)
//                for doc in snap!.documents {
//                    if let bayiiName = doc.get("bayiiName") as? String {
//                        if let bayiiImage = doc.get("bayiiImage") as? String {
//                            if let bayiiId = doc.get("bayiiId") as? String {
//                                if let date = doc.get("date") as? String {
//                                    if let message = doc.get("message") as? String {
//                                        let data = NotificationsModel(bayiiName: bayiiName, bayiiImage: bayiiImage, bayiiId: bayiiId, date: date, message: message)
//
//                                        self.notifications.append(data)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Notifications").order(by: "date", descending: false).addSnapshotListener { snap, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            else {
//                self.notifications.removeAll(keepingCapacity: false)
//                for doc in snap!.documents {
//                    if let bayiiName = doc.get("bayiiName") as? String {
//                        if let bayiiImage = doc.get("bayiiImage") as? String {
//                            if let bayiiId = doc.get("bayiiId") as? String {
//                                if let date = doc.get("date") as? String {
//                                    if let message = doc.get("message") as? String {
//                                        let data = NotificationsModel(bayiiName: bayiiName, bayiiImage: bayiiImage, bayiiId: bayiiId, date: date, message: message)
//
//                                        self.notifications.append(data)
//
//                                        self.bayiiname = bayiiName
//                                        self.message = message
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//    }
}

