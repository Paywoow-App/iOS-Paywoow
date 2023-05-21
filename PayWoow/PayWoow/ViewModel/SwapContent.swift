//
//  SwapContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct SwapContent: View {
    @State var userID : String
    @State var timeStamp : Int
    @State var product:  Int
    @State var productType : String
    @State var selectedPlatform : String
    @State var country : String
    @Binding var selectedUserID : String
    @Binding var selectedProduct : Int
    @Binding var selectedPlatformID : String
    @Binding var showSwapRequest : Bool
    
    
    @State private var nickname : String = ""
    @State private var platformID : String = ""
    @State private var level : Int = 0
    @State private var pfImage : String = ""
    @State private var vipType : String = ""
    @State private var token : String = ""

    //external
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

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Image("dia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    
                    Text("\(product)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)

                }
                
                HStack{
                    Text("ID: \(self.platformID)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)

                    if Auth.auth().currentUser!.uid == self.userID {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(colors: [
                                    Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255),
                                    Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)
                                ], startPoint: .leading, endPoint: .trailing))
                            
                            Text("Finding")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                        }
                        .frame(width: 110, height: 30, alignment: Alignment.center)
                    }
                    else {
                        Button {
                            self.selectedUserID = userID
                            self.selectedProduct = product
                            self.selectedPlatformID = platformID
                            self.showSwapRequest = true
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(LinearGradient(colors: [
                                        Color.init(red: 177 / 255, green: 59 / 255, blue: 201 / 255),
                                        Color.init(red: 232 / 255, green: 92 / 255, blue: 74 / 255)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                Text("Send Request")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                            }
                            .frame(width: 110, height: 30, alignment: Alignment.center)
                        }

                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
        .onAppear{
            getData()
        }
        .contextMenu{
            if self.userID == Auth.auth().currentUser!.uid {
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Swaps").document(Auth.auth().currentUser!.uid).delete()
                } label: {
                    Text("Beni listeden kaldır")
                        .foregroundColor(.white)
                }

            }
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let platformID = doc?.get("platformID") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let level = doc?.get("level") as? Int {
                                    if let vipType = doc?.get("vipType") as? String {
                                        self.nickname = nickname
                                        self.platformID = platformID
                                        self.pfImage = pfImage
                                        self.token = token
                                        self.level = level
                                        self.vipType = vipType
                                        print("hello mother fucker")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
