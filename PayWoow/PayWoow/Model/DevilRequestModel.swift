//
//  DevilRequestModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/16/22.
//

import SwiftUI

struct DevilRequestModel: Identifiable {
    var id = UUID()
    var userID : String
    var pfImage : String
    var firstName : String
    var lastName : String
    var nicknaame : String
    var level : Int
    var token : String
    var classs : String
    var when : String
    var point : Int
    var diamond : Int
    var sender : String
}
