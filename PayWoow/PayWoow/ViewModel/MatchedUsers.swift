//
//  MatchedUsers.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MatchedUser : View{
    @State var first_platformId : String
    @State var first_platformName : String
    @State var first_firstName : String
    @State var first_lastName : String
    @State var first_level : Int
    @State var first_nickname : String
    @State var first_pfImage : String
    @State var first_userID : String
    @State var first_vipType : String
    @State var first_token : String
    @State var second_platformId : String
    @State var second_platformName : String
    @State var second_firstName : String
    @State var second_lastName : String
    @State var second_level : Int
    @State var second_nickname : String
    @State var second_pfImage : String
    @State var second_userID : String
    @State var second_vipType : String
    @State var second_token : String
    @State var timeDate : String
    @State var country : String
    @State var diamond : Int
    @State private var showAnimations = false
    @State private var showPaddings : Bool = false
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body: some View {
        HStack{
            ZStack{
                
                AnimatedImage(url: URL(string: second_pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 62, height: 62)
                    .offset(y: 1)
                
                if self.second_vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.second_vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.second_vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                LevelContentProfile(level: second_level)
                    .scaleEffect(0.6)
                    .offset(x: 0, y: 32.5)
                
            }.padding(.leading)
            
            VStack(alignment: .leading){
                Text(second_nickname)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .bold()
                    .offset(x: -7)
                
                Spacer()
                
                Text("ID: \(self.second_platformId)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .fontWeight(.light)
                
                Spacer()
                
                HStack{
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("\(self.diamond)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        
                }.offset(x: -7)
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
            
            ZStack{
                
                AnimatedImage(url: URL(string: self.first_pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 62, height: 62)
                    .offset(y: 1)
                
                if self.first_vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.first_vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.first_vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                LevelContentProfile(level: first_level)
                    .scaleEffect(0.6)
                    .offset(x: 0, y: 32.5)
                
            }.padding(.trailing)
        }
        .padding(.top, showPaddings ? 20 : 10)
        .padding(.bottom, 10)
        .frame(height: 100, alignment: Alignment.center)
        .onAppear{
            self.showAnimations = true
//            if self.index == 1 {
//                self.showPaddings = true
//            }
        }
        .onDisappear{
            self.showAnimations = false
        }
    }
}
