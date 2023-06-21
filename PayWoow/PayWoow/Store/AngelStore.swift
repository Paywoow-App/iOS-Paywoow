//
//  AngelStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/21/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class AngelStore: ObservableObject {
    @Published var angels : [AngelModel] = []
    @Published var devils : [DevilModel] = []

    let ref = Firestore.firestore()
    
    init(){
        self.getAngels()
        self.getDevils()
    }
    
    func getAngels() {
        ref.collection("Angels").getDocuments { snapchat, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }else {
                guard let snapchat = snapchat else { return }
                
                for document in snapchat.documents {
                    let data = document.data()
                    let timeStamp = data["timeStamp"] as? Int ?? 0
                    
                    DispatchQueue.main.async {
                        let angelData = AngelModel(userID: document.documentID, timeStamp: timeStamp)
                        self.angels.append(angelData)
                    }
                }
            }
        }
    }
    
    //++++++++++++++++++++++++++++++ Devils ++++++++++++++++++++++++++++++++//
    func getDevils() {
        ref.collection("Devils").getDocuments { snapchat, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let snapchat = snapchat else { return }
                
                
                for document in snapchat.documents {
                    let data = document.data()
                    let timeStamp = data["timeStamp"] as? Int ?? 0
                    
                    DispatchQueue.main.async {
                        let devilData = DevilModel(userID: document.documentID, timeStamp: timeStamp)
                        self.devils.append(devilData)
                    }
                    
                
                }
            }
        }
    }

}
