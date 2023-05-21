//
//  PlatformStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/14/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddedPlatformStore: ObservableObject{
    @Published var platforms : [SelectedPlatformModel] = []
    let ref = Firestore.firestore()
    
    
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").addSnapshotListener { snap, er in
            if er != nil {
                print("er")
            }
            else {
                self.platforms.removeAll()
                for doc in snap!.documents {
                    if let platformId = doc.get("platformId") as? String {
                        if let platformLogo = doc.get("platformLogo") as? String{
                            if let platformName = doc.get("platformName") as? String {
                                let data = SelectedPlatformModel(platformId: platformId, platformLogo: platformLogo, platformName: platformName)
                                self.platforms.append(data)
                            }
                        }
                    }
                }
            }
        }
    }
}
