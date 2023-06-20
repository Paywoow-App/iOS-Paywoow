//
//  MyLastOrderContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyLastOrderContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var result = ""
    @State var fullname = ""
    @State var id = ""
    @State var timeDate = ""
    @State var diamond = 0
    @State var price = 0
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(userStore.nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    Text(id)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    
                    Text(timeDate)
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing){
                    HStack{
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: Alignment.center)
                        
                        Text("\(diamond)")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                    }
                    
                    Text("\(price)₺")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                    ZStack{
                        if self.result == "Beklemede" {
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                            
                            Text("Waiting Now")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        else if self.result == "İşleme Alındı" {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
                            
                            Text("Progress")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == "Yükleme Başarılı" {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
                            
                            Text("Complated")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == "Red Edildi" {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                            
                            Text("Reddedildi")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        
                    }
                    .frame(width: 100, height: 25, alignment: Alignment.center)
                }
            }
            .padding(.horizontal, 7)
            

        }
        .frame(height: 100, alignment: Alignment.center)
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}



