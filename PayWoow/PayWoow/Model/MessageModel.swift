//
//  MessageModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct MessageModel: Identifiable {
    var id = UUID()
    var message: String
    var fullname: String
    var pfImage: String
    var timeDate: String
    var userId: String
    var platformId: String
    var messageId: String
    var gender: String
    var customId : Int
    var time : String
    var month : String
    var level : Int
    var addedUser : String
}
