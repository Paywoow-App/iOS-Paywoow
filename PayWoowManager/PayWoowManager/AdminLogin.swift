//
//  AdminLogin.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/19/21.
//

import SwiftUI
import LocalAuthentication
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AdminLogin: View {
    @State private var selection = true
    @State var alertTitle : String = ""
    @State var alertBody : String = ""
    @State var showAlert = false
    @StateObject var store = DeallerStore()
    @StateObject var netgsm = NETGSMStore()
    @State var bayiiId : String = ""
    @State var password : String = ""
    @State var image : String = ""
    @State private var toPanel = false
    @AppStorage("storeNick") var storeNick : String = "Nil"
    @AppStorage("storePassword") var storePassword : String = "Nil"
    @State private var isActiveSecureCode = ""
    @StateObject var userStore = UserStore()
    @State var showingAlert : Bool = false
    @State var codeText = ""
    @StateObject var authManager = FirebaseAuthManager()
    @State var phoneNumber: String = ""
    
    @State private var callbackPassword : String = ""
    @State private var callbackPhoneNumber : String = ""
    
    @State var value = true

    
    var code = ""
    
    init(alertTitle: String = "",
         alertBody: String = "",
         showAlert: Bool = false) {
        self.alertTitle = alertTitle
        self.alertBody = alertBody
        self.showAlert = showAlert
        
        self.code = UserDefaults.standard.string(forKey: "code") ?? ""
        
    }
    
    func checkUserPhone(bayiName: String) {
        Firestore.firestore().collection("Bayii").document(bayiName).getDocument { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let phoneNumber = snap?.get("phoneNumber") as! String
            print("BU TELEFON \(phoneNumber)")
            self.phoneNumber = phoneNumber
        }
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        Spacer()
                        ZStack{
                            Image("logoWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .offset(y: -50)
                        }
                        .padding(.top, 60)
                        
                        Text("Hoş Geldiniz")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .padding(.top, 10)
                        
                        TextField("Bayi Id", text: $bayiiId)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal, 30)
                            .colorScheme(.dark)
                            .onChange(of: bayiiId) { val in
                                getDeallerData(bayiiID: val)
                            }
                        
                        Divider()
                            .background(Color.white)
                            .padding(.horizontal, 30)
                        
                        SecureField("Şifre", text: $password)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal, 30)
                            .colorScheme(.dark)
                        
                        Divider()
                            .background(Color.white)
                            .padding(.horizontal, 30)
                        
                        Button {
                            if self.bayiiId == "" {
                                self.alertTitle = "Bayi ID Boş"
                                self.alertBody = "Lütfen Bayi ID değerini doldurduktan sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else if self.password == "" {
                                self.alertTitle = "Şifre Boş"
                                self.alertBody = "Lütfen Şifre değerini doldurduktan sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else if password != callbackPassword{
                                self.alertTitle = "Şifren Yanlış"
                                self.alertBody = "Şifrenizi kontrol ettikten sonra tekrar deneyiniz"
                                self.showAlert.toggle()
                            }
                            else {
                                self.showingAlert.toggle()
                                checkUserPhone(bayiName: bayiiId)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    authManager.phoneAuther(phoneNumber: phoneNumber)
                                }
                                //                                self.toPanel.toggle()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.init(hex: "#009D97"))
                                
                                Text("Giriş Yap")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            .frame(height: 40)
                            .padding(.horizontal, 30)
                            
                        }
                        
                        
                        Button {
                            let randomPassword = Int.random(in: 100000 ... 999999)
                            sendCode(code: "\(randomPassword)", number: store.phoneNumber, header: netgsm.header, usercode: netgsm.usercode, password: netgsm.password)
                            let ref = Firestore.firestore()
                            ref.collection("Bayii").document(bayiiId).setData(["password" : "\(randomPassword)", "isActiveSecure" : true], merge: true)
                            let first3 = "\(store.phoneNumber[0..<3])"
                            let last2 = "\(store.phoneNumber[10..<12])"
                            self.alertTitle = "Şifrenizi Gönderdim!"
                            self.alertBody = "Yeni şifrenizi \(first3) *** **\(last2) numaranıza gönderildi! Bu şifre ile giriş yapabilirsiniz."
                            self.showAlert.toggle()
                            self.isActiveSecureCode = "\(randomPassword)"
                        } label: {
                            Text("Şifreni mi unuttun?")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                }
            }
            .overlay(content: {
                if showingAlert {
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color.black)
                        VStack(alignment: .center,spacing: 30) {
                            Text("Güvenlik için telefenunuza gelen SMS KODU alana giriniz")
                                .foregroundColor(.white)
                                .font(.callout)
                                .multilineTextAlignment(.center)
                            TextField("", text: $authManager.otpCode.limit(6))
                                .tint(.white)
                                .keyboardType(.numberPad)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .frame(width: 120, height: 36)
                                .background {  Color.gray.cornerRadius(6).padding(.horizontal).frame(width: 230, height: 36)}
                                .multilineTextAlignment(.center)
                                .overlay {
                                    if value {
                                        Color.white.mask {
                                            Text("SMS CODE")
                                        }
                                        .onTapGesture {
                                            value = false
                                        }
                                    }
                                }
                                .onChange(of: authManager.otpCode) { newValue in
                                    if newValue.count > 0 {
                                        value = false
                                    }
                                }
                            HStack {
                                Spacer()
                                Button("İptal") {
                                    showingAlert.toggle()
                                }
                                .foregroundColor(.white)
                                Spacer()
                                Button("Giriş") {
                                    authManager.checkTrueOTP()
                                    UserDefaults.standard.set(authManager.otpCode, forKey: "code")
                                }
                                .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 267, height: 231)
                }
            })
            
        }
        .onAppear {

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .fullScreenCover(isPresented: $authManager.isSignedIn) {
            MainTabView(dealler: self.bayiiId, oldPassword: isActiveSecureCode)
                .onAppear {
                    self.storeNick = bayiiId
                    self.storePassword = password
                }
                .environmentObject(userStore)

        }
        .onAppear {
            if self.storeNick.count > 6 {
                authenticate()
            }
            print("PayWoowManagerSystem: isHave Before twofactor \(self.code == "" ? false : true)")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error:NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Güvenli bir şekilde giriş yapmak için buna ihtiyacım var"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        if success {
                            authManager.isSignedIn.toggle()
                        } else {
                            
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        print("Authentication was error")
                    }
                }
            })
        }else {
            print("isUnluck")
            
        }
    }
    
    
    
    func getDeallerData(bayiiID: String){
        if bayiiID != "" {
            let ref = Firestore.firestore()
            ref.collection("Bayii").document(bayiiId).addSnapshotListener { doc, err in
                if err == nil {
                    if let phoneNumber = doc?.get("phoneNumber") as? String {
                        if let password = doc?.get("password") as? String {
                            self.callbackPhoneNumber = phoneNumber
                            self.callbackPassword = password
                        }
                    }
                }
            }
        }
    }
}

