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
        ref.collection("Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let querySnapshot = querySnapshot else {
                    print("Error fetching documents.")
                    return
                }
                for document in querySnapshot.documents {
                    let data = document.data()
                    let accountLevel = data["accountLevel"] as? Int ?? 0
                    
                    let timeStamp = data["timeStamp"] as? Int ?? 0
                    if accountLevel == 1 {
                        DispatchQueue.main.async {
                            let angalData = AngelModel(userID: document.documentID, timeStamp: timeStamp)
                            self.angels.append(angalData)
                        }
                    } else if accountLevel == 0 {
                        let devilData = DevilModel(userID: document.documentID, timeStamp: timeStamp)
                        self.devils.append(devilData)
                    }                    
                }
            }
        }
        //++++++++++++++++++++++++++++++ Devils ++++++++++++++++++++++++++++++++//
        
    }

}
