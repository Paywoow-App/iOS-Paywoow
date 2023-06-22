//
//  Users.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/22/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import MapKit
import CoreLocation
import Combine
import Lottie
import FirebaseFirestore

struct Users : View {
    @State private var selection = 1
    @EnvironmentObject var userStore : UserStore
    @StateObject var referanceStore = ReferanceStore()
    @Binding var showLists: Bool
    @State private var toMaker = false
    @State private var showDetails : Bool = false
    @State private var userTypeSelection = 0
    @State private var users : [UserContentModel] = []
    
    func dataHandler(firstData: [UserContentModel]) {
        for i in stride(from: 0, to: firstData.count, by: 10) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i/10)) {
                let end = min(i+10, firstData.count)
                let chunk = Array(firstData[i..<end])
                self.users.append(contentsOf: chunk)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 15){
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: Alignment.center)
                    
                    Text("Kullanıcılarımız")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding(.leading , 5)
                    
                    Spacer()

                    
                    if self.selection == 0 {
                        Button {
                            self.toMaker.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }
                    else {
                        // filter
                        
                        Menu("Filitre") {
                            Button {
                                self.userTypeSelection = 1
                            } label: {
                                Text("Engellenen Kullanıcılar")
                            }
                            
                            Button(action: {
                                self.userTypeSelection = 0
                            }, label: {
                                Text("Engellenmeyen Kullanıcılar")
                            })

                        }
                        .foregroundColor(.white)

                    }

                }
                .padding([.horizontal, .top])
                
                HStack{
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("Kullanıcılar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Kullanıcılar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }

                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Referans Kodu")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Referans Kodu")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                
                if self.showLists == true {
                    
                    if self.selection == 0 {
                        ScrollView(showsIndicators: false){
                            ForEach(referanceStore.references){ ref in
                                ReferanceContent(pfImage: ref.pfImage, fullname: ref.fullname, contactUserID: ref.contactUserID, refCode: ref.referanceCode, bigoId: ref.bigoId)
                                    .padding(.bottom)
                            } 
                        }
                    }
                    else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(users, id: \.id){ item in
                               
                                if self.userTypeSelection == 0 {
                                    if item.block == false {
                                            UsersContent(firstName: item.firstName, lastName: item.lastName, pfImage: item.pfImage, level: item.level, accountCreatedDate: item.accountCreatedDate, city: item.city, town: item.town, platform: item.platform, platformId: item.platformId, gender: item.gender, email: item.email, isOnline: item.isOnline, totalSoldDiamond: item.totalSoldDiamond, phoneNumber: item.phoneNumber, gift: item.gift, lat: "\(item.lat)", long: "\(item.long)", userid: item.userId, block: item.block)
                                    }
                                }
                                
                                else {
                                    if item.block == true {
                                        UsersContent(firstName: item.firstName, lastName: item.lastName, pfImage: item.pfImage, level: item.level, accountCreatedDate: item.accountCreatedDate, city: item.city, town: item.town, platform: item.platform, platformId: item.platformId, gender: item.gender, email: item.email, isOnline: item.isOnline, totalSoldDiamond: item.totalSoldDiamond, phoneNumber: item.phoneNumber, gift: item.gift, lat: "\(item.lat)", long: "\(item.long)", userid: item.userId, block: item.block)
                                    }
                                }
                                
                            }
                            .onAppear {
                                print("Gay \(userStore.users.count)")
                                print("Gayy \(self.users)")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    print("Gayy \(self.users.count)")
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    print("Gayy \(self.users.count)")
                                }
                                
                                dataHandler(firstData: userStore.users)
                            }

                        }
                    }
                }
                
                Spacer(minLength: 0)
                
            }

            .popover(isPresented: $toMaker, content: {
                ReferanceCodeMaker()
            })
        
    }
}

