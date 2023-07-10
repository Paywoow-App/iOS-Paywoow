//
//  AgencyRequest.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/15/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore

struct AgencyRequest_Previews: PreviewProvider {
    static var previews: some View {
        AgencyRequest()
    }
}

struct AgencyRequest: View {
    
    // Tab view 2 section will come
    @State private var selection = 0
    @StateObject var agencyRequests = AgencyRequestStore()
    @StateObject var agancyCompleted = AgencyCompletedStore()
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    
    var agencyyRequest: some View {
        ScrollView(showsIndicators: false) {
            ForEach(agencyRequests.requests){ item in
                AgencyRequestContent(agencyName: item.agencyName, firstName: item.firstName, lastName: item.lastName, isComplatedTransactions: item.isComplatedTransactions, isVerifiedAgency: item.isVerifiedAgency, level: item.level, nickname: item.nickname, pfImage: item.pfImage, phoneNumber: item.phoneNumber, platformID: item.platformID, platformName: item.platformName, streamers: item.streamers, timeDate: item.timeDate, token: item.token, totalStreamers: item.totalStreamers, totalWork: item.totalWork, docID: item.docID, showAlert: $showAlert, alertTitle: $alertTitle, alertBody: $alertBody)
            }
        }
    }
    
    var agencyRequestAccepted: some View {
        ScrollView {
            ForEach(agancyCompleted.completed) { item in
                AgencyCompletedContent(agencyName: item.agencyName, firstName: item.firstName, lastName: item.lastName, isComplatedTransactions: item.isComplatedTransactions, isVerifiedAgency: item.isVerifiedAgency, level: item.level, nickname: item.nickname, pfImage: item.pfImage, phoneNumber: item.phoneNumber, platformID: item.platformID, platformName: item.platformName, streamers: item.streamers, timeDate: item.timeDate, token: item.token, totalStreamers: item.totalStreamers, totalWork: item.totalWork, docID: item.docID, showAlert: $showAlert, alertTitle: $alertTitle, alertBody: $alertBody)
            }
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: Alignment.center)
                    
                    Text("Ajans Bildirimleri")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.all)
                
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
                        Text("Onaylandı")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                    }
                    else {
                        Button {
                            self.selection = 1
                        } label: {
                            Text("Onaylandı")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        
                    }
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)

                TabView(selection: $selection){
                    
                    agencyyRequest
                        .tag(0)
                    
                    agencyRequestAccepted
                        .tag(1)
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            if self.agencyRequests.requests.isEmpty == true, selection == 0 {
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
                .padding(.top)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
    }
}


struct AgencyRequestContent : View {
    @State var agencyName: String
    @State var firstName: String
    @State var lastName: String
    @State var isComplatedTransactions: Bool
    @State var isVerifiedAgency: Bool
    @State var level: Int
    @State var nickname: String
    @State var pfImage: String
    @State var phoneNumber: String
    @State var platformID: String
    @State var platformName: String
    @State var streamers: [String]
    @State var timeDate: String
    @State var token: String
    @State var totalStreamers : Int
    @State var totalWork : Int
    @State var docID : String //same userID
    @Binding var showAlert : Bool
    @Binding var alertTitle : String
    @Binding var alertBody : String
    @Environment(\.dismiss) var dismiss
    
    //General
    @StateObject var bayiiInfoStore = DeallerStore()
    @State private var showDetails : Bool = false
    @State private var showStreamers : Bool = false
    @State private var selection : Int = 0
    @State private var blur : Bool = false
    @State private var isUserSureAbout: Bool = false
    
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
                    
