//
//  NotificationModel.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI

struct NotificationsModel: Identifiable {
    var id = UUID()
    var bayiiName : String
    var bayiiImage : String
    var bayiiId : String
    var date : String
    var message : String
}
