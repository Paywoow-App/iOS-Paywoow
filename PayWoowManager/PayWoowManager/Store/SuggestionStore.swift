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
    var platformID: String
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
                    let userId = doc.documentID
                    let img1 = doc.get("img1") as? String ?? ""
                    let img2 = doc.get("img2") as? String ?? ""
                    let img3 = doc.get("img3") as? String ?? ""
                    let pfImage = doc.get("pfImage") as? String ?? ""
                    let fullname = doc.get("fullname") as? String ?? ""
                    let desc = doc.get("description") as? String ?? ""
                    let platformID = doc.get("platformID") as? String ?? ""
                    let title = doc.get("title") as? String ?? ""
                    let timeDate = doc.get("timeDate") as? String ?? ""
                    let data = SuggestionModel(img1: img1, img2: img2, img3: img3, pfImage: pfImage, fullname: fullname, desc: desc, userId: userId, title: title, timeDate: timeDate,platformID: platformID)
                    self.suggest.append(data)
                }
            }
        }
    }
}
