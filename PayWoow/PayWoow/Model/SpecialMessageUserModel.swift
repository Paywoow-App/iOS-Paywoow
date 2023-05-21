//
//  SpecialMessageUserModel.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/15/22.
//

import SwiftUI

struct SpecialMessageUserModel: Identifiable{
    var id = UUID()
    var userID: String
    var firstName: String
    var lastName: String
    var nickname: String
    var platformId: String
    var pfImage: String
    var time: String
    var date: String
    var lastMessage: String
    var isRead: Bool
    var level: Int
    var docID: String
}
