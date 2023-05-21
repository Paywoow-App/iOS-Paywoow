//
//  CustomerMessageModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/30/22.
//

import SwiftUI

struct CustomerMessageModel : Identifiable{
    var id : Int
    var message : String
    var sender : String
    var timeDate : String
    var isRead : Int
}
