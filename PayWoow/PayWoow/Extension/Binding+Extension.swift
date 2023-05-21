//
//  Binding+Extension.swift
//  PayWoow
//
//  Created by Mert Türedü on 2.05.2023.
//

import SwiftUI

extension Binding where Value == String {
    
    /// Set doc
    func limit(_ lenght: Int) -> Self {
        if self.wrappedValue.count > lenght {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(lenght))
            }
        }
        return self
    }
    
    
}


