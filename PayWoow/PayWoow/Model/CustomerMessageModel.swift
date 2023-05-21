//
//  CustomerMessageModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct CustomerMessageModel : Identifiable{
    var id = UUID()
    var sender : String
    var message : String
    var isRead : Int
    var timeDate : String
    var mesID : String
    var index : Int
}
