//
//  PlatformModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation

struct SelectedPlatformModel : Identifiable{
    var id = UUID()
    var platformId : String
    var platformLogo : String
    var platformName : String
}