                    Text("\(platformID)")
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
                        Text("Ad Soyad :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(firstName) \(lastName)")
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
                                // New notification
                                isUserSureAbout.toggle()
                                print(docID)
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white)
                                    Text("Kaldır")
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
                    AgencyRequestStreamerContent(model: AgencyRequestStreamerContentModel(userID: item))
                }
            }
        }
        .onAppear {
            print("Ajans IDsi BUğ \(docID)")
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
            ZStack {
                let bounds = UIScreen.main.bounds
                Color.black.opacity(0.5).ignoresSafeArea()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.init(hex: "#313635")).opacity(0.8)
                    .frame(width: bounds.width * 0.8,height: bounds.height * 0.18)
                    .scaledToFit()
                    .padding(.horizontal)
                    
                //Request here
                VStack(spacing: 20) {
                    Text("Ajansı kaldırmayı onaylıyor musunuz ?")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 20) {
                        Button {
                            deleteRequest()
                        } label: {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Text("Evet")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        Button {
                            isUserSureAbout.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.white)
                                
                                Text("Hayır")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                }
                .padding(.horizontal)
            }
            .opacity(isUserSureAbout ? 1 : 0)
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
    
    func deleteRequest() {
        let ref = Firestore.firestore()
        //MARK: AgencyRequestContent deleteRequest(Delete who send request agency)
        ref.collection("Users").document(docID).updateData([
            "isSentAgencyApplication": false,
            "agencyApplicationUserId":"",
            "myAgencyId":""
        ])
        
        for streamer in streamers {
            //MARK: AgencyRequestContent deleteRequest(Delete AgencyApplicationQuestion from Streamers)
            ref.collection("Users").document(streamer).collection("AgencyApplicationQuestion").document(docID).delete()
            //MARK: AgencyRequestContent deleteRequest(Delete Set nil from Streamers)
            ref.collection("Users").document(docID).updateData([
                "isSentAgencyApplication": false,
                "agencyApplicationUserId":"",
                "myAgencyId":""
            ])
        }
     
        //MARK: AgencyRequestContent deleteRequest(Delete request from collection)
        ref.collection("AgencyRequests").document(docID).delete()
        
        ref.collection("Users").document(docID).collection("AgencyApplicationQuestion").getDocuments { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                doc.reference.delete()
            }
        }
        
        
        ref.collection("AgencyRequests").document(docID).collection("Streamers").getDocuments { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                ref.collection("Users").document(doc.description).setData(
                    ["streamerAgencyID" : "",
                      "agencyApplicationUserId": ""]
                )
                
                
            }
        }
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.blur = false
            ref.collection("AgencyRequests").document(docID).delete()
            self.alertTitle = "Ajans Kurulumu Tamamlandı"
            self.alertBody = "Ajans kuruldu, bütün yayıncılar bu ajans grubuna eklendi. Tebrikler"
            self.showAlert.toggle()
        }
        
        sendPushNotify(title: "Tebrikler!", body: "Ajansınız kurulmuştur. Artık hem yönetim grupları ile hemde kendi yayıncıların ile tek bir yerde konuşma imkanın olacak. Emeklerinden dolayı teşekkür ederiz!", userToken: token, sound: "pay.mp3")
    }
    

}

class AgencyRequestStreamerContentModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var pfImage: String = ""
    @Published var level: Int = 0
    @Published var platformName: String = ""
    @Published var platformID: String = ""
    @Published var token: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedPlatform: String = ""
    
    var userID: String {
        didSet {
            fetchUser()
        }
    }

    init(userID: String) {
        self.userID = userID
        fetchUser()
    }

    
    private func fetchUser() {
         Firestore.firestore().collection("Users").document(self.userID).addSnapshotListener { snap, error in
             if let error = error {
                 print(error.localizedDescription)
             } else {
                 guard let snap = snap else { return }
                 self.firstName = (snap.get("firstName") as? String) ?? ""
                 self.lastName = (snap.get("lastName") as? String) ?? ""
                 self.pfImage = (snap.get("pfImage") as? String) ?? ""
                 self.level = (snap.get("level") as? Int) ?? 0
                 self.platformName = (snap.get("firstName") as? String) ?? ""
                 self.platformID = (snap.get("platformID") as? String ) ?? ""
                 self.token = (snap.get("token") as? String ) ?? ""
                 self.email = (snap.get("email") as? String ) ?? ""
                 self.nickname = (snap.get("nickname") as? String ) ?? ""
                 self.phoneNumber = (snap.get("phoneNumber") as? String ) ?? ""
                 self.selectedPlatform = (snap.get("selectedPlatform") as? String) ?? ""
             }
         }
     }
    
}

