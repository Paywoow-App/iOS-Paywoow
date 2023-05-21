//
//  VIPOrders.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 6/30/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct VIPOrders: View{
    @State private var selection = 0
    @State var searchBar : Bool = false
    @AppStorage("selectedPlatform") var selectedPlatform : String = "BigoLive"
    @State private var toPlatformSelector : Bool = false
    @StateObject var orderStore = OrderStore()
    
    var body: some View {
        VStack{
            
            HStack{
                
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: Alignment.center)
                
                Text("VIP Siparişler")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .padding(.leading , 5)
                
                Spacer()
                
                
                Button {
                    self.toPlatformSelector.toggle()
                } label: {
                    Text(selectedPlatform)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
            }
            .padding([.horizontal, .top])
            
            HStack{
                if self.selection == 0 {
                    Text("Beklemede")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                }
                else {
                    Button {
                        self.selection = 0
                    } label: {
                        Text("Beklemede")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                }
                
                Spacer()
                
                
                if self.selection == 1 {
                    Text("İşlemde")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                }
                else {
                    Button {
                        self.selection = 1
                    } label: {
                        Text("İşlemde")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                }
                
                Spacer()
                
                
                if self.selection == 2 {
                    Text("Başarılı")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                }
                else {
                    Button {
                        self.selection = 2
                    } label: {
                        Text("Başarılı")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                }
                
                Spacer()
                
                
                if self.selection == 3 {
                    Text("Red Edildi")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                }
                else {
                    Button {
                        self.selection = 3
                    } label: {
                        Text("Red Edildi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            TabView(selection: $selection){
                
                waitingOrders
                    .tag(0)
                
                proccesedOrders
                    .tag(1)
                
                acceptedOrders
                    .tag(2)
                
                declinedOrders
                    .tag(3)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
        }
        .fullScreenCover(isPresented: $toPlatformSelector) {
            PlatformSelector(selectedPlatform: $selectedPlatform)
        }
    }
    
    var waitingOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list) { item in
                    if item.result == 0 && item.transferType == "VIP Card"{
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var proccesedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list) { item in
                    if item.result == 1 && item.transferType == "VIP Card" {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var acceptedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list) { item in
                    if item.result == 2 && item.transferType == "VIP Card" {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var declinedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list) { item in
                    if item.result == 3 && item.transferType == "VIP Card" {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
}
