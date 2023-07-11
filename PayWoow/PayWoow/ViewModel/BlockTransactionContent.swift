//
//  BlockTransaction.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/16/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct BlockTransactionContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var angelID : String
    @State var classTitle : String
    @State var desc : String
    @State var devilID : String
    @State var point : Int
    @State var product : Int
    @State var productType : String
    @State var step : Int
    @State var step0Time : String
    @State var step1Time : String
    @State var step2Time : String
    @State var step3Time : String
    @State var step4Time : String
    @State var step5Time : String
    @State var step6Time : String
    @State var step7Time : String
    @State var stepUserID : String
    @State var timeStamp : Int
    @State var docID : String
    
    //Fetched Angel Data
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var nickname : String = ""
    @State private var token : String = ""
    @State private var level : Int = 0
    @State private var vipPoint : Int = 0
    
    
    @State private var angelVipType : String = ""
    @State private var angelPrice : Int = 0
    
    @State private var showDetails : Bool = false
    @State private var timeDate : String = ""
    var body : some View {
        VStack{
            angelProfiles
            
            if showDetails {
                transactionDetails
                
                progresLive
                
                buttonsBody
            }
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .onAppear{
            getUserData()
            getGift()
            getDate()
        }
    }
    
    var angelProfiles : some View {
        VStack{
            if self.angelID == Auth.auth().currentUser!.uid {
                HStack{
                    ZStack{
                        
                        AsyncImage(url: URL(string: userStore.pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        }
                        
                        
                        LottieView(name: "angel_white", loopMode: .loop, speed: 2.0)
                            .scaleEffect(1.5)
                            .frame(width: 95, height: 95)
                            .offset(y: -3)
                        
                        if self.userStore.level != 0 {
                            LevelContentProfile(level: userStore.level)
                                .scaleEffect(0.8)
                                .offset(y: 40)
                        }
                    }
                    .scaleEffect(0.7)
                    .padding(.leading, -10)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.showDetails.toggle()
                    } label: {
                        if step == 0 {
                            Text("Beklemede")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                        else if step == 1{
                            Text("İşlemde")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.init(hex: "9D8F5B"))
                                .cornerRadius(4)
                        }
                        else if step == 2 || step == 3 {
                            Text("Tamamlandı")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.green)
                                .cornerRadius(4)
                        }
                        else if step == 4 {
                            Text("Red Edildi")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                        else if step == 5 {
                            Text("İhlal")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                    }
                    
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        }
                        
                        
                        LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                            .scaleEffect(1.5)
                            .frame(width: 95, height: 95)
                            .offset(x: 1.5, y: -3)
                        
                        if self.level != 0 {
                            LevelContentProfile(level: level)
                                .scaleEffect(0.8)
                                .offset(y: 40)
                        }
                    }
                    .scaleEffect(0.7)
                    .padding(.trailing, -10)
                }
            }
            else {
                
                HStack{
                    ZStack{
                        
                        AsyncImage(url: URL(string: userStore.pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        }
                        LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                            .scaleEffect(1.5)
                            .frame(width: 95, height: 95)
                            .offset(x: 1.5, y: -3)
                        
                        if self.userStore.level != 0 {
                            LevelContentProfile(level: userStore.level)
                                .scaleEffect(0.8)
                                .offset(y: 40)
                        }
                    }
                    .scaleEffect(0.7)
                    .padding(.leading, -10)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.showDetails.toggle()
                    } label: {
                        if step == 0 {
                            Text("Beklemede")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.white)
                                .cornerRadius(4)
                        }
                        else if step == 1{
                            Text("İşlemde")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.init(hex: "9D8F5B"))
                                .cornerRadius(4)
                        }
                        else if step == 2 || step == 3 {
                            Text("Tamamlandı")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.green)
                                .cornerRadius(4)
                        }
                        else if step == 4 {
                            Text("Red Edildi")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                        
                        else if step == 5 {
                            Text("İhlal")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .frame(width: 130)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                    }
                    
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        }
                        
                        
                        LottieView(name: "angel_white", loopMode: .loop, speed: 2.0)
                            .scaleEffect(1.5)
                            .frame(width: 95, height: 95)
                            .offset(y: -3)
                        
                        if self.level != 0 {
                            LevelContentProfile(level: level)
                                .scaleEffect(0.8)
                                .offset(y: 40)
                        }
                    }
                    .scaleEffect(0.7)
                    .padding(.trailing, -10)
                }
                
            }
        }
    }
    
    var transactionDetails: some View {
        VStack(spacing: 10){
            HStack{
                Text("İşlem Numarası")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text(docID)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            HStack{
                Text("Ceza Sınıfı")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text("\(classTitle)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            HStack{
                Text("Talep")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text("\(desc)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            HStack{
                Text("Kullanılan Puan")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text("\(point)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
            HStack{
                Text("İşlem Tarihi")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text("\(timeDate)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
        }
    }
    
    var progresLive: some View {
        VStack(spacing: 10){
            HStack(alignment: .top, spacing: 10){
                
                if step == 0 {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                else if step < 0 {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                else if step > 0 {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                
                VStack(alignment: .leading, spacing: 5){
                    Text("Beklemede")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("\(step0Time)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                
                Spacer(minLength: 0)
            }
            
            HStack(alignment: .top, spacing: 10){
                
                if step == 1 {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                else if step < 1 {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                else if step > 1 {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                }
                
                VStack(alignment: .leading, spacing: 5){
                    Text("İşleme Alındı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("\(step1Time)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                
                Spacer(minLength: 0)
            }
            
            if step == 2 || step == 3 {
                HStack(alignment: .top, spacing: 10){
                    
                    if step == 2 {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 12, height: 12)
                            .padding(.top, 2)
                    }
                    else if step < 2 {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 12, height: 12)
                            .padding(.top, 2)
                    }
                    else if step > 2 && step < 4 {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .padding(.top, 2)
                    }
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("İşlem Tamamlandı")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("\(step2Time)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            
            if step >= 4 {
                HStack(alignment: .top, spacing: 10){
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("İşlem Reddedildi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("\(step4Time)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            
            if step == 5 {
                HStack(alignment: .top, spacing: 10){
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("İhlal Bildirildi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("\(step5Time)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    
                    Spacer(minLength: 0)
                }
            }
           
        }
    }
    
    var buttonsBody: some View {
        VStack(spacing: 15){
            if step == 0 && self.devilID == Auth.auth().currentUser!.uid {
                Text("Sevgili meleğimiz olan \(self.nickname), sizi kurtarmak istiyor. Devam edelim mi?")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        stepZeroDecline()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Reddet")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        stepZeroAccept()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Kabul Et")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 45)
            }
            
            if step == 1 && self.devilID == Auth.auth().currentUser!.uid {
                Text("Lütfen bekleyiniz. Meleğimiz size yardımcı olmak ve aldığınız cezayı kaldırmak için uğraşıyor.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
            }
            
            if step == 1 && self.angelID == Auth.auth().currentUser!.uid{
                Text("Sevgili meleğimiz! Şeytanımız taleibinizi kabul etti. Şimdi seçtiğiniz platforma giderek bu şeytanımzın cezasını (\(self.classTitle) Ban) VIP puanlarınızı kullanarak kaldırınız. şeytanın banı kaldırıldığında veya banı kaldırmadığında buraya gelerek aşağıdan seçiminizi yapınız.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        stepOneDecline()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Ban Kaldırılmadı")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        stepOneAccept()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Ban Kaldırıldı")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 45)
            }
            
            if step == 2 && self.devilID == Auth.auth().currentUser!.uid{
                Text("Meleğimiz banını kaldırdığını bildirdi! Banınız gerçekten kaldırdı mı?")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        stepOneDeclineDevil()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Hayır")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        stepOneAcceptDevil()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("Evet")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 45)
            }
            
            if step == 4 {
                Text("Konu mevzu olan ban kaldırma talebi olumsuz sonuçlanmıştur\n Bu mesaj 72 saat içinde kaybolacaktır.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        ihlalBildir()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                            
                            Text("İhlal Bildir")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 45)
            }
            
            if step == 5{
                Text("ihlal bildirildi! Hesaplarınız kontrol edilecek ve usulsüzlük tespit edildiği taktirde hesaplarınız askıya alınacaktır.\n Bu mesaj 72 saat içinde kaybolacaktır.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        let mailtoString = "mailto:blockservices@paywoow.com?subject=Ban Hizmetleri Sorunu! &body=Merhaba\nBen \(self.userStore.firstName) \(self.userStore.lastName)\nUserId: \(Auth.auth().currentUser!.uid)\nBigoId: \(self.userStore.bigoId)\nBan hizmetlerini gerçekleştirirken şeytan olan (USERID:\(devilID)) bana ihanet etti. Banını kaldırmama rağmen kaldırılmadığını bildiriyor. Yardım lütfen\nEkran Videosu ve Ekran Fotoğrafı ekleyiniz......".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let mailtoUrl = URL(string: mailtoString!)!
                        if UIApplication.shared.canOpenURL(mailtoUrl) {
                            UIApplication.shared.open(mailtoUrl, options: [:])
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Text("Destek")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }

                }
                .frame(height: 45)
            }
            
            
            if step == 3 && self.angelID == Auth.auth().currentUser!.uid{
                Text("Sizlere teşekkür ederiz!\nŞeytanımız artık kurtuldu!\n Bu mesaj 72 saat içinde kaybolacaktır.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)

            }
            
            if step == 3 && self.devilID == Auth.auth().currentUser!.uid{
                Text("Tebrikler! Artık özgürsün!\nMeleğimiz seni kurtardı\n Bu mesaj 72 saat içinde kaybolacaktır.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)

            }
        }
    }
    
    func ihlalBildir(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 5,
                "step5Time" : timeDate,
            ]
            , merge: true)
    }
    
    func stepZeroDecline(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 4,
                "step0Time" : timeDate,
                "step1Time" : timeDate,
                "step4Time" : timeDate
            ]
            , merge: true)
        
        sendPushNotify(title: "Maalesef!", body: "Şeytan ban kaldırma talebinizi reddetti. Puanınız tekrar tanımlandı", userToken: self.token, sound: "pay.mp3")
        
        ref.collection("Users").document(angelID).setData([
            "vipPoint" : Int(vipPoint + point)
        ], merge: true)
    }
    
    func stepZeroAccept(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 1,
                "step0Time" : timeDate,
                "step1Time" : timeDate,
            ]
            , merge: true)
        
        sendPushNotify(title: "Haydi Devam Edelim!", body: "Şeytan ban kaldırma talebinizi kabul etti.", userToken: self.token, sound: "pay.mp3")
    }
    
    func stepOneDecline(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 4,
                "step0Time" : timeDate,
                "step1Time" : timeDate,
                "step4Time" : timeDate
            ]
            , merge: true)
        
        sendPushNotify(title: "Maalesef!", body: "Meleğimiz yardımcı olmak istedi. Fakat cezanızı kaldıramadı. İlginizden dolayı teşekkür ederiz", userToken: self.token, sound: "pay.mp3")
        
        ref.collection("Users").document(angelID).setData([
            "vipPoint" : Int(vipPoint + point)
        ], merge: true)
    }
    
    func stepOneAccept(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 2,
                "step2Time" : timeDate
            ]
            , merge: true)
        
        sendPushNotify(title: "Nerdeyse Tamam!", body: "Meleğimiz banınızın kaldırıldığını bildirdi. Şimdi yayıncı olduğunuz platforma girerek Banınızın kaldırıldığını veya kaldırılmadığını bize bildiriniz.", userToken: self.token, sound: "pay.mp3")
    }
    
    func stepOneDeclineDevil(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 4,
                "step0Time" : timeDate,
                "step1Time" : timeDate,
                "step4Time" : timeDate
            ]
            , merge: true)
        
        sendPushNotify(title: "Maalesef!", body: "Şeytan banının kaldırılmadığını bildirildi.", userToken: self.token, sound: "pay.mp3")
        
        ref.collection("Users").document(angelID).setData([
            "vipPoint" : Int(vipPoint + point)
        ], merge: true)
    }
    
    func stepOneAcceptDevil(){ // 0
        let ref = Firestore.firestore()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let timeDate = formatter.string(from: date)
        ref.collection("BlockTransactions").document(docID).setData(
            [
                "step" : 3,
                "step3Time" : timeDate
            ]
            , merge: true)
        
        

        sendPushNotify(title: "Teşekkür ederiz!!", body: "Şeytanımız da banının kaldırıldığını onayladı.", userToken: self.token, sound: "pay.mp3")
    }
    
    func getUserData(){
        let ref = Firestore.firestore()
        if self.angelID == Auth.auth().currentUser!.uid {
            ref.collection("Users").document(devilID).addSnapshotListener { doc, err in
                if err == nil {
                    if let firstName = doc?.get("firstName") as? String {
                        if let lastName = doc?.get("lastName") as? String {
                            if let pfImage = doc?.get("pfImage") as? String {
                                if let token = doc?.get("token") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        if let nickname = doc?.get("nickname") as? String {
                                            if let vipPoint = doc?.get("vipPoint") as? Int {
                                                self.firstName = firstName
                                                self.lastName = lastName
                                                self.pfImage = pfImage
                                                self.token = token
                                                self.level = level
                                                self.nickname = nickname
                                                self.vipPoint = vipPoint
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
        else {
            ref.collection("Users").document(angelID).addSnapshotListener { doc, err in
                if err == nil {
                    if let firstName = doc?.get("firstName") as? String {
                        if let lastName = doc?.get("lastName") as? String {
                            if let pfImage = doc?.get("pfImage") as? String {
                                if let token = doc?.get("token") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        if let nickname = doc?.get("nickname") as? String {
                                            self.firstName = firstName
                                            self.lastName = lastName
                                            self.pfImage = pfImage
                                            self.token = token
                                            self.level = level
                                            self.nickname = nickname
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
    
    func getGift(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(angelID).addSnapshotListener { doc, err in
            if err == nil {
                if let vipType = doc?.get("gift") as? Int {
                    
                }
            }
        }
    }
    
    func getDate(){
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        self.timeDate = formatter.string(from: date)
    }
}
