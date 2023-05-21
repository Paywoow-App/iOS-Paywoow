//
//  SpecialMessageModel.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/16/22.
//

import SwiftUI

struct SpecialMessageModel: Identifiable {
    var id = UUID()
    var date : String
    var fulldate : String
    var isRead : Bool
    var message: String
    var time: String
    var userId: String
    var docID: String
    var tag: Int
}
