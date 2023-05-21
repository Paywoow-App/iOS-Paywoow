//
//  Admin-GiftRequest.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import Lottie

struct GiftRequest: View {
    @StateObject var giftStore = GiftRequestAdminStore()
    @StateObject var bayiiStore = DeallerStore()
    @State var dealler : String
    @State private var selection = 0
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Hediye İstekleri")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding([.horizontal, .top])
                
                HStack{
                    Text("Beklemede")
                        .foregroundColor(selection == 0 ? Color.white : Color.gray)
                        .font(.system(size: 20))
                        .onTapGesture {
                            self.selection = 0
                        }
                    
                    Text("Onaylandı")
                        .foregroundColor(selection == 1 ? Color.white : Color.gray)
                        .font(.system(size: 20))
                        .onTapGesture {
                            self.selection = 1
                        }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false){
                    if self.selection == 0 {
                        ForEach(giftStore.store){ item in
                            if item.result == "Beklemede" {
                                GiftRequestAdminContent(userId: item.userId, bigoId: item.bigoId, email: item.email, firstName: item.firstName, lastName: item.lastName, gift: item.gift, giftDate: item.giftDate, level: item.level, pfImage: item.pfImage, result: item.result, dealler: self.dealler)
                            }
                        }
                    }
                    
                    else {
                        ForEach(giftStore.store){ item in
                            if item.result == "Onaylandı" {
                                GiftRequestAdminContent(userId: item.userId, bigoId: item.bigoId, email: item.email, firstName: item.firstName, lastName: item.lastName, gift: item.gift, giftDate: item.giftDate, level: item.level, pfImage: item.pfImage, result: item.result, dealler: self.dealler)
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            self.giftStore.getData(dealler: self.dealler)
        }
    }
}
struct GiftRequestAdminContent: View {
    @StateObject var bayiiMainStore = DeallerStore()
    
    @State var userId = ""
    @State var bigoId = ""
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var gift = 0
    @State var giftDate = ""
    @State var level = 0
    @State var pfImage = ""
    @State var result = ""
    @State var dealler : String
    var body: some View {
        ZStack{
          RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
            
            HStack{
                ZStack{
                    WebImage(url: URL(string: self.pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80, alignment: Alignment.center)
                    
                    levelContentAdmin(level: self.level)
                }
                
                VStack(alignment: .leading){
                    Text("\(self.firstName) \(lastName)")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        
                    Spacer()
                    
                    Text(bigoId)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    
                    Spacer()
                    
                    Text(giftDate)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }.frame(height: 60)
                
                Spacer()
                
                VStack(alignment: .trailing){
                    HStack{
                        Image(systemName: "gift")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20, alignment: Alignment.center)
                        
                        Text("\(self.gift)")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                    }
                    Spacer()
                    
                    ZStack{
                        if self.result == "Beklemede" {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                Text("Beklemede")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.light)
                            }
                            .frame(width: 100, height: 30, alignment: Alignment.center)
                        }
                        
                        if self.result == "Onaylandı" {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.green)
                                
                                Text("Onaylandı")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.light)
                            }
                            .frame(width: 100, height: 30, alignment: Alignment.center)
                        }
                    }
                }
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 100, alignment: Alignment.center)
        .padding(.vertical, 10)
        .contextMenu{
            Button {
//                
//                let date = Date()
//                let formatter = DateFormatter()
//                formatter.dateStyle = .short
//                formatter.timeStyle = .short
//                let timeDate = formatter.string(from: date)
//                
//                let result = "Onaylandı"
//                let ref = Firestore.firestore()
//                ref.collection("GiftRequest").document(self.userId).setData(["result" : result], merge: true)
//                
//                ref.collection("Bayii").document(dealler).setData(["balance" : self.bayiiMainStore.balance - self.gift, "giftTotal" : self.bayiiMainStore.giftTotal - self.gift], merge: true)
//                
//                let data = ["bayiiId" : self.bayiiMainStore.bayiiId, "bayiiImage" : self.bayiiMainStore.bayiiImage, "bayiiName": self.bayiiMainStore.bayiiName, "date" : timeDate, "message" : "Çekim Talebiniz Onaylandı ve Hesabına Yüklendi"]
//                
//                ref.collection("Users").document(self.userId).collection("Notifications").addDocument(data: data)
//                
//                ref.collection("Users").document(self.userId).setData(["gift" : 0], merge: true)

            } label: {
                Label("Kabul Et", systemImage: "checkmark")
            }

        }
    }
}


struct levelContentAdmin: View{
    @State var level = 0
    var body: some View{
        ZStack{
            if self.level <= 11 && self.level >= 1 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("11 - 1")
                    }
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("22 - 12")
                    }
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("33 - 23")
                    }
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("44 - 34")
                    }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("55 - 45")
                    }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 188 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("66 - 56")
                    }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("76 - 67")
                    }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("88 - 78")
                    }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("100 - 89")
                    }
            }

          
            
            if self.level <= 11 && self.level >= 1 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                HStack(spacing: 0){
                    
                    Image(systemName: "rhombus.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                HStack(spacing: 0){
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                HStack(spacing: 0){
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                HStack(spacing: 0){
                    
                    Image(systemName: "sun.min.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                HStack(spacing: 0){
                    
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                HStack(spacing: 0){
                    
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            
        }
        .frame(width: 30, height: 20, alignment: Alignment.center)
        .offset(x: -30, y: -30)
    }
}