struct AgencyRequestStreamerContent: View{
    
    @ObservedObject var model: AgencyRequestStreamerContentModel
    
    @State private var showDetails : Bool = false
    
    var body : some View {
        VStack{
            HStack{
                WebImage(url: URL(string: model.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(model.nickname)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Text("\(model.platformID)")
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
                        
                        Text(model.email)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Telefon Numarası :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(model.phoneNumber)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Platform :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text(model.selectedPlatform)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Kullanıcı Adı :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(model.firstName) \(model.lastName)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Seviye :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(model.level).Lv")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
            }
        }
    }
}


struct AgencyCompletedContent : View {
    @State var agencyName: String
    @State var firstName: String
    @State var lastName: String
    @State var isComplatedTransactions: Bool
    @State var isVerifiedAgency: Bool
    @State var level: Int
    @State var nickname: String
    @State var pfImage: String
    @State var phoneNumber: String
    @State var platformID: String
    @State var platformName: String
    @State var streamers: [String]
    @State var timeDate: String
    @State var token: String
    @State var totalStreamers : Int
    @State var totalWork : Int
    @State var docID : String //same userID
    @Binding var showAlert : Bool
    @Binding var alertTitle : String
    @Binding var alertBody : String
    @Environment(\.dismiss) var dismiss
    
    //General
    @StateObject var bayiiInfoStore = DeallerStore()
    @State private var showDetails : Bool = false
    @State private var showStreamers : Bool = false
    @State private var selection : Int = 0
    @State private var blur : Bool = false
    @State private var isUserSureAbout: Bool = false
    
    
    func getDocs(agencyID: String) {
        print("Bu neğ \(agencyID)")
    }
    
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
                    
                    Text("\(platformID)")
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
                        Text("Ad Soyad :")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(firstName) \(lastName)")
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
                                // New notification
                                isUserSureAbout.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white)
                                    Text("Kaldır")
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
                    AgencyRequestStreamerContent(model: AgencyRequestStreamerContentModel(userID: item))
                    
                }
            }
        }
        .onAppear {
            print("Ajans IDsi BUğ \(docID)")
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
            ZStack {
                let bounds = UIScreen.main.bounds
                Color.black.opacity(0.5).ignoresSafeArea()
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.init(hex: "#313635")).opacity(0.8)
                    .frame(width: bounds.width * 0.8,height: bounds.height * 0.18)
                    .scaledToFit()
                    .padding(.horizontal)
                    
                VStack(spacing: 20) {
                    Text("Ajansı kaldırmayı onaylıyor musunuz ?")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 20) {
                        Button {
                            deleteRequest()
                        } label: {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white)
                                
                                Text("Evet")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        Button {
                            isUserSureAbout.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.white)
                                
                                Text("Hayır")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                }
                .padding(.horizontal)
            }
            .opacity(isUserSureAbout ? 1 : 0)
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
        let usersCollection = ref.collection("Users").document(docID)
        usersCollection.updateData([
            "isSentAgencyApplication": false,
            "agencyApplicationUserId":"",
            "myAgencyId":""
        ])
        
        ref.collection("AgencyRequests").document(docID).collection("Streamers").getDocuments { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                ref.collection("Users").document(doc.description).setData(
                    ["streamerAgencyID" : "",
                      "agencyApplicationUserId": ""]
                )
                
                doc.reference.delete()
            }
        }
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.blur = false
            ref.collection("AgencyRequests").document(docID).delete()
            self.alertTitle = "Ajans Kurulumu Tamamlandı"
            self.alertBody = "Ajans kuruldu, bütün yayıncılar bu ajans grubuna eklendi. Tebrikler"
            self.showAlert.toggle()
        }
        
        sendPushNotify(title: "Tebrikler!", body: "Ajansınız kurulmuştur. Artık hem yönetim grupları ile hemde kendi yayıncıların ile tek bir yerde konuşma imkanın olacak. Emeklerinden dolayı teşekkür ederiz!", userToken: token, sound: "pay.mp3")
    }
    

}
