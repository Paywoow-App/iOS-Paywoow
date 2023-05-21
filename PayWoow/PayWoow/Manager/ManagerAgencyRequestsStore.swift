//
//  ManagerAgencyRequests.swift
//  PayWoow
//
//  Created by 2017 on 3/18/23.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct ManagerAgencyRequestModel : Identifiable{
    var id = UUID()
    var agencyName : String
    var firstName : String
    var lastName : String
    var isComplatedTransactions : Bool
    var isVerifiedAgency : Bool
    var level : Int
    var nickname : String
    var pfImage : String
    var phoneNumber : String
    var platformID : String
    var platformName : String
    var streamers : [String]
    var timeDate : String
    var token : String
    var totalStreamers : Int
    var totalWork : Int
    var docID : String
}

class ManagerAgencyRequestStore : ObservableObject {
    let ref = Firestore.firestore()
    @Published var requests : [ManagerAgencyRequestModel] = []
    
    init(){
        ref.collection("AgencyRequests").addSnapshotListener { snap, err in
            if err == nil {
                self.requests.removeAll()
                for doc in snap!.documents {
                    if let agencyName = doc.get("agencyName") as? String {
                        if let firstName = doc.get("firstName") as? String {
                            if let lastName = doc.get("lastName") as? String {
                                if let isComplatedTransactions = doc.get("isComplatedTransactions") as? Bool {
                                    if let isVerifiedAgency = doc.get("isVerifiedAgency") as? Bool {
                                        if let level = doc.get("level") as? Int {
                                            if let nickname = doc.get("nickname") as? String {
                                                if let pfImage = doc.get("pfImage") as? String {
                                                    if let phoneNumber = doc.get("phoneNumber") as? String {
                                                        if let platformID = doc.get("platformId") as? String {
                                                            if let streamer = doc.get("streamers") as? [String] {
                                                                if let timeDate = doc.get("timeDate") as? String {
                                                                    if let token = doc.get("token") as? String {
                                                                        if let totalStreamers = doc.get("totalStreamer") as? Int {
                                                                            if let totalWork = doc.get("totalWork") as? Int {
                                                                                if let platformName = doc.get("platformName") as? String {
                                                                                    let data = ManagerAgencyRequestModel(agencyName: agencyName, firstName: firstName, lastName: lastName, isComplatedTransactions: isComplatedTransactions, isVerifiedAgency: isVerifiedAgency, level: level, nickname: nickname, pfImage: pfImage, phoneNumber: phoneNumber, platformID: platformID, platformName: platformName, streamers: streamer, timeDate: timeDate, token: token, totalStreamers: totalStreamers, totalWork: totalWork, docID: doc.documentID)
                                                                                        self.requests.append(data)
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
}

struct ManagerAgencyRequest: View {
    @StateObject var agencyRequests = ManagerAgencyRequestStore()
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 15){
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }

                    
                    Text("Ajans Bildirimleri")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.all)
                
                ScrollView(showsIndicators: false){
                    ForEach(agencyRequests.requests){ item in
                        ManagerAgencyRequestContent(agencyName: item.agencyName, firstName: item.firstName, lastName: item.lastName, isComplatedTransactions: item.isComplatedTransactions, isVerifiedAgency: item.isVerifiedAgency, level: item.level, nickname: item.nickname, pfImage: item.pfImage, phoneNumber: item.phoneNumber, platformID: item.platformID, platformName: item.platformName, streamers: item.streamers, timeDate: item.timeDate, token: item.token, totalStreamers: item.totalStreamers, totalWork: item.totalWork, docID: item.docID, showAlert: $showAlert, alertTitle: $alertTitle, alertBody: $alertBody)
                    }
                }
            }
            
            if self.agencyRequests.requests.isEmpty == true {
                VStack(spacing: 20){
                    
                    Spacer(minLength: 0)
                    
                    Image("noAgency")
                        .resizable()
                        .scaledToFit()
                        .padding(.all)
                    
                    Text("Burası biraz ıssız!")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding(.all)
                    
                    Text("Ajans olduğunu bildiren kimse yok!")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 18))
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Spacer(minLength: 0)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
}


struct ManagerAgencyRequestContent : View{
    @State var agencyName : String
    @State var firstName : String
    @State var lastName : String
    @State var isComplatedTransactions : Bool
    @State var isVerifiedAgency : Bool
    @State var level : Int
    @State var nickname : String
    @State var pfImage : String
    @State var phoneNumber : String
    @State var platformID : String
    @State var platformName : String
    @State var streamers : [String]
    @State var timeDate : String
    @State var token : String
    @State var totalStreamers : Int
    @State var totalWork : Int
    @State var docID : String //same userID
    @Binding var showAlert : Bool
    @Binding var alertTitle : String
    @Binding var alertBody : String
    
    @State private var showDetails : Bool = false
    @State private var showStreamers : Bool = false
    @State private var selection : Int = 0
    @State private var blur : Bool = false
    var body: some View {
        VStack(spacing: 15){
            HStack{
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 7) {
                    
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                }
                
                Spacer(minLength: 0)
                
                Button {
                    showDetails.toggle()
                } label: {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
            }
            .onTapGesture {
                self.showDetails.toggle()
            }
            
            
            if showDetails {
                VStack(spacing: 10){
                    HStack{
                        Text("Platform ID :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(platformID)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Kullanıcı ID :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(nickname)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Telefon :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(phoneNumber)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .onTapGesture {
                                self.callNumber(phoneNumber: phoneNumber)
                            }
                    }
                    
                    HStack{
                        Text("Seviye :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(level).Lv")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Faailiyet Yılı :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(totalWork) Yıl")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Halihazırda Yayıncı Sayısı :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(totalStreamers)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Kabul Eden Yayıncılar :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(streamers.count) yayıncı")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    if self.blur == false {
                        HStack{
                            Button {
                                deleteRequest()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white)
                                    
                                    Text("Sil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                            
                            Button {
                                self.showStreamers.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white)
                                    
                                    Text("Yayıncılar")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                            
                            
                            Button {
                                complateRequest()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.white)
                                    
                                    Text("Onayla")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                }
                            }
                            
                        }
                        .frame(height: 40)
                    }
                }
            }
            
            if showStreamers {
                
                HStack{
                    Text("Yayıncılar")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(streamers.count) yayıncı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                ForEach(streamers, id: \.self) { item in
                    ManagerAgencyRequestStreamerContent(userID: item)
                }
            }
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .blur(radius: blur ? 11 : 0)
        .overlay{
            if self.blur {
                VStack(spacing: 15){
                    Text("Ajans Kuruluyor")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    ProgressView()
                        .colorScheme(.dark)
                        .scaleEffect(2)
                }
                .onAppear{
                    self.showStreamers = false
                }
            }
        }
        .padding(.horizontal)
    }
    
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func deleteRequest(){
        let ref = Firestore.firestore()
        ref.collection("AgencyRequests").document(docID).delete()
        print("debuggg \(docID)")
        self.alertTitle = "Ajans Reddedildi"
        self.alertBody = "Bu ajans kurulumu reddedildi. Ajans isteklerinden silindi. "
        self.showAlert.toggle()
        
        sendPushNotify(title: "Maalesef!", body: "Ajans kurulumunuzu maalesef onaylayamadık. Lütfen daha sonra deneyin. Daha fazla bilgi için support@paywoow.com adresinden bize ulaşın. İlginizden dolayı teşekkür ediyoruz.", userToken: token, sound: "pay.mp3")
    }
    
    func complateRequest(){
        self.blur = true
        let ref = Firestore.firestore()
        let agencyID : String = UUID().uuidString
        let timeStamp = Date().timeIntervalSince1970
        let data = [
            "agencyName" : agencyName,
            "coverImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Agencies%2FdefualtAgencyCover.png?alt=media&token=2297b340-1503-465a-8d14-a8bb4a01e2ee",
            "owner" : docID,
            "platform" : platformName,
            "streamers" : streamers
        ] as [String : Any]
        ref.collection("Agencies").document(agencyID).setData(data, merge: true)
        
        let messageData = [
            "images" : [],
            "isRead" : ["\(docID)"],
            "message" : "Ajansımız kurulmuştur. Kurulması için oy veren her yayıncı arkadaşımıza, teşekkür ediyoruz.",
            "selection" : "Yayıncı",
            "sender" : docID,
            "timeStamp" : Int(timeStamp)
        ] as [String : Any]
        
        ref.collection("Agencies").document(agencyID).collection("Chat").document("\(Int(timeStamp))").setData(messageData, merge: true)
        
        let managerMessageData = [
            "images" : [],
            "isRead" : ["\(docID)"],
            "message" : "Ajansımız kurulmuştur. İlginize sunuyorum. Teşekkürler. Saygılarımla \(firstName) \(lastName)",
            "selection" : "Ajans Yöneticisi",
            "sender" : docID,
            "timeStamp" : Int(timeStamp)
        ] as [String : Any]
        
        ref.collection("Agencies").document(agencyID).collection("Chat").document("0").setData(managerMessageData, merge: true)
        
        ref.collection("Users").document(docID).setData([
            "myAgencyId" : agencyID,
            "isSupporter" : 2,
            "agencyApplicationUserId" : ""
        ], merge: true)
        
        for doc in streamers {
            ref.collection("Users").document(doc).setData([
                "isSupporter" : 0,
                "streamerAgencyID" : agencyID
            ], merge: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            ref.collection("AgencyRequest").document(docID).delete()
            self.alertTitle = "Ajans Kurulumu Tamamlandı"
            self.alertBody = "Ajans kuruldu, bütün yayıncılar bu ajans grubuna eklendi. Tebrikler"
            self.showAlert.toggle()
        }
        
        sendPushNotify(title: "Tebrikler!", body: "Ajansınız kurulmuştur. Artık hem yönetim grupları ile hemde kendi yayıncıların ile tek bir yerde konuşma imkanın olacak. Emeklerinden dolayı teşekkür ederiz!", userToken: token, sound: "pay.mp3")
    }
}

struct ManagerAgencyRequestStreamerContent: View{
    @State var userID : String
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var level : Int = 0
    @State private var platformName : String = ""
    @State private var platformID : String = ""
    @State private var token : String = ""
    @State private var email : String = ""
    @State private var nickname : String = ""
    @State private var phoneNumber : String = ""
    
    @State private var showDetails : Bool = false
    var body : some View {
        VStack{
            HStack{
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(firstName) \(lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text("\(nickname)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showDetails.toggle()
                } label: {
                    Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                
            }
            .onTapGesture {
                self.showDetails.toggle()
            }
            
            if showDetails {
                VStack(alignment: .leading, spacing: 12) {
                    HStack{
                        Text("Email :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(email)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Telefon Numarası :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(phoneNumber)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Platform :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(platformName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Platform ID :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(platformID)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Seviye :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(level).Lv")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
            }
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Users").document(userID).addSnapshotListener { doc, err in
                if err == nil {
                    if let firstName = doc?.get("firstName") as? String {
                        if let lastName = doc?.get("lastName") as? String {
                            if let pfImage =  doc?.get("pfImage") as? String {
                                if let platformName = doc?.get("selectedPlatform") as? String {
                                    if let platformID = doc?.get("platformID") as? String {
                                        if let level = doc?.get("level") as? Int {
                                            if let token = doc?.get("token") as? String {
                                                if let email = doc?.get("email") as? String {
                                                    if let nickname = doc?.get("nickname") as? String {
                                                        if let phoneNumber = doc?.get("phoneNumber") as? String {
                                                            self.firstName = firstName
                                                            self.lastName = lastName
                                                            self.pfImage = pfImage
                                                            self.platformName = platformName
                                                            self.platformID = platformID
                                                            self.level = level
                                                            self.token = token
                                                            self.email = email
                                                            self.nickname = nickname
                                                            self.phoneNumber = phoneNumber
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
                }
            }
        }
    }
}
