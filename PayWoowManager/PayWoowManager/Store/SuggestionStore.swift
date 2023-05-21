//
//  SuggestionStore.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/22/22.
//

import SwiftUI
import Firebase

struct SuggestionModel : Identifiable{
    var id = UUID()
    var img1 : String
    var img2 : String
    var img3 : String
    var pfImage : String
    var fullname : String
    var desc : String
    var userId : String
    var title : String
    var timeDate : String
    var bigoId : String
}


class SuggestionStore: ObservableObject {
    let ref = Firestore.firestore()
    @Published var suggest : [SuggestionModel] = []
    
    init(){
        ref.collection("Suggestions").addSnapshotListener { snap, err in
            if err != nil {
                print(err!.localizedDescription)
            }
            else {
                for doc in snap!.documents {
                    if let img1 = doc.get("img1") as? String {
                        if let img2 = doc.get("img2") as? String {
                            if let img3 = doc.get("img3") as? String {
                                if let pfImage = doc.get("pfImage") as? String {
                                    if let fullname = doc.get("fullname") as? String {
                                        if let desc = doc.get("description") as? String {
                                            if let userId = doc.get("userId") as? String {
                                                if let title = doc.get("title") as? String {
                                                    if let timeDate = doc.get("timeDate") as? String {
                                                        if let bigoId = doc.get("bigoId") as? String {
                                                            let data = SuggestionModel(img1: img1, img2: img2, img3: img3, pfImage: pfImage, fullname: fullname, desc: desc, userId: userId, title: title, timeDate: timeDate, bigoId: bigoId)
                                                            self.suggest.append(data)
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
}
