//
//  Wallet.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/28/22.
//

import SwiftUI

struct Wallet: View {
    @StateObject var general = GeneralStore()
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            ZStack{
                Circle()
                    .fill(Color.init(hex: "#1CC4BE"))
                    .frame(width: 110, height: 110)
                    .padding(.trailing, 70)
                    .blur(radius: 5)
                
                Circle()
                    .fill(Color.init(hex: "#122BB4"))
                    .frame(width: 110, height: 110)
                    .padding(.leading, 70)
                    .blur(radius: 5)
                
                Circle()
                    .fill(Color.init(hex: "#7612B4"))
                    .frame(width: 110, height: 110)
                    .padding(.top, 50)
                    .blur(radius: 5)
            }
            .frame(width: 335, height: 175)
            .blur(radius: 5)
            
            Color
                .black
                .opacity(0.5)
                .frame(width: 335, height: 175)
                .cornerRadius(12)
        }
    }
}
