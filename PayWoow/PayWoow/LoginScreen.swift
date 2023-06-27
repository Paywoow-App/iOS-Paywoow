//
//  LoginScreen.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/9/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import SDWebImageSwiftUI
import LocalAuthentication
import DeviceKit
import CryptoKit
import GoogleSignIn
import Network

struct LoginScreen: View {
    @State private var bodySelection : Int = 0
    @State private var registerStep : Int = 1
    @State private var toMainTabView : Bool = false
    @State private var blur = false
    @State private var signInSelection : Int = 0
    @State private var currentNonce: String?
    
    //inputs
    @State private var bDay : String = ""
    @State private var age : Int = 0
    @State private var date = Date()
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var nickname : String = ""
    @State private var platformId : String = ""
    @State private var phoneNumber : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showPassword : Bool = false
    @State private var device = Device.current
    
    //checks
    @State private var canUseNickname : Bool = true
    @State private var canUsePlatformID: Bool = true
    @State private var canUseEmail : Bool = true
    
    //finder
    @State private var foundPhoneNumber : Bool = false
    @State private var foundPassword : String = ""
    @State private var foundEmail : String = ""
    
    @AppStorage("userDeviceToken") var userDeviceToken : String = ""
    @AppStorage("mainTabViewSelection") var selection = 4
    @AppStorage("lastSignIn") var lastSignIn : String = ""
    @AppStorage("isNewUser") var isNewUser : Bool = false
    
    @StateObject var locationManager = LocationManager()
    @StateObject var generalStore = GeneralStore()
    
    //alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var toForgotPassword : Bool = false
    
    @State private var signout : Bool = false
    @State private var kullaniciVar : Bool = false
    
    //geo
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        ZStack{
            if kullaniciVar {
                MainTabView(signOutMainTabView: $signout)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            else  {
                OfficalDealler()
                    .overlay(Color.black.opacity(0.5))
                    .blur(radius: 7)
                    .allowsHitTesting(false)
                    .preferredColorScheme(.dark)
                    .onAppear{
                        self.toMainTabView = false
                    }
            }
            
            
            
            VStack{
                VStack{
                    if Auth.auth().currentUser == nil{
                        if self.bodySelection == 0 {
                            firstView
                        }
                        else if bodySelection == 1 {
                            bodySignInBody
                        }
                        else if bodySelection == 2 {
                            registerBody
                        }
                    }
                }
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .onAppear{
            if Auth.auth().currentUser != nil {
                authenticate()
            }
        }
        .onChange(of: signout, perform: { val in
            if val == true {
                self.kullaniciVar = false
            }
        })
        .onChange(of: Auth.auth().currentUser) { V in
            if Auth.auth().currentUser != nil {
                kullaniciVar = true
            }
            else {
                kullaniciVar = false
            }
        }
    }
    
    var firstView : some View{
        VStack{
            Image("logoWhite")
                .resizable()
                .scaledToFit()
                .frame(width: 107, height: 79)
                .padding(.bottom, 47)
            
            Text("Giriş Yap")
                .foregroundColor(.white)
                .font(.system(size: 25))
            
            Text("Hesabını yönet, Takas ara, Eşleş, Paylaş")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .fontWeight(.thin)
                .padding(.top)
            
            Button {
                self.bodySelection = 1
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.white)
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 12, height: 12)
                        
                        Text("Telefon veya Email")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    
                    if self.lastSignIn == "EmailOrPhone" {
                        HStack{
                            Spacer()
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.init(hex: "#1CC4BE"))
                                    
                                    Text("En Son")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.medium)
                                }
                                .frame(width: 60, height: 20)
                                .offset(x: 10, y: -10)
                                
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
                .frame(height: 43)
                .padding(.horizontal, 40)
                .padding(.vertical)
            }
            
            
            Button {
                handleGoogleContinue()
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.white)
                    
                    HStack{
                        
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 12, height: 12)
                        
                        
                        Text("Google ile devam et")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    
                    if self.lastSignIn == "Google" {
                        HStack{
                            Spacer()
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.init(hex: "#1CC4BE"))
                                    
                                    Text("En Son")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .fontWeight(.medium)
                                }
                                .frame(width: 60, height: 20)
                                .offset(x: 10, y: -10)
                                
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
                .frame(height: 43)
                .padding(.horizontal, 40)
                .padding(.vertical)
            }
            
