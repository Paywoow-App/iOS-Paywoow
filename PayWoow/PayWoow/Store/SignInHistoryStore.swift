//
//  SignInHistoryStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/22/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class SignInHistoryStore: ObservableObject{
    let ref = Firestore.firestore()
    @Published var history : [SignInHistoryModel] = []
    
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.history.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let long = doc.get("long") as? Double {
                        if let lat = doc.get("lat") as? Double {
                            if let device = doc.get("device") as? String {
                                if let accepted = doc.get("accepted") as? Int {
                                    if let date = doc.get("date") as? String {
                                        if let time = doc.get("time") as? String {
                                            let data = SignInHistoryModel(lat: lat, long: long, device: device, date: date, time: time, accepted: accepted, docId: doc.documentID)
                                            self.history.append(data)
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
