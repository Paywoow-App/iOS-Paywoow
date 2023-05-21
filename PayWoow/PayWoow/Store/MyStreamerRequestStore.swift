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

struct LittleMyStreamerRequestModel: Identifiable {
    var id = UUID()
    var streamerID : String
    var timeDate : String
}

class MyStreamerRequestStore : ObservableObject {
    var ref = Firestore.firestore()
    
    @Published var streamer : [LittleMyStreamerRequestModel] = []
    init(){
        if Auth.auth().currentUser != nil {
            
                ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("StreamerRequests").order(by: "timeDate", descending: true).addSnapshotListener { snap, err in
                    if err == nil {
                        self.streamer.removeAll()
                        for doc in snap!.documents {
                            if let timeDate = doc.get("timeDate") as? String {
                                let data = LittleMyStreamerRequestModel(streamerID: doc.documentID, timeDate: timeDate)
                                self.streamer.append(data)
                            }
                        }
                    }
                }
            
        }
    }
}
