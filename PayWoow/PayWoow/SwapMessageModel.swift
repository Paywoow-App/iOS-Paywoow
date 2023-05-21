//
//  SwapMessageModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/11/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SwapMessageModel : Identifiable {
    var id = UUID()
    var sender : String
    var isRead : [String]
    var timeStamp : Int
    var message : String
    var docID : String
    var index : Int
}
