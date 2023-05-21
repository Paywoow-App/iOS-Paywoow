//
//  Invests.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/24/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Invests: View {
    
    //MARK: Stores
    @StateObject var general = GeneralStore()
    @StateObject var invest = InvestorStore()
    @StateObject var userStore = UserInfoStore()
    
    //MARK: Utitiles
    @State private var cardColor = Color.init(red: 23 / 255, green: 23 / 255, blue: 23 / 255)
    
    //MARK: Input Values
    @State private var calculatedProfit : Int = 0
    @State private var currentSelectedApp : String = ""
    @State private var showAll : Bool = false
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    if self.showAll == false {
                        VStack(spacing: 15){
                            ZStack{
                                Image("investorCard")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(cardColor)
                                
                                
                                VStack{
                                    HStack(spacing: 12){
                                        AsyncImage(url: URL(string: userStore.pfImage)) { img in
                                            img
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 60, height: 60)
                                        } placeholder: {
                                            Image("defualtPf")
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 60, height: 60)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 10){
                                            Text(userStore.nickname)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .fontWeight(.medium)
                                            
                                            Text("ID: \(userStore.bigoId)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                        
                                        Spacer(minLength: 0)
                                        
                                        
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    HStack{
                                        
                                        Text("\(invest.totalProfit) \(invest.currentySymbol)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        Spacer(minLength: 0)
                                    }
                                    
                                }
                                .padding(.all)
                                
                                HStack{
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "wifi")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 18))
                                        .rotationEffect(.degrees(90))
                                }
                                .padding(.all)
                            }
                            .frame(height: 220)
                            .padding([.horizontal, .top])
                        }
                    }
                        
                        HStack{
                            Text("Yatırım Miktarı")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Text("\(invest.currentySymbol)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Text("\(invest.totalPrice)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12){
                                ForEach(invest.selectedPlatforms, id: \.self) { item in
                                    InvestorApps(appName: item, selectedApp: $currentSelectedApp)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack{
                            Text("Son İşlemler")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            if invest.saleList.count > 10 {
                                Button {
                                    self.showAll.toggle()
                                } label: {
                                    if self.showAll {
                                        Text("Gizle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    else {
                                        Image(systemName: "list.bullet")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                }
                            }

                        }
                        .padding(.horizontal)
                        
                        ForEach(invest.saleList) { item in
                            if currentSelectedApp == item.platform {
                                if item.index <= 3 && showAll == false {
                                    if currentSelectedApp == item.platform {
                                        InvestHistoryContent(dealler: item.dealler, dollar: item.dollar, platform: item.platform, price: item.price, timeStamp: item.timeStamp, uploadID: item.uploadID, userID: item.userID, profit: item.profitForInvest)
                                    }
                                }
                                else {
                                    if currentSelectedApp == item.platform {
                                        InvestHistoryContent(dealler: item.dealler, dollar: item.dollar, platform: item.platform, price: item.price, timeStamp: item.timeStamp, uploadID: item.uploadID, userID: item.userID, profit: item.profitForInvest)
                                    }
                                }
                            }
                        }
                }
            }
        }
        .onChange(of: self.invest.selectedPlatforms) { newValue in
            self.currentSelectedApp = newValue.first ?? "BigoLive"
        }
    }
}

struct InvestorApps: View {
    @State var appName : String
    @Binding var selectedApp : String
    @State private var appImage : String = ""
    var body : some View {
        AsyncImage(url: URL(string: appImage)) { image in
            if self.selectedApp == appName {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipped()
                    .cornerRadius(6)
            }
            else {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipped()
                    .cornerRadius(6)
                    .opacity(0.5)
            }
        } placeholder: {
            ProgressView()
                .colorScheme(.dark)
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Platforms").document(appName).addSnapshotListener { doc, err in
                if err == nil {
                    if let platformImage = doc?.get("platformImage") as? String {
                        self.appImage = platformImage
                    }
                }
            }
        }
        .onTapGesture {
            self.selectedApp = appName
        }
    }
}


struct InvestHistoryContent: View {
    @State var dealler : String
    @State var dollar : Double
    @State var platform : String
    @State var price : Int
    @State var timeStamp : Int
    @State var uploadID : String
    @State var userID : String
    @State var profit : Int
    
    //MARK: Details
    @State private var appImage : String = ""
    @State private var dateTime : String = ""
    var body : some View {
        HStack(spacing: 12){
            AsyncImage(url: URL(string: appImage)) { img in
                img
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipped()
                    .cornerRadius(6)
            } placeholder: {
                ProgressView()
                    .colorScheme(.dark)
                    .frame(width: 45, height: 45)
            }
            
            
            VStack(alignment: .leading, spacing: 7) {
                Text(platform)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Text(dateTime)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
            
            Spacer(minLength: 0)
            
            Text("₺ \(profit)")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .fontWeight(.medium)

        }
        .padding(.horizontal)
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Platforms").document(platform).addSnapshotListener { doc, err in
                if err == nil {
                    if let platformImage = doc?.get("platformImage") as? String {
                        self.appImage = platformImage
                    }
                }
            }
            
            
            let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            formatter.dateFormat = "dd.MM.yyyy - HH:mm"
            self.dateTime = formatter.string(from: date)
        }
    }
}
