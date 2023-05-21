//
//  PlatformStore.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/24/22.
//

import FirebaseFirestore
import SwiftUI

struct PlatformModel: Identifiable {
    var id = UUID()
    var platformImage : String
    var platformName : String
    var globalUsers : Int
}

class PlatformStore: ObservableObject {
    @Published var list : [PlatformModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("Platforms").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let platformName = doc.get("platformName") as? String {
                        if let platformImage = doc.get("platformImage") as? String {
                            if let globalUsers = doc.get("globalUsers") as? Int {
                                let data = PlatformModel(platformImage: platformImage, platformName: platformName, globalUsers: globalUsers)
                                self.list.append(data)
                            }
                        }
                    }
                }
            }
        }
    }
}

