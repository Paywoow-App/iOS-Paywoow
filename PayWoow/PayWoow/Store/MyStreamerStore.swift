//
//  MyStreamerStore.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/15/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class MyStreamerStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var streamer : [MyStreamerModel] = []
    
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("MyStreamers").order(by: "timeDate", descending: true).addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.streamer.removeAll(keepingCapacity: false)
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if let fullname = doc.get("fullname") as? String {
                            if let pfImage = doc.get("pfImage") as? String {
                                if let timeDate = doc.get("timeDate") as? String {
                                    if let userId = doc.get("userId") as? String {
                                        let data = MyStreamerModel(bigoId: bigoId, fullname: fullname, pfImage: pfImage, timeDate: timeDate, userid: userId)
                                        self.streamer.append(data)
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
