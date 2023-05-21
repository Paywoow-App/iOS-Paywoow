//
//  AppManager.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/27/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct AppManager : View {
    @Environment(\.presentationMode) var present
    @State var dealler: String
    @State private var turnOnLive = false
    @State private var liveLink = ""
    @State private var autoMessage : String = ""
    @State private var lockApp : Bool = false
    @State private var matchSignature = false
    @State private var christmasHat = false
    @State private var showDeleteUser = false
    @State private var userBigoId : String = ""
    @StateObject var researcher = UserDeleteResearcher()
    @StateObject var generalStore = GeneralStore()
    @StateObject var payTRStore = PayTRStore()
    @StateObject var netgsmStore = NETGSMStore()
    @State private var alert = false
    @State private var showAutoMessage = false
    @State private var showLimitSelector = false
    @State private var inputLimit = ""
    @State private var showPaytr = false
    @State private var merchant_ok_url : String = ""
    @State private var merchant_fail_url : String = ""
    @State private var merchant_id: String = ""
    @State private var merchant_key: String = ""
    @State private var merchant_salt: String = ""
    @State private var post_url: String = ""
    @State private var usercode : String = ""
    @State private var password: String = ""
    @State private var header: String = ""
    @State private var showNetgsm : Bool = false
    @AppStorage("orderPriceLimit") var orderLimit : Int = 200
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 100, height: 5)
                    .padding(.top, 10)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                        .padding(.leading)
                    
                    Text("Uygulama Yönetimi")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                ScrollView(showsIndicators: false){
                    VStack(spacing: 15) {
                        
                        Toggle("Canlı yayına geçtiği bildir", isOn: $turnOnLive)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: self.turnOnLive) { val in
                                if self.dealler == "DiamondBayii" {
                                    let ref = Firestore.firestore()
                                    ref.collection("GeneralInfo").document("iOS").setData(["liveYigit" : val], merge: true)
                                    if val == false {
                                        let ref = Firestore.firestore()
                                        ref.collection("GeneralInfo").document("iOS").setData(["liveLinkYigit" : ""], merge: true)
                                        self.liveLink = ""
                                    }
                                }
                                else if self.dealler == "FerinaValentino" {
                                    let ref = Firestore.firestore()
                                    ref.collection("GeneralInfo").document("iOS").setData(["liveFerina" : val], merge: true)
                                    if val == false {
                                        let ref = Firestore.firestore()
                                        ref.collection("GeneralInfo").document("iOS").setData(["liveLinkFerina" : ""], merge: true)
                                        self.liveLink = ""
                                    }
                                }
                            }
                        
                        if self.turnOnLive {
                            
                            HStack{
                                
                                Image(systemName: "arrow.turn.down.right")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.3))
                                    
                                    HStack{
                                        TextField("Canlı yayın linki (zorunlu)", text: $liveLink)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .padding(.horizontal, 10)
                                            .preferredColorScheme(.dark)
                                            .onChange(of: self.liveLink) { val in
                                                if self.dealler == "DiamondBayii" {
                                                    let ref = Firestore.firestore()
                                                    ref.collection("GeneralInfo").document("iOS").setData(["liveLinkYigit" : val], merge: true)
                                                }
                                                else if self.dealler == "FerinaValentino" {
                                                    let ref = Firestore.firestore()
                                                    ref.collection("GeneralInfo").document("iOS").setData(["liveLinkFerina" : val], merge: true)
                                                }
                                            }
                                        
                                        Button {
                                            self.liveLink = UIPasteboard.general.string ?? ""
                                        } label: {
                                            Image(systemName: "doc.on.doc")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .frame(width: 20, height: 20)
                                        }
                                        .padding(.trailing)
                                    }
                                    
                                }
                                .frame(height: 50)
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        }
                        
                        Toggle("Uygulamayı kilitle", isOn: $lockApp)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: lockApp) { val in
                                let ref = Firestore.firestore()
                                ref.collection("GeneralInfo").document("iOS").setData(["lockApp" : val], merge: true)
                            }
                        
                        if self.lockApp {
                            HStack{
                                
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.3))
                                    
                                    HStack{
                                        Text("Uygulamayı artık kimse kullanamayacak!")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .padding(.horizontal, 10)
                                        Spacer()
                                    }
                                    
                                }
                                .frame(height: 60)
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        }
                        
                        Toggle("Yılbaşı Animasyonları", isOn: $christmasHat)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                            .onChange(of: christmasHat) { val in
                                let ref = Firestore.firestore()
                                ref.collection("GeneralInfo").document("iOS").setData(["christmasHat" : val], merge: true)
                            }

                        if self.christmasHat {
                            HStack{
                                
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.3))
                                    
                                    HStack{
                                        Text("Yılbaşı animasyonları aktif olacak!")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .padding(.horizontal, 10)
                                        Spacer()
                                    }
                                    
                                }
                                .frame(height: 50)
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        }
                        Button {
                            self.showDeleteUser.toggle()
                            
                        } label: {
                            HStack{
                                Text("Kullanıcıyı imha et")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                
                                Spacer()
                                
                                if self.showDeleteUser {
                                    Image(systemName: "chevron.up")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }
                                else {
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if self.showDeleteUser {
                            HStack{
                                
                                Image(systemName: "arrow.turn.down.right")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.3))
                                    
                                    HStack{
                                        if self.researcher.userFullname != "" {
                                            Text(self.userBigoId)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .padding(.horizontal, 10)
                                                
                                        }
                                        else {
                                            TextField("Kullanıcı Bigo Id", text: $userBigoId)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .padding(.horizontal, 10)
                                                .preferredColorScheme(.dark)
                                                .onChange(of: userBigoId) { value in
                                                    self.researcher.searchUser(bigoid: value)
                                                }
                                        }
                                        
                                        Spacer(minLength: 0)
                                        
                                        if self.researcher.userFullname != "" {
                                            
                                        }
                                        else {
                                            Button {
                                                self.userBigoId = UIPasteboard.general.string ?? ""
                                            } label: {
                                                Image(systemName: "doc.on.doc")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.white)
                                                    .frame(width: 20, height: 20)
                                            }
                                            .padding(.trailing)
                                        }
                                    }
                                    
                                }
                                .frame(height: 50)
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            
                            if self.researcher.userFullname != "" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    
                                    HStack{
                                        WebImage(url: URL(string: self.researcher.userProfileImage))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                        
                                        VStack(alignment: .leading){
                                            Text(self.researcher.userFullname)
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                                
                                            
                                            Text(self.researcher.email)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
     
                                        }
                                        
                                        Spacer()
                                        
                                        Text("Lv\(self.researcher.level)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            
                                    }
                                    .padding(.horizontal)
                                        
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                            }
                            
                            HStack{
                                
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.3))
                                    
                                    HStack{
                                        Text("Bu kullanıcıya dair bütün veriler silinecek. Bir daha hiç bir zaman bu uygulamayı kullanamayacaktır! Yalnızca yazılımcı izin verdiği süreçte bu kullanıcı tekrar kullanabilir.")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .padding(.horizontal, 10)
                                        Spacer()
                                    }
                                    
                                }
                                .frame(height: 140)
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            
                            if self.researcher.userFullname != "" {
                                Button {
                                    if self.researcher.email == "sariygt81@gmail.com"  && self.researcher.email != "feyzasenyurt@gmail.com"{
                                        self.alert.toggle()
                                    }
                                    else {
                                        //here
                                    }
                                } label: {
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.red)
                                        
                                        Text("Kullanıcı İmha Et")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                        
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                                }
                            }

                        }
                        Group{
                            
                            Button {
                                self.showAutoMessage.toggle()
                            } label: {
                                
                                HStack{
                                    Text("Paylaş ekranı mesajı")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    if self.showAutoMessage {
                                        Image(systemName: "chevron.up")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                    else {
                                        Image(systemName: "chevron.down")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .padding(.horizontal)

                            }
                            
                            if self.showAutoMessage {
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.5))
                                    TextEditor(text: $autoMessage)
                                        .background(Color.clear)
                                        .foregroundColor(.white)
                                        .padding(.all, 10)
                                        .onChange(of: autoMessage) { value in
                                            let ref = Firestore.firestore()
                                            ref.collection("GeneralInfo").document("iOS").setData(["autoMessage" : value], merge: true)
                                        }
                                        
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            }
                            
                            
                            
                            
                            
                            Button {
                                self.showLimitSelector.toggle()
                            } label: {
                                
                                HStack{
                                    Text("Bekleyen Sipariş Uyarı Limiti")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    Text("\(orderLimit)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                                
                            }
                            .padding(.horizontal)
                            
                            
                            HStack{
                                Text("Entegrasyonlar")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .bold()
                                
                                Spacer()
                            }
                            .padding()
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.1))
                                    .onTapGesture {
                                        self.showPaytr.toggle()
                                    }
                                VStack{
                                    HStack{
                                        Image("paytr")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        VStack(alignment: .leading){
                                            Text("PayTR")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                        }
                                        
                                        Spacer()
                                        
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(10)
                                    
                                    
                                    if self.showPaytr {
                                        VStack(alignment: .leading, spacing: 10){
                                            TextField("merchant_id", text: $merchant_id)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("merchant_salt", text: $merchant_salt)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("merchant_key", text: $merchant_key)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("merchant_ok_url", text: $merchant_ok_url)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("merchant_fail_url", text: $merchant_fail_url)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("post_url", text: $post_url)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            HStack{
                                                Button {
                                                    self.showPaytr = false
                                                } label: {
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.black)
                                                        
                                                        Text("İptal")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 18))
                                                    }
                                                }

                                                if self.merchant_id != "" && self.merchant_key != "" && self.merchant_salt != "" && self.merchant_ok_url != "" && self.merchant_fail_url != "" && self.post_url != "" {
                                                    Button {
                                                        let data = [
                                                            "merchant_id" : merchant_id,
                                                            "merchant_key"  : merchant_key,
                                                            "merchant_salt" : merchant_salt,
                                                            "merchant_ok_url" : merchant_ok_url,
                                                            "merchant_fail_url" : merchant_fail_url,
                                                            "post_url" : post_url
                                                        ] as [String:String]
                                                        let ref = Firestore.firestore()
                                                        ref.collection("GeneralInfo").document("PAYTR").setData(data, merge: true)
                                                        self.present.wrappedValue.dismiss()
                                                    } label: {
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.white)
                                                            
                                                            Text("Güncelle")
                                                                .foregroundColor(.black)
                                                                .font(.system(size: 18))
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(height: 40)
                                        }
                                        .padding(10)
                                    }
                                }
                            }.padding(.horizontal)
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.1))
                                    .onTapGesture {
                                        self.showNetgsm.toggle()
                                    }
                                VStack{
                                    HStack{
                                        Image("netgsm")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        VStack(alignment: .leading){
                                            Text("NetGSM")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                        }
                                        
                                        Spacer()
                                        
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(10)
                                    
                                    
                                    if self.showNetgsm {
                                        VStack(alignment: .leading, spacing: 10){
                                            TextField("usercode", text: $usercode)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("password", text: $password)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            TextField("header", text: $header)
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                                .colorScheme(.dark)
                                            
                                            HStack{
                                                Button {
                                                    self.showNetgsm = false
                                                } label: {
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.black)
                                                        
                                                        Text("İptal")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 18))
                                                    }
                                                }

                                                if self.usercode != ""  && self.password != "" && self.header != "" {
                                                    Button {
                                                        let data = [
                                                            "usercode" : usercode,
                                                            "password" : password,
                                                            "header" : header
                                                        ] as [String:String]
                                                        let ref = Firestore.firestore()
                                                        ref.collection("GeneralInfo").document("NETGSM").setData(data, merge: true)
                                                        self.present.wrappedValue.dismiss()
                                                    } label: {
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.white)
                                                            
                                                            Text("Güncelle")
                                                                .foregroundColor(.black)
                                                                .font(.system(size: 18))
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(height: 40)
                                        }
                                        .padding(10)
                                    }
                                }
                            }.padding(.horizontal)
                            
                        }
                        
                        
                        
                    }
                    

                }
            }
            
            
                
            if self.showLimitSelector == true {
                ZStack{
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).onTapGesture {
                        self.showLimitSelector.toggle()
                    }
                    
                    ZStack{
                     RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            
                        VStack(spacing: 15){
                            Text("Bekleyen Sipariş Uyarı Limiti")
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                                .bold()
                                .multilineTextAlignment(.center)
                            
                            Text("Bir tutar belirle. Bu tutarın üzerindeki siparişleri sana şiddetli bir ses ile bildireyim")
                                .foregroundColor(.black.opacity(0.5))
                                .font(.system(size: 20))
                                .multilineTextAlignment(.center)
                            
                            
                            
                            
                            TextField("", text: $inputLimit)
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                                .colorScheme(.light)
                                .padding(.horizontal, 30)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .onAppear{
                                    self.inputLimit = "\(orderLimit)"
                                }
                                
                            
                            Button {
                                self.orderLimit = Int(inputLimit) ?? 100
                                self.showLimitSelector.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.init(red: 88 / 255, green: 186 / 255, blue: 176 / 255))
                                    
                                    Text("Ayarla")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                .frame(height: 50)
                            }

                                
                                
                        }
                        .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                }
            }
            
            
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Bunu yapacağımı gerçekten düşünmüyorsun değil mi?"), message: Text(""), dismissButton: Alert.Button.default(Text("Anladım"), action: {
                
            }))
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.autoMessage = self.generalStore.autoMessage
                self.christmasHat = self.generalStore.christmasHat
                self.lockApp = self.generalStore.locked
                if self.dealler == "DiamondBayii" {
                    self.liveLink = self.generalStore.liveLinkYigit
                    self.turnOnLive = self.generalStore.liveYigit
                }
                else if self.dealler == "FerinaValentino" {
                    self.liveLink = self.generalStore.liveLinkFerina
                    self.turnOnLive = self.generalStore.liveFerina
                }
                
                self.merchant_id = payTRStore.merchant_id
                self.merchant_key = payTRStore.merchant_key
                self.merchant_salt = payTRStore.merchant_salt
                self.merchant_ok_url = payTRStore.merchant_ok_url
                self.merchant_fail_url = payTRStore.merchant_fail_url
                self.post_url = payTRStore.post_url
                
                self.usercode = netgsmStore.usercode
                self.password = netgsmStore.password
                self.header = netgsmStore.header
                
            }
        }
    }
}


class UserDeleteResearcher: ObservableObject {
    @Published var userId : String = ""
    @Published var userProfileImage : String = ""
    @Published var userFullname : String = ""
    @Published var level : Int = 0
    @Published var email : String = ""
    let ref = Firestore.firestore()
    func searchUser(bigoid: String) {
        ref.collection("Users").addSnapshotListener { snap, err in
            if err != nil {
            }
            else {
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if bigoid == bigoId {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        if let email = doc.get("email") as? String {
                                            if let level = doc.get("level") as? Int {
                                                self.userId = doc.documentID
                                                self.userFullname = "\(firstName) \(lastName)"
                                                self.userProfileImage = pfImage
                                                self.level = level
                                                self.email = email
                                                print(self.userFullname)
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
