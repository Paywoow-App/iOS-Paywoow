//
//  SwapStore.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/9/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SwapStore : ObservableObject {
    @Published var swapList : [SwapModel] = []
    @Published var complatedList : [MatchedSwapModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("Swaps").order(by: "timeStamp", descending: true).addSnapshotListener { snap, err in
            if err == nil {
                self.swapList.removeAll()
                for doc in snap!.documents {
                    if let timeStamp = doc.get("timeStamp") as? Int {
                        if let product = doc.get("product") as? Int {
                            if let productType = doc.get("productType") as? String {
                                if let selectedPlatform = doc.get("selectedPlatform") as? String {
                                    if let country = doc.get("country") as? String {
                                        let data = SwapModel(userID: doc.documentID, timeStamp: timeStamp, product: product, productType: productType, selectedPlatform: selectedPlatform, country: country)
                                        self.swapList.append(data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        ref.collection("ComplatedSwaps").addSnapshotListener { snap, err in
            if err == nil {
                self.complatedList.removeAll()
                for doc in snap!.documents {
                    if let firstUserID = doc.get("firstUserID") as? String {
                        if let secondUserID = doc.get("secondUserID") as? String {
                            if let product = doc.get("product") as? Int {
                                if let productType = doc.get("productType") as? String {
                                    if let country = doc.get("country") as? String {
                                        if let platform = doc.get("platform") as? String {
                                            if let timeStamp = doc.get("timeStamp") as? Int {
                                                if let platformID = doc.get("platformID") as? String {
                                                    if let chatID = doc.get("chatID") as? String {
                                                        let data = MatchedSwapModel(firstUserID: firstUserID, secondUserID: secondUserID, product: product, productType: productType, platform: platform, timeStamp: timeStamp, country: country, platformID: platformID, docID: doc.documentID, chatID: chatID)
                                                        self.complatedList.append(data)
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
        }
    }
}
