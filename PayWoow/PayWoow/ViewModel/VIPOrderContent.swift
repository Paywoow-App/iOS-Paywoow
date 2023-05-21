//
//  VIPOrderContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/30/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct VIPOrderContent: View {
    @State var cardNo : String
    @State var cardType : String
    @State var diamond: Int
    @State var fullname : String
    @State var level : Int
    @State var pfImage : String
    @State var timeDate : String
    @State var token : String
    @State var uploadID : String
    @State var userID : String
    @State var userName : String
    @State var result : String
    @State var dealler : String
    @State var docID : String
    @State private var ref = Firestore.firestore()
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
            
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            
                            WebImage(url: URL(string: self.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50, alignment: .center)
                            
                            VStack(alignment: .leading){
                                Text(fullname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                
                                Text("ID: \(self.uploadID)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                            
                            Spacer(minLength: 0)
                        }
                        
                        Text(timeDate)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        HStack{
                            Image("dia")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: Alignment.center)
                            
                            Text("\(diamond)")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            
                        }
                        .padding(.top, 10)
                        
                        ZStack{
                            if self.result == "Beklemede" {
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.black)
                                
                                Text("Waiting")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            else if self.result == "İşleme Alındı" {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
                                
                                Text("Progressing")
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
                                
                                Text("Declined")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            
                            else if self.result == "İşlem Onaylandı" {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.purple)
                                
                                Text("Complated")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
                        .padding(.bottom, 10)
                    }
                    .padding(.trailing)
                }
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width  * 0.9, alignment: Alignment.center)

    }
}
