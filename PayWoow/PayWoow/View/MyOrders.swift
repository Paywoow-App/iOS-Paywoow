//
//  MyOrders.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/19/21.
//

import SwiftUI

struct MyOrders: View {
    @Environment(\.presentationMode) var present
    @StateObject var myOrders = MyOrdersStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var vipOrders = VIPOrderStore()
    @StateObject var platforms = AddedPlatformStore()
    @State var forTabView = false
    @State private var selection = 0
    @State private var selectedPlatorms : String = ""
    @State private var selectedPlatformDetect : String = ""
    var body: some View {
        ZStack{
            if self.forTabView == false {
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 15){
                if self.forTabView == false {
                    HStack(spacing: 15){
                        Button {
                            self.present.wrappedValue.dismiss()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            .frame(width: 45, height: 45)
                        }
                        
                        Text("Orders")
                            .foregroundColor(.white)
                            .font(.title2)
                        
                        Spacer(minLength: 0)

                    }
                    .padding([.horizontal, .top])
                }
                else {
                    HStack{
                        
                        Image("logoWhite")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45, alignment: Alignment.center)
                        
                        
                        Text("Orders")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.light)
                            .padding(.leading , 5)
                        
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                }
                
                HStack{
                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Online Payment")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Online Payment")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.light)
                        }
                    }
                    
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("VIP Card Payment")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("VIP Card Payment")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.light)
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                
                ZStack{
                    if self.selection == 0  {
                        ScrollView(showsIndicators: false){
                            ForEach(self.myOrders.orders){ item in
                                VStack{
                                    if item.platform == userStore.selectedPlatform {
                                        MyOrderContent(userId: item.userId, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, result: item.result)
                                    }
                                    else {
                                        VStack{
                                            
                                        }
                                        .onAppear{
                                            self.selectedPlatformDetect = item.platform
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                    else {
                        ScrollView(showsIndicators: false){
                            ForEach(self.myOrders.vipOrders){ item in
                                if item.transferType == "VIP Card" {
                                    MyOrderContent(userId: item.userId, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, result: item.result)
                                }
                                
                            }
                        }
                    }
                    
                    if self.selection == 0 {
                        VStack(spacing: 15){
                            Spacer()
                            
                            if self.myOrders.orders.isEmpty == true && self.selectedPlatformDetect != userStore.selectedPlatform{
                                
                                Image("emptyOrder")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                
                                Text("You have not any order")
                                    .foregroundColor(Color.white)
                                    .font(.title3)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                    }
                    else {
                        VStack{
                            Spacer()
                            
                            if self.myOrders.vipOrders.isEmpty == true {
                                
                                Image("emptyOrder")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                             
                                Text("You have not any order")
                                    .foregroundColor(Color.white)
                                    .font(.title3)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .onChange(of: userStore.selectedPlatform) { val in
            self.selectedPlatorms = val
        }
    }
}