            ZStack{
                
                SignInWithAppleButton(.continue) { request in
                    self.blur = true
                    let nonce = randomNonceStringForAuth()
                    currentNonce = nonce
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            
                            let apple_firstName = appleIDCredential.fullName?.givenName ?? ""
                            let apple_lastName = appleIDCredential.fullName?.familyName ?? ""
                            let apple_email = appleIDCredential.email ?? ""
                            let apple_id = appleIDCredential.user
                            
                            guard let nonce = currentNonce else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let appleIDToken = appleIDCredential.identityToken else {
                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                            }
                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                return
                            }
                            
                            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if (error != nil) {
                                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                                    // you're sending the SHA256-hashed nonce as a hex string with
                                    // your request to Apple.
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                
                                self.lastSignIn = "Apple"
                                
                                if apple_email != "" {
                                    self.blur = true
                                    let randomNick = Int.random(in: 1 ..< 99999)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        register(email: apple_email, password: "885522", firstName: apple_firstName, lastName: apple_lastName, appleId: apple_id, token: userDeviceToken, device: "\(device)", nickname: "konuk\(randomNick)", signInMethod: "Apple")
                                    }
                                    self.blur = false
                                }
                                else {
                                    self.blur = false
                                    self.toMainTabView = true
                                }
                            }
                        default:
                            break
                            
                        }
                    case .failure(let err):
                        self.blur = false
                        break
                    default:
                        break
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 43)
                .cornerRadius(25)
                .padding(.horizontal, 40)
                .padding(.vertical)
                
                if self.lastSignIn == "Apple" {
                    HStack{
                        Spacer()
                        VStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(hex: "#1CC4BE"))
                                
                                Text("En Son")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                            .frame(width: 60, height: 20)
                            .offset(x: 10, y: -10)
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 40)
                }
            }
            
        }
    }
    
    var bodySignInBody : some View {
        VStack(spacing: 16.5){
            HStack(spacing: 20){
                Button {
                    self.bodySelection = 0
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 43, height: 43)
                }
                
                
                Text("Giriş Yap")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                
                
                Spacer(minLength: 0)
                
            }
            
            
            ScrollView(showsIndicators: false){
                
                
                HStack{
                    Button {
                        self.signInSelection = 0
                        
                    } label: {
                        if self.signInSelection == 0 {
                            Text("Telefon Numarası")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                        else {
                            Text("Telefon Numarası")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.thin)
                        }
                    }
                    
                    Button {
                        self.signInSelection = 1
                        
                    } label: {
                        if self.signInSelection == 1 {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                        else {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.thin)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.bottom, 24)
                .padding(.top)
                
                VStack(spacing: 16.5){
                    //MARK: LoginScreen - Phone
                    if self.signInSelection == 0 {
                        HStack(spacing: 10){
                            Text("TR +90")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Divider()
                                .background(Color.white)
                                .frame(height: 22)
                            
                            TextField("532 XXX XX XX", text: $phoneNumber.limit(10))
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .keyboardType(.numberPad)
                                .onChange(of: phoneNumber) { val in
                                    if val.count >= 10 {
                                        findPhoneNumber(phoneNumber: val)
                                    }
                                }
                            
                        }
                        
                        Divider()
                            .background(Color.white)
                    }
                    else {
                        //MARK: LoginScreen - Mail
                        HStack(spacing: 10){
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .frame(width: 65)
                            
                            Divider()
                                .background(Color.white)
                                .frame(height: 22)
                            
                            TextField("Email", text: $email)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .colorScheme(.dark)
                                .onChange(of: email) { val in
                                    if val.count >= 10 {
                                        findEmail(emaill: val)
                                    }
                                }
                        }
                        
                        Divider()
                            .background(Color.white)
                    }
                    
                    HStack(spacing: 10){
                        Text("Şifre")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .frame(width: 65)
                        
                        Divider()
                            .background(Color.white)
                            .frame(height: 22)
                        
                        SecureField("En az 6 karakter", text: $password)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    Divider()
                        .background(Color.white)
                    
                    HStack{
                        
                        Button {
                            toForgotPassword.toggle()
                        } label: {
                            Text("Şifremi Unuttum")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .fullScreenCover(isPresented: $toForgotPassword) {
                            ForgotPasswordScreen()
                        }
                        
                        Spacer(minLength: 0)
                        
                    }
                    Button {
                        if self.signInSelection == 0 {
//
                            if self.phoneNumber == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Telefonunuz boş olamaz!"
                                self.showAlert.toggle()
                            }
                            else if self.foundPhoneNumber != true {
                                self.alertTitle = "Telefon numaranız yanlış!"
                                self.alertBody = "Telefon numarasını kontrol ettikten sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else if self.password == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Şifreniz boş olamaz!"
                                self.showAlert.toggle()
                            }
                            else if self.foundPassword != password {
                                self.alertTitle = "Şifreniz yanlış!"
                                self.alertBody = "Şifrenizi kontrol ettikten sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else {
                                Auth.auth().signIn(withEmail: foundEmail, password: foundPassword)
                                print("Giriş yapıldı")
                                bodySelection = 0
                               authenticate()
                            }
                        }
                        else {
                            if self.email == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Mailiniz boş olamaz!"
                                self.showAlert.toggle()
                            }
                            else if self.foundEmail != email {
                                self.alertTitle = "Mailiniz yanlış!"
                                self.alertBody = "Mailizini kontrol ettikten sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else if self.password == "" {
                                self.alertTitle = "Eksik Alan"
                                self.alertBody = "Şifreniz boş olamaz!"
                                self.showAlert.toggle()
                            }
                            else if self.foundPassword != password {
                                self.alertTitle = "Şifreniz yanlış!"
                                self.alertBody = "Şifrenizi kontrol ettikten sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else {
                                Auth.auth().signIn(withEmail: foundEmail, password: foundPassword)
                                print("Giriş yapıldı")
                                bodySelection = 0
                               authenticate()
                            }
                        }
                        
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(Color.init(hex: "#00CBC3"))
                            
                            Text("Giriş Yap")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(height: 43)
                    }
                    
                    HStack{
                        Text("Bir hesabın yok mu?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                        Button {
                            self.bodySelection = 2
                        } label: {
                            Text("Kayıt Ol")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                        }
                        
                    }
                    
                }
                
                Spacer(minLength: 0)
            }
            
        }.padding(30)
    }
    
    var registerBody : some View {
        VStack{
            if self.registerStep == 1 {
                register1
            }
            else if self.registerStep == 2 {
                register2
            }
            else if self.registerStep == 3 {
                register3
            }
            else if self.registerStep == 4 {
                register4
            }
            else if self.registerStep == 5 {
                register5
            }
            else if self.registerStep == 6 {
                register6
            }
        }
    }
    
    var register1 : some View {
        VStack(spacing: 15){
            VStack(alignment: .leading) {
                HStack(spacing: 20){
                    Button {
                        self.bodySelection = 0
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

                    
                    VStack(alignment: .leading, spacing: 12){
                        Text("Doğum günün ne zaman?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        
                    }
                    Spacer(minLength: 0)
                }
                Text("Yaşını hesaplamak için gerekli bilgidir")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 30)
            .padding(.top,40)
            HStack{
                Text("\(bDay)")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                
                Spacer()
                
                if self.age != 0 {
                    Text("Yaşınız \(age)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                else {
                    Text("Yaşınız \(age)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, 30)
            
            Divider()
                .background(Color.white)
                .colorScheme(.light)
                .padding(.horizontal, 30)
            
            Button {
                if self.age >= 18 {
                    self.registerStep = 2
                }
                else {
                    self.alertTitle = "Yaşınız 18 den küçük!"
                    self.alertBody = "En az 18 yaşında olmanız gerekmektedir!"
                    self.showAlert.toggle()
                }
                
                
            } label: {
                ZStack{
                    Capsule()
                        .fill(Color.init(hex: "#00CBC3"))
                    
                    Text("Devam")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                .frame(height: 43)
                .padding(.horizontal, 30)
            }
            
            Spacer()
            Spacer()
            
            DatePicker("", selection: $date, in: ...Date(),
                       displayedComponents: .date)
            .colorScheme(.dark)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding()
            .onChange(of: date) { val in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                formatter.dateFormat = "dd.MM.yyyy"
                self.bDay = formatter.string(from: val)
                calcAge(birthday: bDay)
            }
            Spacer()
        }
    }
    
    var register2 : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                Spacer()
                VStack(alignment: .leading, content: {
                    HStack(spacing: 20){
                        Button {
                            self.registerStep = self.registerStep - 1
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
                        
                            Text("Haydi seni biraz tanıyalım?")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        Spacer(minLength: 0)
                        }
                        
                    Text("Adın ve Soyadın nedir?")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                })
                .padding(.horizontal, 30)
                .padding(.top)
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Adınız", text: $firstName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal, 15)
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Soyadınız", text: $lastName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal, 15)
                    }
                    
                }
                .padding(.horizontal, 30)
                .frame(height: 45)
                
                Button {
                    if self.firstName.count < 3 {
                        self.alertTitle = "En az 3 karakter"
                        self.alertBody = "Adınızı doğru girdiğinizden emin olun!"
                        self.showAlert.toggle()
                    }
                    else if self.lastName.count < 2 {
                        self.alertTitle = "En az 2 karakter"
                        self.alertBody = "Soyadınızı doğru girdiğinizden emin olun!"
                        self.showAlert.toggle()
                    }
                    else {
                        self.registerStep = 3
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                Spacer()
            }
        }
    }
    
    var register3 : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                Spacer()
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        Button {
                            self.registerStep = self.registerStep - 1
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
                        Text("Haydi seni biraz tanıyalım?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Sana özel bir kullanıcı adın olsun")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        
                }
                .padding(.horizontal, 30)
                .padding(.top)
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack{
                        TextField("Kullanıcı adı oluştur", text: $nickname)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .onChange(of: nickname) { val in
                                if val.count > 7 {
                                    searchNickname(nickname: val)
                                }
                            }
                        
                        if self.canUseNickname && nickname.count > 7 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                        
                    }.padding(.horizontal, 15)
                }
                .frame(height: 45)
                .padding(.horizontal, 30)
                
                Button {
                    if self.nickname.count < 7 {
                        self.alertTitle = "En az 8 karakter"
                        self.alertBody = "Size daha uygun bir kullanıcı adınız olsun!"
                        self.showAlert.toggle()
                    }
                    else if self.canUseNickname == false {
                        self.alertTitle = "Var olan bir kullanıcı adı!"
                        self.alertBody = "Başka bir kullanıcı adı seçiniz."
                        self.showAlert.toggle()
                    }
                    else {
                        self.registerStep = 4
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    var register4 : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        Button {
                            self.registerStep = self.registerStep - 1
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
                        
                        Text("Peki ya hangi platform için devam edelim?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        Spacer()
                    }
                    Text("Seçeceğin platform için devam edeceğiz!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 30)
                .padding(.top)
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack(spacing: 10){
                        TextField("Platform ID", text: $platformId.limit(15))
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .onChange(of: platformId) { val in
                                if val.count > 5 {
                                    searchPlatformID(platformID: val)
                                }
                            }
                        
                        if self.canUsePlatformID && platformId.count > 5 {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                        
                        Image("BigoLive")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                            .onTapGesture {
                                self.alertTitle = "Çok yakında!"
                                self.alertBody = "Şu anda anlaşmalarımız devam etmekte. Çok yakında hizmetinizde olacaktır."
                                self.showAlert = true
                            }
                        
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 45)
                .padding(.horizontal, 30)
                
                Button {
                    if self.platformId.count < 5 {
                        self.alertTitle = "En az 6 karakter"
                        self.alertBody = "Size daha uygun bir kullanıcı adınız olsun!"
                        self.showAlert.toggle()
                    }
                    else if self.canUsePlatformID == false {
                        self.alertTitle = "Zaten kullanımda"
                        self.alertBody = "Lütfen size ait olan platform ID'nizi giriniz."
                        self.showAlert.toggle()
                    }
                    else {
                        self.registerStep = 5
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    var register5 : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                Spacer()
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        Button {
                            self.registerStep = self.registerStep - 1
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
                            Text("Mail adresin nedir?")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        Spacer()
                    }
                        
                        Text("Mail adresin ile hesabını doğrulamam için")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        
                    
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 30)
                .padding(.top)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack{
                        TextField("Mail adresin", text: $email)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .colorScheme(.dark)
                            .onChange(of: email) { val in
                                if val.contains("@") {
                                    searchEmail(email: val)
                                }
                            }
                        
                        
                        if self.canUseEmail && email.contains("@") && email.contains(".com"){
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .frame(height: 45)
                .padding(.horizontal, 30)
                
                Button {
                    if self.email == "" {
                        self.alertTitle = "Boş alan!"
                        self.alertBody = "Email oluşturmadan devam edemezsiniz"
                        self.showAlert = true
                    }
                    else if !self.email.contains("@"){
                        self.alertTitle = "Boş alan!"
                        self.alertBody = "Email adresinizi doğru girdiğinizden emin olun!"
                        self.showAlert = true
                    }
                    else if self.canUseEmail == false {
                        self.alertTitle = "Zaten var olan bir mail adresi!"
                        self.alertBody = "Email adresinizi doğru girdiğinizden emin olun!"
                        self.showAlert = true
                    }
                    else {
                        self.registerStep = 6
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    var register6 : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15){
                Spacer()
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        Button {
                            self.registerStep = self.registerStep - 1
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
                            Text("Biraz da güvenlik!")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        Spacer()
                    }
                        Text("Bir şifre oluşturalım")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 30)
                .padding(.top)

                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack{
                        if showPassword {
                            TextField("Şifre oluştur", text: $password)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                        }
                        else {
                            SecureField("Şifre oluştur", text: $password)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                        }
                        
                        Button {
                            self.showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eyes" : "eyebrow")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                }
                .frame(height: 45)
                .padding(.horizontal, 30)
                
                Button {
                    if password.count < 5 {
                        self.alertTitle = "Eksik Alan!"
                        self.alertBody = "En az 6 karakter şifre oluşturmalısın"
                        self.showAlert = true
                    }
                    else {
                        Auth.auth().createUser(withEmail: email, password: password) { res, err in
                            if err != nil {
                                print("create user error")
                                print(err!.localizedDescription)
                            }
                            else {
                                register(email: email, password: password, firstName: firstName, lastName: lastName, appleId: "", token: userDeviceToken, device: "\(Device.current)", nickname: nickname, signInMethod: "Email")
                                self.lastSignIn = "EmailOrPhone"
                            }
                        }
                    }
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.init(hex: "#00CBC3"))
                        
                        Text("Devam")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 43)
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    //funcs
    func calcAge(birthday: String){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        self.age = age!
    }
    
    func searchNickname(nickname: String){
        canUseNickname = true
        print(canUseNickname)
        let ref = Firestore.firestore()
        ref.collection("Users").getDocuments { snap, err in
            for doc in snap!.documents {
                if let nickName = doc.get("nickname") as? String {
                    if nickname == nickName {
                        self.canUseNickname = false
                        print("kullanima hazir")
                    }
                }
            }
        }
    }
    
    func searchPlatformID(platformID: String){
        canUsePlatformID = true
        print(canUsePlatformID)
        let ref = Firestore.firestore()
        ref.collection("Users").getDocuments { snap, err in
            for doc in snap!.documents {
                if let platformId = doc.get("platformID") as? String {
                    if platformId == platformID {
                        self.canUsePlatformID = false
                        print("kullanima hazir platform id ")
                    }
                }
            }
        }
    }
    
    func searchEmail(email: String){
        canUseEmail = true
        print(canUseEmail)
        let ref = Firestore.firestore()
        ref.collection("Users").getDocuments { snap, err in
            for doc in snap!.documents {
                if let emaill = doc.get("email") as? String {
                    if emaill == email {
                        self.canUseEmail = false
                        print("kullanima hazir mail ")
                    }
                }
            }
        }
    }
    
    func findPhoneNumber(phoneNumber: String){
        foundPhoneNumber = false
        self.foundPassword = ""
        let ref = Firestore.firestore()
        ref.collection("Users").getDocuments { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let phonenumber = doc.get("phoneNumber") as? String {
                        if let password = doc.get("password") as? String {
                            if let email = doc.get("email") as? String {
                                if phoneNumber == phonenumber {
                                    self.foundPhoneNumber = true
                                    self.foundPassword = password
                                    self.foundEmail = email
                                    print("phoneNumberFound")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func findEmail(emaill: String){
        foundPhoneNumber = false
        self.foundPassword = ""
        let ref = Firestore.firestore()
        ref.collection("Users").getDocuments { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let phonenumber = doc.get("phoneNumber") as? String {
                        if let password = doc.get("password") as? String {
                            if let email = doc.get("email") as? String {
                                if email == emaill {
                                    self.foundPhoneNumber = true
                                    self.foundPassword = password
                                    self.foundEmail = email
                                    print("emailfound")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, appleId: String, token: String, device: String, nickname: String, signInMethod: String){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let today = formatter.string(from: date)
        let timeStamp = Date().timeIntervalSince1970
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
            
            let ref = Firestore.firestore()
            let userData = [
                "firstName" : firstName,
                "lastName" : lastName,
                "email" : email,
                "platformID" : platformId,
                "pfImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Defulats%2FdefulatProfileImage.png?alt=media&token=402f2e36-2371-41d0-a4dc-4d9e0d790513",
                "gift" : 0,
                "birthday" : "",
                "level" : 1,
                "accountLevel" : 1,
                "gender" : "None",
                "phoneNumber" : "",
                "addres" : "",
                "refCode" : "",
                "signature" : "",
                "verify" : false,
                "myReferanceCode" : "",
                "levelPoint" : 1001,
                "selectedPlatform" : "BigoLive",
                "totalSoldDiamond" : 0,
                "application" : false,
                "today" : today,
                "block" : false,
                "city" : "",
                "town" : "",
                "plate" : 0,
                "password" : password,
                "isOwnStreamer" : false,
                "nickname" : nickname,
                "current" : "SignIn",
                "appleId" : appleId,
                "token" : userDeviceToken,
                "device" : device,
                "blockDesc" : "",
                "vipType" : "Casper",
                "isVerifiedNumber" : false,
                "agencyApplicationUserId" : "",
                "pin" : "",
                "agencyRequest" : false,
                "isSentAgencyApplication" : "",
                "countryCode" : "90",
                "townIndex" : 0,
                "cityIndex" : 0,
                "managerType" : "",
                "managerPlatform" : "BigoLive",
                "myAgencyId" : "",
                "taxApplicationId" : false,
                "remittenceLimit" : false,
                "vipPoint" : 0,
                "streamerAgencyID" : "",
                "isOnline" : true,
                "lat" : Double(0),
                "long" : Double(0),
                "accountCreatedDate" : Int(timeStamp),
                "casper" : false,
                "tcNo" : "",
                "isComplatedTax" : false,
                "signInMethod" : signInMethod,
                "vipPointTimeStamp" : "",
                "rosette" : false,
                "crown" : false
            ] as [String : Any]
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(userData)
            
            let platformData = [
                "platformId" : "",
                "platformLogo" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/unnamed.png?alt=media&token=49335882-c4d5-487c-a0ec-5d1b1dc384a1",
                "platformName" : "BigoLive"
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document("BigoLive").setData(platformData, merge: true)

            let requiredNumbers = Int.random(in: 100000000 ... 999999999)
            let cardNumber = "\(7299669)\(requiredNumbers)"
            let cardPassword = Auth.auth().currentUser!.uid
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let dayAndMonth = formatter.string(from: date)
            let expiryDate = "\(dayAndMonth).\(2027)"
            let cardData = [
                "cardNo" : cardNumber,
                "cardPassword" : cardPassword,
                "cardType" : "Casper",
                "expiryDate" : expiryDate,
                "isActivated" : false,
                "totalPrice" : 0,
                "twoFactor" : false
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document("Casper").setData(cardData, merge: true)
            
            let createStatics = [
                "Ocak" : 0,
                "Şubat" : 0,
                "Mart" : 0,
                "Nisan" : 0,
                "Mayıs" : 0,
                "Haziran" : 0,
                "Temmuz" : 0,
                "Ağustos" : 0,
                "Eylül" : 0,
                "Ekim" : 0,
                "Kasım" : 0,
                "Aralık" : 0,
            ]
            
            
            let currentYear = Date()
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let year = yearFormatter.string(from: currentYear)
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldDiamond").collection("Years").document("\(year)").setData(createStatics)
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldPrice").collection("Years").document("\(year)").setData(createStatics)
            
            let device = "\(Device.current)"
            
            let dat = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.locale = Locale(identifier: "tr_TRPOSIX")
            let cDate = dateFormatter.string(from: dat)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH.mm"
            timeFormatter.locale = Locale(identifier: "tr_TRPOSIX")
            let time = timeFormatter.string(from: dat)
            
            let data = [
                "lat" : Double(userLatitude) ?? 0,
                "long" : Double(userLongitude) ?? 0,
                "device" : device,
                "time" : time,
                "date" : cDate,
                "timeDate" : "\(date) - \(time)",
                "accepted" : 1
            ] as [String : Any]
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").addDocument(data: data)
            authenticate()
            
            self.blur = false
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error:NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Hızlı ve güvenli giriş için doğrulamayı geçmelisin"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        if success {
                            self.toMainTabView.toggle()
                            kullaniciVar = true
                            haptic(style: .light)
                        } else {
//                            self.showSensors = true
                        }
                    }
                }
                else {
//                    self.showSensors = true
                }
            })
        }
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceStringForAuth(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func handleGoogleContinue(){
        self.blur = true
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { user, error in
            if let error = error {
                print(error.localizedDescription)
                self.blur = false
              return
            }
            guard
              let authentication = user?.authentication,
              let idToken = authentication.idToken
            else {
              return
            }
            
            guard let userPF = user else {return}

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, err in
                if err != nil {
                    print(err!.localizedDescription)
                }
                else {
                    guard let user = result?.user else {
                        return
                    }
                    
                    searchEmail(email: user.email ?? "")

                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        self.lastSignIn = "Google"
                        if canUseEmail {
                            self.toMainTabView.toggle()
                            self.blur = false
                        }
                        else {
                            let randomNick = Int.random(in: 10000 ..< 99999)
                            
                            register(email: user.email ?? "", password: "885522", firstName: userPF.profile!.givenName!, lastName: userPF.profile!.familyName!, appleId: "", token: userDeviceToken, device: "\(Device.current)", nickname: "konuk\(randomNick)", signInMethod: "Google")
                            self.blur = false
                        }

                    }
                }
            }
        }
    }
}


extension View {
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return .init()}
        
        guard let root = screen.windows.first?.rootViewController else {return .init()}
        
        return root
    }
}
