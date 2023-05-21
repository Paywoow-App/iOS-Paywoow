//
//  GroupInfoModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct GroupInfoModel: Identifiable {
    var id = UUID()
    var createdDate : String
    var groupImage : String
    var groupName : String
    var slider1 : String
    var slider2 : String
    var slider3 : String
    var slider4 : String
    var leader : String
}
