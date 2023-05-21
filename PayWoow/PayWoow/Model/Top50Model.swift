//
//  Top50Model.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct Top50Model: Identifiable{
    var id = UUID()
    var fullname : String
    var totalSoldDiamond: Int
    var platformId: String
    var pfImage : String
    var userId: String
    var gift : Int
    var index : Int
    var accountLevel : Int
    var level: Int
    var verify : Bool
    var nickname: String
    var vipType : String
    var casper : Bool
}
