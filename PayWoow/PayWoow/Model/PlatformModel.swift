//
//  PlatformModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/12/22.
//

import SwiftUI

struct PlatformModel: Identifiable{
    var id = UUID()
    var platformName : String
    var platformImage : String
    var platformDocId : String
    var globalUsers : Int
    var isActive : Bool 
}
