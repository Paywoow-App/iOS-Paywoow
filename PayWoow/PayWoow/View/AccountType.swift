//
//  IsSupporter.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AccountType: View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var generalStore = GeneralStore()
    @StateObject var researcher = AgencyResearcher()
    @StateObject var streamers = AgencyRequestStreamerResultStore()
    @StateObject var agencyInfo = GroupMessageStore()
    @Environment(\.presentationMode) var present
    @State private var selection : Int = 0
    @State private var bodySelection : Int = 0
    @State private var searchPlatformID : String = ""
    @State private var toAgencyApplication : Bool = false
    
    //alerts
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var externalShowAlert : Bool = false
    @State private var externalAlertTitle : String = ""
    @State private var externalAlertBody : String = ""
    @State private var alertFunc : Int = 0
    
    @State private var showAlertStreamer : Bool = false
    @State private var alertTitleStreamer : String = ""
    @State private var alertBodyStreamer : String = ""
    @State private var blur : Bool = false
    @State private var showAgencyBuilder : Bool = false
    
    //Agency Data For Application
    @State private var agencyName : String = ""
    @State private var isComplatedTransactions : Bool = false
    @State private var isVerifiedAgency : Bool = false
    @State private var coverImage : String = ""
    @State private var phoneNumber : String = ""
    @State private var platformID : String = ""
    @State private var streamerList : [String] = []
    @State private var timeDate : String = ""
    var body: some View {
        ZStack{
            self.generalStore.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if self.userStore.isSentAgencyApplication == true && self.isComplatedTransactions == false {
                waitingStreamers // Yayincilarin onay bekleniyor
            }
            else if self.userStore.isSentAgencyApplication == true && self.isComplatedTransactions == true && self.isVerifiedAgency == false {
                waitingVerifiy
            }
            else if self.userStore.myAgencyId != ""{
                agencyView
            }
            else {
                accountTypes
            }
            

            if self.showAlertStreamer {
                ZStack{
                    Color.black.opacity(0.00000005).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 15){
                        Text(alertTitleStreamer)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text(alertBodyStreamer)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                        
                        HStack{
                            Button {
                                self.showAlertStreamer = false
                                self.blur = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.black)
                                    
                                    Text("Yayıncı Kal")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                            }
                            
                            
                            Button {
                                removeStremerEverywhere()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black)
                                    
                                    Text("Destekçiye Geç")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                            }
                            
                        }
                        .frame(height: 45)
                        
                        
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                }
            }
            
            if self.externalShowAlert {
                
                ZStack{
                    Color.black.opacity(0.000000005).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 15){
                        Text(externalAlertTitle)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text(externalAlertBody)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                        
                        HStack{
                            Button {
                                self.externalShowAlert = false
                                self.blur = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black)
                                    
                                    Text("Tamam")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                            }
                            
                            
                        }
                        .frame(height: 45)
                        
                        
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                }
                
            }
            
        }
        .onAppear{
            self.getAgencyRequestData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.selection = userStore.accountLevel
                if self.userStore.agencyApplicationUserId != "" {
                    researcher.getUserId(userId: userStore.agencyApplicationUserId)
                }
            }
        }
        .fullScreenCover(isPresented: $toAgencyApplication) {
            AgencyApplication()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), primaryButton: Alert.Button.default(Text("Vazgeç")), secondaryButton: Alert.Button.default(Text("Başvuru İptal")){
                let ref = Firestore.firestore()
                for doc in streamers.streamers {
                    ref.collection("Users").document(doc.userId).collection("AgencyApplicationQuestion").document(Auth.auth().currentUser!.uid).delete()
                }
                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["isSentAgencyApplication" : false, "agencyRequest" : false], merge: true)
                ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).delete()
                ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).collection("Streamers").getDocuments { snap, error in
                    if let error = error {}
                    
                    guard let documents = snap?.documents else { return }
                    
                    for document in documents {
                        document.reference.delete() 
                    }
                }
                streamers.streamers = []
            })
        }
    }
    
    var accountTypes : some View {
        VStack(alignment: .leading, spacing: 15){
            
            HStack{
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .frame(width: 45, height: 45)
                }
                
                Text("Account Type")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)

            }
            .padding([.top])
            
            Text("Hesap türünüzü buradan değiştirebilirsiniz. Yayıncı olmak isterseniz anında yayıncı profiline geçebilirsin. Eğer bir ajansa bağlı değilsen bazı özellikler sana kısıtlanacaktır. Eğer ajans isen en altta bulunan Ajans olduğunu bildir seçeneğinden anında ajans olduğunu bize bildirebilirsin. Bildirdikten sonra sizler ile iletişime geçerek hesabınızı doğrulayacağız.")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .padding(.bottom)
            
            HStack{
                Button {
                    if self.userStore.accountLevel == 2 {
                        self.externalAlertTitle = "Maalesef!"
                        self.externalAlertBody = "Ajans iken yayıncı hesabına geçiş yapamazsın!"
                        self.blur = true
                        self.externalShowAlert.toggle()
                    }
                    else if userStore.accountLevel == 1 {
                        self.externalAlertTitle = "Uyarı"
                        self.externalAlertBody = "Yayinci olabilmek için bir ajansa talep göndermelisiniz"
                        self.externalShowAlert = true
                        self.blur = true
                        self.selection = 0
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        if self.selection == 0 {
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                        }
                        
                        Text("Yayıncı")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                    }
                }
                
                if self.userStore.isSentAgencyApplication == false {
                    Button {
                        
                        if self.userStore.isAgency {
                            self.externalAlertTitle = "Maalesef!"
                            self.externalAlertBody = "Ajans iken destekçi hesabına geçiş yapamazsın!"
                            self.blur = true
                            self.externalShowAlert.toggle()
                            
                        }
                        else {
                            
                            if self.userStore.agencyName != "" {
                                self.blur = true
                                self.showAlertStreamer = true
                                self.alertTitleStreamer = "Yayıncılığın İptal Olacak!"
                                self.alertBodyStreamer = "Destekçiye geçer iseniz yayıncılığınız iptal olacaktır! Tekrardan destekçi olmak istiyor iseniz ajansınızdan ayrılmış olacaksınız!"
                            }
                            else {
                                self.selection = 1
                                let ref = Firestore.firestore()
                                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["accountLevel" : 1], merge: true)
                            }
                        }
                        
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            if self.selection == 1 {
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                            }
                            
                            Text("Destekçi")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                    }
                }
                
                
                
            }
            .frame(height: 45)
            
            if self.userStore.accountLevel == 2 {
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        Text("Ajans")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                    }
                    
                }
                .frame(height: 45)
                
                VStack(alignment: .leading, spacing: 15){
                    Text("Bir ajansı da aramızda görmek bizi mutlu ediyor. Bu hesap ile yayıncılarınzı kontrol edebilir, Takas yapmalarına yardımcı olablirsiniz. Bununla birlikte Sizlere özel hazırladığımız özellikleri yakından inceleyebilir veya kullanabilirsiniz.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.bottom)
                    
                    ForEach(agencyInfo.info) { item in
                        HStack(spacing: 15){
                            WebImage(url: URL(string: item.groupImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 70, height: 70)
                            
                            VStack(alignment: .leading, spacing: 15){
                                
                                Text("\(item.groupName)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                                
                                Text(userStore.bigoId)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.system(size: 18))
                        }
                    }
                }
                .padding(.bottom)
                .onAppear{
                    agencyInfo.getData(agency: userStore.agencyName)
                }
            }
            
            
            if self.selection == 0 {
                
                if userStore.myAgencyId == "" {
                    if self.userStore.agencyApplicationUserId == "" {
                        
                        Text("Ajansınızın Platform ID")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Ör: AhmetYLMZ", text: $searchPlatformID)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                                .onChange(of: searchPlatformID) { val in
                                    if val != "" {
                                        researcher.getData(platformID: val)
                                    }
                                }
                            
                        }
                        .frame(height: 45)
                    }
                    else {
                        Text("Başvurunuz devam ediyor, en yakın sürede yayıncı olma talebiniz sonuçlanacaktır")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.all)
                    }
                    
                    if self.researcher.userID != "" {
                        Text("Ajans Bilgisi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                        
                        
                        VStack(spacing: 15){
                            HStack(spacing: 10){
                                ZStack{
                                    WebImage(url: URL(string: researcher.pfImage))
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 70, height: 70)
                                    
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 10){
                                    Text(researcher.agencyName)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                    Text("Sahibi : \(researcher.nickname)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.light)
                                }
                                
                                Spacer(minLength: 0)
                                
                                LevelContentProfile(level: researcher.level)
                                    .scaleEffect(1)
                            }
                            
                            HStack{
                                Text("Email :")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                                
                                Spacer(minLength: 0)
                                
                                Text(researcher.email)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                            }
                            
                            HStack{
                                Text("Platform ID :")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                                
                                Spacer(minLength: 0)
                                
                                Text(researcher.platformID)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                            }
                            
                            if self.userStore.agencyApplicationUserId != "" {
                                Text("Başvurunuz devam ediyor!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .bold()
                                
                                Button {
                                    sendPushNotify(title: "Bir iptal söz konusu!", body: "\(userStore.firstName) yayıncılık başvurusunu red etti", userToken: researcher.token, sound: "pay.mp3")
                                    let ref = Firestore.firestore()
                                    ref.collection("Users").document(userStore.agencyApplicationUserId).collection("StreamerRequests").document(Auth.auth().currentUser!.uid).delete()
                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
                                        "agencyApplicationUserId" : "",
                                        "agencyRequest" : false
                                    ] as [String : Any], merge: true)
                                    
                                    self.searchPlatformID = researcher.platformID
                                    self.present.wrappedValue.dismiss()
                                } label: {
                                    Text("İptal Et")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                    
                                }
                                
                            }
                            else {
                                HStack{
                                    Button {
                                        self.searchPlatformID = ""
                                        self.researcher.userID = ""
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.black)
                                            
                                            Text("İptal")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                    Button {
                                        sendStreamerRequestToAgency()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.white)
                                            
                                            Text("Başvur")
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                }
                                .frame(height: 40)
                            }
                            
                        }
                        .padding(.all, 10)
                        .background(Color.black.opacity(0.2))
                    }
                }
                else {
                    VStack(spacing: 15){
                        HStack(spacing: 10){
                            ZStack{
                                WebImage(url: URL(string: researcher.pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70)
                                
                                
                            }
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text(researcher.agencyName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .bold()
                                
                                Text("Sahibi : \(researcher.firstName) \(researcher.lastName)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.light)
                            }
                            
                            Spacer(minLength: 0)
                            
                            LevelContentProfile(level: researcher.level)
                                .scaleEffect(1)
                        }
                        
                        HStack{
                            Text("Email :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                            
                            Spacer(minLength: 0)
                            
                            Text(researcher.email)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                        }
                        
                        HStack{
                            Text("Platform ID :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                            
                            Spacer(minLength: 0)
                            
                            Text(researcher.platformID)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                        }
                        
                        Text("Şu anda bu ajansın yayıncısısın")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                        
                    }
                    .padding(.all, 10)
                    .background(Color.black.opacity(0.2))
                }
                
            }
            else if self.selection == 1 {
                Text("Destekçi Profili Nedir?")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
                
                Text("Hesabınızı ilk oluşturduğunuzdan itibaren destekçi hesabınız varsayılan seçenek olarak gelir. Destekçiler Zirvedeki 50 kişiyi görebilir. Hediye kartlarını satın alabilir ve diğer tüm sosyal medya uygulamalarındaki yayıncıları için alışveriş yapabilirler. Eğer Bizzat sizde yayıncı hesabına geçiş yapabilirsiniz.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            Spacer(minLength: 0)
            
            if self.userStore.myAgencyId == "" {
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.toAgencyApplication.toggle()
                    } label: {
                        Text("Ajans olduğunu bildir")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.all)
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            
        }
        .padding(.horizontal)
    }
    
    var waitingStreamers: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack{
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
                
                Text("Başvurunuz Devam Ediyor")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            .onAppear {
                print("DATA ID  \(Auth.auth().currentUser?.uid)")
            }
            
            ScrollView(.vertical, showsIndicators: false) {
               
                VStack(alignment: .leading, spacing: 15){
                    
                    Text("Ajans olduğunuzu bildirdiniz. Seçtiğiniz yayıncılarınız, onayladığında işlemleri tamamlayacağız. Biraz sabırlı olmak gerekiyor. Yayıncılarınız ile iletişime geçerek onaylamalarını söyleyebilirsiniz. İlgi ve alakanızdan dolayı teşekkür ederiz!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.bottom)
                    
                    Text("1- Ajans Olduğunu Bildirmek")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .opacity(0.3)
                    
                    Text("2- Başvurunuzun değerlendirilmesi")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .opacity(0.3)
                    
                    Text("3- Seçeceğiniz 5 yayıncıdan, teyit almamız")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                    
                    Text("4- İşlemlerin Tamamlanması")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                        .opacity(0.3)
                    
                    
                    Text("Teyit Alınan Yayıncılar")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                        .padding(.top)
                }
                .padding(.horizontal)
                
                ForEach(streamers.streamers) { item in
                    HStack(spacing: 12){
                        WebImage(url: URL(string: item.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading, spacing: 7){
                            Text(item.platformID)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Text(item.nickname)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .fontWeight(.light)
                        }
                        
                        Spacer(minLength: 0)
                        
                        if item.isAccepted == 2{
                            Text("Onayladı")
                                .foregroundColor(Color.init(hex: "#1CC4BE"))
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                        }
                        else if item.isAccepted == 1{
                            Text("Reddedildi")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                        }
                        else if item.isAccepted == 0 {
                            Text("Onay Bekleniyor")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
                
                HStack{
                    Button {
                        self.alertTitle = "Hey! Nereye Gidiyorsun?"
                        self.alertBody = "Her şey gayet güzel devam ederken başvurunu iptal etmek bizi üzecek. Başvurunu hâlâ iptal etmek istiyor musun?"
                        self.alertFunc = 1 //deactive
                        self.showAlert.toggle()
                    } label: {
                        ZStack{
                            Rectangle()
                                .stroke(Color.white)
                            
                            Text("İptal Et")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    if streamers.acceptedCount >= 5 {
                        Button {
                            complateTransaction()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .fill(Color.white)
                                
                                Text("Tamamla")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    
                }
                .frame(height: 45)
                .padding(.all)
            }
        }
        .onAppear{
            self.streamers.getData()
            self.getAgencyRequestData()
        }
    }
    
    var waitingVerifiy: some View {
        VStack{
            HStack(spacing: 12){
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
                
                
                Text("Neredeyse Tamam")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(alignment: .leading, spacing: 15){
                    Text("Tebrikler! Başvurunuz neredeyse bitti.\nEn son olarak tarafımızca bir güvenlik doğrulaması yapılacaktır. En kısa sürede Ajansınız hesabınıza tanımlanacaktır.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.bottom)
                        .padding(.leading)
                    
                    Text("Yayıncılarınız")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.leading)
                    
                    ForEach(streamers.streamers) { item in
                        HStack(spacing: 12){
                            WebImage(url: URL(string: item.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading, spacing: 7){
                                Text(item.nickname)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Text("\(item.firstName) \(item.lastName)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                            }
                            
                            Spacer(minLength: 0)
                            
                           
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }

    var agencyView : some View {
        VStack(alignment: .center, spacing: 20){
            HStack(spacing: 12){
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
                
                
                Text("Account Type")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])

            
            WebImage(url: URL(string: coverImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 150, height: 150)
                .padding(.top, 50)
            
            Text(agencyName)
                .foregroundColor(.white)
                .font(.system(size: 25))
                .fontWeight(.medium)
            
            Text("Bu ajansın sahibisiniz")
                .foregroundColor(.white)
                .font(.system(size: 18))
            
            Spacer(minLength: 0)
            
        }
        .onAppear{
            getDataAgencyInfo()
        }
    }
    
    func getDataAgencyInfo() {
        let ref = Firestore.firestore()
        print("Agency \(userStore.myAgencyId)")
        ref.collection("Agencies").document(userStore.myAgencyId).addSnapshotListener { doc, err in
            if err == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    if let coverImage = doc?.get("coverImage") as? String {
                        if let streamers = doc?.get("streamers") as? [String] {
                            self.agencyName = agencyName
                            self.coverImage = coverImage
                            self.streamerList = streamers
                        }
                    }
                }
            }
        }
    }
    
    func getAgencyRequestData(){
        let ref = Firestore.firestore()
        ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
            
            if err == nil {
                if let isVerifiedAgency = doc?.get("isVerifiedAgency") as? Bool {
                    if let isComplatedTransactions = doc?.get("isComplatedTransactions") as? Bool {
                        if let agencyName = doc?.get("agencyName") as? String {
                            if let streamerList = doc?.get("streamers") as? [String] {
                                self.streamerList = streamerList
                                self.agencyName = agencyName
                                self.isVerifiedAgency = isVerifiedAgency
                                self.isComplatedTransactions = isComplatedTransactions
                                print("Donee")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func complateTransaction(){
        let ref = Firestore.firestore()
        ref.collection("AgencyRequests").document(Auth.auth().currentUser!.uid).setData([
            "isComplatedTransactions" : true
        ], merge: true)
    }
    
    func removeStremerEverywhere(){
        //step 1
        let ref = Firestore.firestore()
        ref.collection("Users").document(userStore.agencyApplicationUserId).collection("MyStreamers").document(Auth.auth().currentUser!.uid).delete()

        ref.collection("Groups").document("BigoLive").collection(userStore.agencyName).document("GroupInfo").collection("Users").document(Auth.auth().currentUser!.uid).delete()
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyInfo").document(Auth.auth().currentUser!.uid).setData(
            [
                "firstName" : "",
                "lastName" : "",
                "userId" : "",
                "pfImage" : "",
                "platformID" : "",
                "agencyName" : "",
                "isInTheGroup" : false
            ], merge: true)
        
        sendPushNotify(title: "Talihsiz bir olay!", body: "Artık \(userStore.firstName) sizin yayıncınız değil. Kendisi artık destekçi hesabına geçti!", userToken: researcher.token, sound: "pay.mp3")
        
        let updateData = [
            "agencyRequest" : false,
            "agencyApplicationUserId" : "",
            "isSupporter" : 1
        ] as [String : Any]
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(updateData, merge: true)
       
        self.blur = false
        self.showAlertStreamer = false
        self.selection = 1
    }

    func sendStreamerRequestToAgency(){
        let ref = Firestore.firestore()
        let date = Date()
        var timeDate = ""
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timeDate = formatter.string(from: date)
        
        let data = [
            "fullname" : "\(self.userStore.firstName) \(self.userStore.lastName)",
            "pfImage" : self.userStore.pfImage,
            "bigoId" : self.userStore.bigoId,
            "userid" : Auth.auth().currentUser!.uid,
            "timeDate" : timeDate
        ]
        
        ref.collection("Users").document(self.researcher.userID).collection("StreamerRequests").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        
        sendPushNotify(title: "Merhaba! Sizin yayıncınız olmak istiyorum!", body: "\(userStore.firstName), senin yayıncın olmak istiyor!", userToken: researcher.token, sound: "pay.mp3")
        
        let updateData = [
            "agencyRequest" : true,
            "agencyApplicationUserId" : self.researcher.userID
        ] as [String : Any]
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(updateData, merge: true)
        self.present.wrappedValue.dismiss()
    }
}

