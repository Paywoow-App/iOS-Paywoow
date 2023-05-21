//
//  PlatformStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/12/22.
//

import SwiftUI
import FirebaseFirestore

class PlatformStore: ObservableObject {
    @Published var platforms : [PlatformModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("Platforms").order(by: "globalUsers", descending: true).addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                self.platforms.removeAll()
                for doc in snap!.documents {
                    if let platformName = doc.get("platformName") as? String {
                        if let platformImage = doc.get("platformImage") as? String {
                            if let globalUsers = doc.get("globalUsers") as? Int {
                                if let isActive = doc.get("isActive") as? Bool {
                                    let data = PlatformModel(platformName: platformName, platformImage: platformImage, platformDocId: doc.documentID, globalUsers: globalUsers, isActive: isActive)
                                    self.platforms.append(data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
