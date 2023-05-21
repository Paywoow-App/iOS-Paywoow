//
//  String+Extension.swift
//  PayWoow
//
//  Created by Mert Türedü on 3.05.2023.
//

import SwiftUI

extension String {
    var isValidEmail: Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: self)
        }
}
