//
//  VIPPolicy.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/21/22.
//

import SwiftUI

struct VIPPolicy: View {
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                Text("VIP Subscription Agreement")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .fontWeight(.medium)
                    .padding()
                
                PolicyPreview(url: URL(string: "https://www.paywoow.com/wp-content/uploads/2022/07/vip-Satis-Sozlesmesi.docx")!)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .clipped()
                    .cornerRadius(12)
                    .padding(.bottom, 20)
            }
        }
    }
}