func haptic(style: UIImpactFeedbackGenerator.FeedbackStyle){
    let impactMed = UIImpactFeedbackGenerator(style: style)
    impactMed.impactOccurred()
}


func sendCode(code: String, number: String, header: String, usercode: String, password: String){
    guard let url = URL(string: "https://api.netgsm.com.tr/sms/send/otp") else {return}
    var xml = ""
    if number.first == "5" {
        xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Lütfen şifrenizi kimse ile paylaşmayınız! Yeni Şifreniz : \(code)]]></msg><no>0\(number)</no></body></mainbody>"
    }
    else {
        xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Lütfen Şifrenizi kimse ile paylaşmayınız! Yeni Şifreniz : \(code)]]></msg><no>\(number)</no></body></mainbody>"
    }
    
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = xml.data(using: .utf8)
    request.setValue("text/xml", forHTTPHeaderField:  "Content-Type")
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { dat, res, err in
        print(String(data: dat!, encoding: .utf8)!)
        
        if err == nil, let data = dat, let response = res as? HTTPURLResponse {
            print("statusCode: \(response.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "")
        } else {
            print("Status code 404")
        }
        
    }.resume()
    
    
}


extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}


extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

import SwiftUI
import Firebase

class FirebaseAuthManager: ObservableObject {
    @Published var VERIFICATION_ID: String = ""
    @Published var otpCode: String = ""
    @Published var isSignedIn = false
    
   
    func phoneAuther(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verifyID, error in
            if let error = error {
                print("PayWoowManagerSystem: PhoneAuth \(error.localizedDescription)")
            }
            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
            guard let verificationID = verifyID else { return }
            
            self.VERIFICATION_ID = verificationID
            
        }
    }
    
    func checkTrueOTP() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: VERIFICATION_ID, verificationCode: self.otpCode)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.isSignedIn = true
            }
        }
    }
}

extension Binding where Value == String {
    
    /// Set doc
    func limit(_ lenght: Int) -> Self {
        if self.wrappedValue.count > lenght {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(lenght))
            }
        }
        return self
    }
    
}
