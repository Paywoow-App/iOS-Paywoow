//
//  GroupSwapUserModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct GroupSwapUserModel: Identifiable {
    var id = UUID()
    var bigoId : String
    var diamond : Int
    var fullname: String
    var level : Int
    var pfImage : String
    var timeDate : String
    var userId : String
}
