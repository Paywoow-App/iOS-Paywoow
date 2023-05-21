//
//  FeedbackStore.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 2/25/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Foundation



class FeedbackStore: ObservableObject{
    
    @Published var feedbacks : [FeedbackModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Feedbacks").order(by: "timeDate", descending: true).addSnapshotListener { snap, err in
            if err != nil {
                print("Feedback Store Error")
            }
            else {
                self.feedbacks.removeAll()
                for doc in snap!.documents{
                    if let description = doc.get("description") as? String {
                        if let title = doc.get("title") as? String {
                            if let timeDate = doc.get("timeDate") as? String {
                                if let img1 = doc.get("img1") as? String {
                                    if let img2 = doc.get("img2") as? String {
                                        if let img3 = doc.get("img3") as? String {
                                            let data = FeedbackModel(description: description, title: title, timeDate: timeDate, img1: img1, img2: img2, img3: img3)
                                            self.feedbacks.append(data)
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