struct ReferanceContent: View{
    @State var pfImage : String = ""
    @State var fullname : String = ""
    @State var contactUserID : String = ""
    @State var refCode : String = ""
    @State var bigoId : String = ""
    @State private var showDelete = false
    @State private var showDetils = false
    @StateObject var referenceUsers = ReferanceStore()
    var body: some View{
        ZStack{
            VStack{
                if self.showDelete == false {
                    HStack{
                        WebImage(url: URL(string: pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 90, height: 90)
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text(fullname)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Text("ID : \(bigoId)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.light)
                        }
                        
                        
                        Spacer()
                        
                        
                        Menu("Detay") {
                            
                            Button {
                                self.showDetils.toggle()
                                self.referenceUsers.getUserList(referenceCode: self.refCode)
                            } label: {
                                Label("Detaylı İncele", systemImage: "square.and.arrow.down")
                                    
                            }
                            
                            Button {
                                self.showDelete.toggle()
                            } label: {
                                Label("Referans Kodunu Sil", systemImage: "xmark.circle")
                                    
                            }
                            
                            
                        }
                        .foregroundColor(.white)

                    }.frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
                        .padding(.vertical, 5)
                }
                else {
                    HStack(spacing: 0){
                        Button {
                            self.showDelete.toggle()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .fill(Color.white)
                                
                                Text("İptal")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                            }
                        }
                        
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Reference").document(self.refCode).delete()
                            self.showDelete.toggle()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .fill(Color.red)
                                
                                Text("Sil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }

                        
                        
                    }.frame(height: 100)
                        .padding(.vertical, 5)
                }
                
                
                if self.showDetils == true {
                    ZStack{
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.black.opacity(0.3))
                        
                        VStack{
                            
                            Text("İstatistikler")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .padding(.top, 5)
                            
                            Text(self.refCode)
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(.vertical, 5)
                            
                            HStack{
                                VStack(alignment: .center){
                                    Text("Gelen\nKullanıcı")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Text("\(self.referenceUsers.totalUser)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.225)
                                
                                Group{
                                    Spacer(minLength: 0)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                
                                VStack(alignment: .center){
                                    Text("Yükleme\nMiktarı")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Text("\(self.referenceUsers.totalUserSoldPrice)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.225)
                                
                                Group{
                                    Spacer(minLength: 0)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    Spacer(minLength: 0)
                                    
                                }
                                
                                VStack(alignment: .center){
                                    Text("Destekçi\nÖdül")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Text("\(self.referenceUsers.totalUserGivenGift)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.225)
                                
                                Group{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                VStack(alignment: .center){
                                    Text("Yayıncı\nÖdül")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Text("\(self.referenceUsers.totalStreamerGivenGift)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.225)

                            }
                            .frame(height: 80)
                            .padding(.top, 5)
                            
                            Divider().background(Color.white)
                                .padding(.horizontal, 10)
                            
                            ScrollView(showsIndicators: false){
                                
                                ForEach(self.referenceUsers.referenceUsers) { item in
                                    
                                    HStack{
                                        
                                        
                                        VStack(alignment: .center){
                                            
                                            WebImage(url: URL(string: item.profileImage))
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                                .padding(.leading, 5)
                                            
                                            
                                            Text(item.userFullname)
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                            
                                            Text(item.userBigoId)
                                                .foregroundColor(.white)
                                                .font(.system(size: 10))
                                            
                                        }
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(item.userSoldPrice)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .frame(width: UIScreen.main.bounds.width * 0.220)
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(item.userGivenGift)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .frame(width: UIScreen.main.bounds.width * 0.220)
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(item.streamerGivenGift)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .frame(width: UIScreen.main.bounds.width * 0.220)
                                        
                                        Spacer(minLength: 0)
                                        
                                        
                                    }
                                    .frame(height: 100)
                                    .padding(.horizontal, 10)
                                    
                                    Divider().background(Color.white)
                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                                    
                                }
                                
                            }
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.7)
                }
                
            }
        }
    }
}

struct UsersContent: View {

    // MARK: Data
    @State var firstName : String
    @State var lastName : String
    @State var pfImage : String
    @State var level : Int
    @State var accountCreatedDate : Int
    @State var city : String
    @State var town : String
    @State var platform : String
    @State var platformId : String
    @State var gender : String
    @State var email : String
    @State var isOnline : Bool
    @State var totalSoldDiamond : Int
    @State var phoneNumber : String
    @State var gift : Int
    @State var lat : String
    @State var long : String
    @State var userid : String
    @State var block : Bool
    
    // MARK: External
    @StateObject var userStore = UserStore()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.979530 , longitude: 28.979530), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @StateObject var locationManager = LocationManager()
    @State private var blockDetails = false
    @State private var showDetails : Bool = false
    @State private var dateTime : String = ""
    @State private var showManagerSelector : Bool = false
    @State private var selection = 0
    @State private var barSize : CGFloat = CGFloat(60)

    var body: some View{
        VStack(spacing: 12){
            TabView(selection: $selection){
                VStack(spacing: 12){
                    
                        
                            HStack{
                                WebImage(url: URL(string: pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60)
                                
                                VStack(alignment: .leading, spacing: 5){
                                    Text("\(firstName) \(lastName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                    
                                    Text("ID : \(platformId)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                Spacer(minLength: 0)
                                
                                if self.email.contains("privaterelay.appleid.com") || self.email.contains("icloud.com"){
                                    ZStack{
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 30, height: 30)
                                        
                                        Image(systemName: "applelogo")
                                            .resizable()
                                            .foregroundColor(.black)
                                            .scaledToFill()
                                            .frame(width: 15, height: 15)
                                    }
                                }
                                else if email.contains("gmail.com") {
                                    ZStack{
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 30, height: 30)
                                        
                                        Image("google")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .scaledToFill()
                                            .frame(width: 15, height: 15)
                                    }
                                }
                                else if email.contains("paywoow.com") {
                                    ZStack{
                                        
                                        Text("Bot")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .padding(.all, 5)
                                            .background(Color.init(hex: "#009D97"))
                                            .cornerRadius(8)
                                    }
                                }

                            }
                            
                            if self.showDetails {
                                HStack{
                                    Text("Email")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(email)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("Telefon")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(phoneNumber)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                
                                HStack{
                                    Text("Hesap Tarihi")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text(dateTime)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("Seviye")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(level)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("Şehir")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(city)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("İlçe")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(town)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                
                                
                                HStack{
                                    Text("Platform")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(platform)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                
                                HStack{
                                    Text("Platform ID")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(platformId)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("Toplam Satılan Elmas")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(totalSoldDiamond)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("Ban Durumu")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    if block == false {
                                        Text("Hayır")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    else {
                                        Text("Evet")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                }
                                
                                
                            }
                        
                    
                }
                .tag(0)
                
                VStack{
                    ZStack{
                        Map(coordinateRegion: $region)

                            .onTapGesture {
                                openMapForPlace(lat: lat as NSString, long: long as NSString)
                            }
                            .cornerRadius(8)
                            .allowsHitTesting(false)


                        Image(systemName: "mappin")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }

                }.tag(1)
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: barSize)
        }
        .padding(.all)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onChange(of: selection, perform: { val in
            if val == 0 {
                self.barSize = CGFloat(60)
                self.showDetails = false
            }
            else {
                self.barSize = CGFloat(200)
            }
        })
        
        .onChange(of: showDetails, perform: { val in
            if val {
                self.barSize = CGFloat(370)
            }
            else {
                self.barSize = CGFloat(60)
            }
        })
        .contextMenu{
            if self.block == true {
                Button {
                    let ref =  Firestore.firestore()
                    ref.collection("Users").document(userid).setData(["block" : false], merge: true)
                } label: {
                    Label("Engeli kaldır", systemImage: "hand.raised")
                }
            }
            else {
                Button {
                    self.blockDetails = true
                } label: {
                    Label("Kullanıcıyı Engelle", systemImage: "xmark.circle")
                }
                
                Button {
                    self.showManagerSelector.toggle()
                } label: {
                    Label("Yönetici Yap", systemImage: "person.2.badge.gearshape.fill")
                }
            }
            
        }
        .popover(isPresented: $blockDetails) {
            BlockSender(userId: $userid)
        }
        .onTapGesture{
            self.showDetails.toggle()
        }
        .onAppear{
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(long)!), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            let date = Date(timeIntervalSince1970: TimeInterval(accountCreatedDate))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:mm"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.dateTime = formatter.string(from: date)
        }
        .actionSheet(isPresented: $showManagerSelector) {
            ActionSheet(title: Text("Yönetici Seviyesi Seç"), message: Text("Aşağıdan bir seçeneği seç"), buttons: [
                ActionSheet.Button.default(Text("Demo Yöneticisi"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : platform,
                        "managerType" : "Demo Yöneticisi",
                        "isSupporter" : 3
                    ], merge: true)
                }),
                ActionSheet.Button.default(Text("Ajans Yöneticisi"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : platform,
                        "managerType" : "Ajans Yöneticisi",
                        "isSupporter" : 3
                    ], merge: true)
                }),
                ActionSheet.Button.default(Text("Etkinlik Yöneticisi"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : platform,
                        "managerType" : "Etkinlik Yöneticisi",
                        "isSupporter" : 3
                    ], merge: true)
                }),
                ActionSheet.Button.default(Text("Ban Yöneticisi"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : platform,
                        "managerType" : "Ban Yöneticisi",
                        "isSupporter" : 3
                    ], merge: true)
                }),
                ActionSheet.Button.default(Text("Aile Yöneticisi"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : platform,
                        "managerType" : "Aile Yöneticisi",
                        "isSupporter" : 3
                    ], merge: true)
                }),
                ActionSheet.Button.default(Text("Yöneticilikten Çıkar"), action: {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userid).setData([
                        "managerPlatform" : "",
                        "managerType" : "",
                        "isSupporter" : 1
                    ], merge: true)
                }),
                ActionSheet.Button.cancel(Text("İptal"))
                
            ])
        }
    }
    
    
    private func openMapForPlace(lat: NSString, long: NSString) {
        
        let lat1 : NSString = lat
        let lng1 : NSString = long
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)

        mapItem.openInMaps(launchOptions: options)
        
    }
}




