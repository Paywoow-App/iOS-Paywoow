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
    
    @State private var callbackPassword : String = ""
    @State private var callbackPhoneNumber : String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        ZStack{

                            Image("logoWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .offset(y: -50)

                            LottieView(name: "people", loopMode: .loop)
                                .frame(height: 200)
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
                                self.storeNick = bayiiId
                                self.toPanel.toggle()
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
                    }
                }
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .fullScreenCover(isPresented: $toPanel) {
            MainTabView(dealler: self.bayiiId, oldPassword: isActiveSecureCode)
        }
        .onAppear{
            if self.storeNick.count > 6 {
                authenticate()
            }
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
                            self.toPanel.toggle()
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
