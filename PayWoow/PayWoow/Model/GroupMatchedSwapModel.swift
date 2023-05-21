//
//  GroupMatchedSwapModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct GroupMatchedSwapModel: Identifiable{
    var id = UUID()
    var bigoId : String
    var diamond : Int
    var fullname: String
    var level : Int
    var timeDate : String
    var userId : String
    var pfImage : String
    var secondUserId : String
    var secondPfImage : String
}
