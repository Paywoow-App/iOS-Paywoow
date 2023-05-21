//
//  Rosettes.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import SDWebImageSwiftUI

struct GoldRosette: View {
    @State var pfImage: String = ""
    @State var fullname : String = ""
    @State var gift: Int = 0
    @State var userId : String = ""
    @State var platformId: String = ""
    @State var level: Int = 0
    @State var verify: Bool = false
    @State var nickname: String
    @State var vipType : String
    @State var casper : Bool
    var body: some View{
        VStack{
            ZStack{
                Image(uiImage: UIImage(named: "goldRosette")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                WebImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .offset(x: 0, y: 2)
                    .blur(radius: casper ? 3 : 0)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                
                LevelContentProfile(level: level)
                    .scaleEffect(0.65)
                    .offset(x: 0, y: 52)
            }

            if self.casper {
                Text("*******")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
            else {
                Text("\(nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
        }
    }
}


struct SilverRosette: View {
    @State var pfImage: String = ""
    @State var fullname : String = ""
    @State var gift: Int = 0
    @State var userId : String = ""
    @State var platformId: String = ""
    @State var level : Int = 0
    @State var verify: Bool = false
    @State var nickname: String
    @State var vipType : String
    @State var casper : Bool
    var body: some View{
        VStack{
            ZStack{
                Image(uiImage: UIImage(named: "silverRosette")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                WebImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .offset(x: 0, y: 2)
                    .blur(radius: casper ? 3 : 0)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                
                LevelContentProfile(level: level)
                    .scaleEffect(0.65)
                    .offset(x: 0, y: 52)
            }
            
           
            
            if self.casper {
                Text("******")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
            else {
                Text("\(nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
        }
    }
}


struct BronzeRosette: View {
    @State var pfImage: String = ""
    @State var fullname : String = ""
    @State var gift: Int = 0
    @State var userId : String = ""
    @State var platformId: String = ""
    @State var level : Int = 0
    @State var verify: Bool = false
    @State var nickname: String
    @State var vipType : String
    @State var casper : Bool
    var body: some View{
        VStack{
            ZStack{
                Image(uiImage: UIImage(named: "bronzeRosette")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                WebImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .offset(x: -1, y: 2.5)
                    .blur(radius: casper ? 3 : 0)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                
                LevelContentProfile(level: level)
                    .scaleEffect(0.65)
                    .offset(x: 0, y: 52)
            }
            
           
            
            if self.casper {
                Text("*******")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
            else {
                Text("\(nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }
        }
    }
}


struct Top47: View {
    @State var pfImage: String = ""
    @State var fullname : String = ""
    @State var gift: Int = 0
    @State var userId : String = ""
    @State var platformId: String = ""
    @State var totalSoldDiamond : Int = 0
    @State var level : Int = 0
    @State var verify: Bool = false
    @State var nickname: String
    @State var vipType : String
    @State var casper : Bool
    
    //esternal
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body: some View {
        HStack{
            ZStack{
                
                AnimatedImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 62, height: 62)
                    .offset(y: 1)
                    .blur(radius: casper ? 3 : 0)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                LevelContentProfile(level: level)
                    .scaleEffect(0.6)
                    .offset(x: 0, y: 32.5)
            }
            
            
            if self.casper == true {
                VStack(alignment: .leading){
                    Text("********")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Text("ID: ********")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
            else {
                VStack(alignment: .leading){
                    Text(nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Text("ID: \(platformId)")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }

            Spacer(minLength: 0)
            
            Image("dia")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            
            Text("\(totalSoldDiamond)")
                .foregroundColor(.white)
                .font(.system(size: 20))
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 90)
    }
}
