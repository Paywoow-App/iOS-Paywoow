//
//  OrdersSecctions.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/21/22.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import SDWebImageSwiftUI

struct OrdersSections: View {
    @State private var selection = 0
    @State var dealler : String = ""
    @AppStorage("selectedPlatform") var selectedPlatform : String = "BigoLive"
    @State private var toPlatformSelector : Bool = false
    @EnvironmentObject var orderStore: OrderStore
    
    var body: some View {
        VStack{
            
            HStack{
                
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: Alignment.center)
                
                Text("Siparişlerimiz")
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
                ForEach(orderStore.list, id: \.timeStamp) { item in
                    if item.result == 0 {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var proccesedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list, id: \.timeStamp) { item in
                    if item.result == 1 {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var acceptedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list, id: \.timeStamp) { item in
                    if item.result == 2 {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
    
    var declinedOrders : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(orderStore.list, id: \.timeStamp) { item in
                    if item.result == 3 {
                        OrderContent(userID: item.userID, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, result: item.result, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, docID: item.docId)
                    }
                }
            }
        }
    }
}


struct OrderContent: View {
    @State var userID : String = ""
    @State var platformID : String = ""
    @State var platform : String = ""
    @State var price : Int = 0
    @State var timeStamp : Int = 0
    @State var transferType : String = ""
    @State var signatureURL : String = ""
    @State var hexCodeTop : String = ""
    @State var hexCodeBottom : String = ""
    @State var refCode : String = ""
    @State var result : Int = 0
    @State var product : Int = 0
    @State var streamerGivenGift : Int = 0
    @State var month : String = ""
    @State var year : String = ""
    @State var deallerID : String = ""
    @State var docID : String
    
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var totalSoldDiamond : Int = 0
    @State private var gift : Int = 0
    @State private var timeDate : String = ""
    @State private var ref = Firestore.firestore()
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    var body: some View{
        VStack(alignment: .leading, spacing: 5){
            HStack{
                
                WebImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60, alignment: .center)
                
                VStack(alignment: .leading, spacing: 5){
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text(platformID)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 5){
                    HStack{
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: Alignment.center)
                        
                        Text("\(product)")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                        
                    }
                    
                    Text("\(price)₺")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
            }
            
            HStack{
                Text(timeDate)
                    .foregroundColor(.black)
                    .font(.system(size: 13))
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 7){
                    
                    
                    ZStack{
                        if self.result == 0 {
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black)
                            
                            Text("Beklemede")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        else if self.result == 1 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
                            
                            Text("İşleme Alındı")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 2 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
                            
                            Text("Yükleme Başarılı")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                        else if self.result == 3 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                            
                            Text("Reddedildi")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
                }
            }
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear{
            let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            formatter.dateFormat = "dd MMMM yyyy"
            self.timeDate = formatter.string(from: date)
            
            let ref = Firestore.firestore()
            ref.collection("Users").document(userID).addSnapshotListener { doc, err in
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let totalSoldDiamond = doc?.get("totalSoldDiamond") as? Int {
                                    if let gift = doc?.get("gift") as? Int {
                                        self.pfImage = pfImage
                                        self.firstName = firstName
                                        self.lastName = lastName
                                        self.token = token
                                        self.totalSoldDiamond = totalSoldDiamond
                                        self.gift = gift
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .contextMenu{
            if self.result == 0 {
                Button {
                  progresResult()
                } label: {
                    Text("İşleme Al")
                }

            }
            else if self.result == 1 {
                Button {
                    succesResult()
                } label: {
                    Text("Yükleme Başarılı")
                    
                }
                
                Button {
                    rejectResult()
                } label: {
                    Text("Reddet")
                    
                }
                
            }
        }
    }

    
    func succesResult(){
        ref.collection("Users").document(userID).setData([
            "totalSoldDiamond" : totalSoldDiamond + product,
            "gift" : gift + (price / 100)
        ], merge: true)
        
        sendPushNotify(title: "Yüklemeniz Tamamlandı! 🥳", body: "Siparişini \(platform) uygulamasındaki hesabına yüklendi!", userToken: token, sound: "pay.mp3")
        
        ref.collection("Orders").document(docID).setData(["result" : 2], merge: true)
        
        print("TODO: Sipariş onayından sonra gerekli bayiden ürünü azalt")
        
    }
    
    func rejectResult(){
        sendPushNotify(title: "Çok Üzgünüz! 😔", body: "Yükleme işleminiz reddedildi! Daha sonra tekrar deneyiniz!", userToken: token, sound: "pay.mp3")
        self.alertTitle = "Müşteri Reddedildi!"
        self.alertBody = ""
        self.showAlert.toggle()
        
        ref.collection("Orders").document(docID).setData(["result" : 3], merge: true)

    }
    
    func progresResult() {
        sendPushNotify(title: "İşleme Alındı! 🙂", body: "Çok yakında hesabınıza yüklenecektir! Beklemede Kalın!", userToken: token, sound: "pay.mp3")
        ref.collection("Orders").document(docID).setData(["result" : 1], merge: true)
        UIPasteboard.general.string = platformID
        self.alertTitle = "Platform ID kopyalandı!"
        self.alertBody = "Artık \(platform) uygulamasınin bayi profiline girerek müşteriye yükleme yapabilirsiniz"
        self.showAlert.toggle()
    }
}
