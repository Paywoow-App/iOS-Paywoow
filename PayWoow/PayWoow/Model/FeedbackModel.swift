//
//  FeedbackModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct FeedbackModel : Identifiable {
    var id = UUID()
    var description : String
    var title: String
    var timeDate: String
    var img1: String
    var img2: String
    var img3: String
}
