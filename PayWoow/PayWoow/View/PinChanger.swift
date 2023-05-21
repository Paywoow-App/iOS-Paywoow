//
//  PinChanger.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/18/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct PinChanger : View {
    @Environment(\.presentationMode) var present
    @StateObject var userStore = UserInfoStore()
    @State private var oldPin : String = ""
    @State private var newPin : String = ""
    @State private var pinVerify : String = ""
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var showOlPin : Bool = false
    var body : some View  {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Text("Create PIN")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    
                    Text("Your pin must be at least 8 characters and consist of numbers.")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    if self.showOlPin {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            SecureField("Current Pin", text: $oldPin)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                    }
                        
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        SecureField("New Pin", text: $newPin)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .colorScheme(.dark)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        SecureField("New Pin Verify", text: $pinVerify)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .colorScheme(.dark)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    Button {
                        if self.showOlPin {
                            if oldPin == "" {
                                self.alertTitle = "Enter the old pin"
                                self.alertBody = "Please fill the old password field"
                                self.showAlert.toggle()
                            }
                            else if self.newPin == "" {
                                self.alertTitle = "Enter the new pin"
                                self.alertBody = "Please fill the new password field"
                                self.showAlert.toggle()
                            }
                            else if self.newPin.count != 6 {
                                self.alertTitle = "Only 6 digit number"
                                self.alertBody = "You can create only 6 digit pin code"
                                self.showAlert.toggle()
                            }
                            else if self.pinVerify == "" {
                                self.alertTitle = "Enter the new pin verify code"
                                self.alertBody = "Please fill the new password verify field"
                                self.showAlert.toggle()
                            }
                            else if self.pinVerify != newPin {
                                self.alertTitle = "New pin codes not match"
                                self.alertBody = "Please check the new pin code and verify pin code"
                                self.showAlert.toggle()
                            }
                            else {
                                let ref = Firestore.firestore()
                                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["pin" : newPin], merge: true)
                                sendPushNotify(title: "Tebrikler", body: "Yeni pin'inizi güncellediniz!", userToken: userStore.token, sound: "pay.mp3")
                                self.present.wrappedValue.dismiss()
                            }
                        }
                        else {

                            if self.newPin == "" {
                                self.alertTitle = "Enter the new pin"
                                self.alertBody = "Please fill the new password field"
                                self.showAlert.toggle()
                            }
                            else if self.newPin.count != 6 {
                                self.alertTitle = "Only 6 digit number"
                                self.alertBody = "You can create only 6 digit pin code"
                                self.showAlert.toggle()
                            }
                            else if self.pinVerify == "" {
                                self.alertTitle = "Enter the new pin verify code"
                                self.alertBody = "Please fill the new password verify field"
                                self.showAlert.toggle()
                            }
                            else if self.pinVerify != newPin {
                                self.alertTitle = "New pin codes not match"
                                self.alertBody = "Please check the new pin code and verify pin code"
                                self.showAlert.toggle()
                            }
                            else {
                                let ref = Firestore.firestore()
                                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["pin" : newPin], merge: true)
                                sendPushNotify(title: "Tebrikler", body: "Yeni pin'inizi oluşturdunuz!", userToken: userStore.token, sound: "pay.mp3")
                                self.present.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(hex: "#1CC4BE"))
                            
                            Text("Set New Pin")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                        .frame(height: 50)
                        .padding()
                    }
                    

                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                if userStore.pin == "" {
                    showOlPin = false
                }
                else {
                    showOlPin = true
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        
    }
    
    func sendCode(code: String, number: String, header: String, usercode: String, password: String){
        guard let url = URL(string: "https://api.netgsm.com.tr/sms/send/otp") else {return}
        var xml = ""
        if number.first == "5" {
            xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Bu iki faktörlü doğrulama kodunu kimse ile paylaşmayınız. Verification Code :  \(code)]]></msg><no>0\(number)</no></body></mainbody>"
        }
        else {
            xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Bu iki faktörlü doğrulama kodunu kimse ile paylaşmayınız. Verification Code :  \(code)]]></msg><no>\(number)</no></body></mainbody>"
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = xml.data(using: .utf8)
        request.setValue("text/xml", forHTTPHeaderField:  "Content-Type")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { dat, res, err in
            
            addCountNetGSM()
            
        }.resume()
        
        
    }
}
