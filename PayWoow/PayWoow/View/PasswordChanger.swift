//
//  PasswordChanger.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/22/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct PasswordChanger : View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var netgsm = NETGSMStore()
    @State private var oldPassword : String = ""
    @State private var newPassword : String = ""
    @State private var newPasswordAgain : String = ""
    
    //External
    @Environment(\.presentationMode) var present
    @State private var title : String = ""
    @State private var message : String = ""
    @State private var showAlert = false
    @State private var tempCode = Int.random(in: 1000 ... 9999)
    @State private var openBlur = false
    @State private var inputCode : String = ""
    @State private var sendCode : Bool = false
    @State private var showIndicator = false
    @State private var toSignIn = false
    @State private var askPassword : Bool = false
    @State private var deletePasssword : String = ""
    var body : some View  {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Text("Change your password to secure your account")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    
                    Text("Your password must be at least 8 characters and consist of numbers, letters and special characters.\n\nApart from these, you will be logged out of all sessions, so people trying to log in will no longer be able to access their account.")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Current Password", text: $oldPassword)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("New Password", text: $newPassword)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("New Password, again", text: $newPasswordAgain)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    
                    Button {
                        if self.userStore.verifyPassword == self.oldPassword && self.newPassword == self.newPasswordAgain && self.newPassword.count >= 8{
                            let ref = Firestore.firestore()
                            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["password" : self.newPassword], merge: true)
                            
                            sendChangedPassword(changedPassword: newPasswordAgain, number: userStore.phoneNumber, header: netgsm.header, usercode: netgsm.usercode, password: netgsm.password)
                            self.present.wrappedValue.dismiss()
                        }
                        else {
                            if self.newPassword.count <= 8 {
                                self.title = "Sorry"
                                self.message = "Yeni şifreniz en az 8 haneli olmalıdır!"
                                self.showAlert = true
                            }
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(hex: "#1CC4BE"))
                            
                            Text("Change Password")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                        .frame(height: 50)
                        .padding()
                    }
                    
                    Text("Your account information will never be shared with anyone. Safety is our priority. If you want to delete your account, you can use the Delete My Account button at the bottom.")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding([.top, .horizontal])
                        .padding(.bottom, 40)
                    
                    Button {
                        if self.userStore.phoneNumber != "" {
                            self.openBlur = true
                        }
                        else {
                            self.title = "Uyarı!"
                            self.message = "Telefon numaranı doğrulamadan hesabını silemezsin!"
                            self.showAlert.toggle()
                        }
                    } label: {
                        Text("Delete My Account")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    .padding()
                    
                    
                }
            }.blur(radius: openBlur ? 3 : 0)
                .onTapGesture {
                    self.openBlur = false
                    self.sendCode = false
                    self.inputCode = ""
                    self.tempCode = Int.random(in: 1000 ... 9999)
                }
            
            if self.openBlur {
                verificator
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(title), message: Text(message), dismissButton: Alert.Button.default(Text("Ok")))
        }
        
    }
    
    var verificator : some View {
        VStack(spacing: 15){
            Text("We need to deleting the your account")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .bold()
                .padding(.top)
            
            Text("We sent you an verification code. When you enter this passcode, we will delete the your account")
                .foregroundColor(.gray)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if self.sendCode {
                TextField("Code", text: $inputCode)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .preferredColorScheme(.light)
                    .keyboardType(.numberPad)
                    .frame(width: 200)
                    .onChange(of: inputCode) { val in
                        if val != "" {
                            if Int(val)! == self.tempCode {
                                self.askPassword = true
                            }
                            else {
                                self.askPassword = false
                            }
                        }
                    }
                
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.25)
                
                if self.askPassword {
                    
                    TextField("Enter your password", text: $deletePasssword)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .frame(width: 200)
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.25)
                }
            }
            
            
            
            if self.sendCode == true && self.tempCode == Int(inputCode) ?? 0 && self.deletePasssword == self.userStore.verifyPassword {
                Button {
                    if "\(tempCode)" != inputCode {
                        self.title = "Incorrect Code"
                        self.message = "Please check the code again"
                        self.showAlert = true
                    }
                    else {
                        if self.userStore.isAgency {
                            self.title = "Sorry"
                            self.message = "You are an agency. so you cannot delete your account. If you want delete the this account stil, Contact us please."
                            self.showAlert = true
                        }
                        else {
                            do {
                                
                                Auth.auth().signIn(withEmail: userStore.email, password: userStore.verifyPassword)
                                
                                let user = Auth.auth().currentUser

                                user?.delete { error in
                                  if error != nil {
                                      self.title = "Sorry"
                                      self.message = "We cannot delete your account. Try again later please!"
                                      self.showAlert = true
                                      
                                  } else {
                                      
                                          self.showIndicator = true
                                          let ref = Firestore.firestore()
                                          ref.collection("Users").document(Auth.auth().currentUser!.uid).delete()
                                          ref.collection("Devils").document(Auth.auth().currentUser!.uid).delete()
                                          ref.collection("Angels").document(Auth.auth().currentUser!.uid).delete()
                                          ref.collection("Reference").document(userStore.referanceCode).delete()
                                          ref.collection("Suggestions").document(Auth.auth().currentUser!.uid).delete()
                                          ref.collection("SupporterDeallerApplications").document(Auth.auth().currentUser!.uid).delete()
                                          ref.collection("StreamerApplications").document(Auth.auth().currentUser!.uid).delete()
                                          if self.userStore.accountLevel == 0 {
                                              let trasfer = [
                                                  "userId" : Auth.auth().currentUser!.uid,
                                                  "isDeletedAccount" : true
                                              ] as [String : Any]
                                              ref.collection("Groups").document(self.userStore.selectedPlatform).collection(userStore.agencyName).document("GroupInfo").collection("OldUsers").document(Auth.auth().currentUser!.uid).setData(trasfer, merge: true)
                                              
                                              ref.collection("Groups").document(self.userStore.selectedPlatform).collection(userStore.agencyName).document("GroupInfo").collection("Users").document(Auth.auth().currentUser!.uid).delete()
                                          }
                                          self.showIndicator = false
                                          self.toSignIn = true
                                      
                                  }
                                }
                                
                                
                            }
                            catch {
                                
                            }
                            
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(hex: "#1CC4BE"))
                        
                        Text("Delete Account")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                    }
                    .frame(height: 50)
                }
                .padding()
            }
            else {
                Button {
                    self.sendCode = true
                    sendCode(code: "\(tempCode)", number: userStore.phoneNumber, header: netgsm.header, usercode: netgsm.usercode, password: netgsm.password)
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black)
                        
                        Text("Send Code")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                    }
                    .frame(height: 50)
                }
                .padding()
            }
            
        }
        .background(Color.white)
        .cornerRadius(8)
        .blur(radius: showIndicator ? 3 : 0)
        .overlay{
            if self.showIndicator {
                ProgressView()
                    .colorScheme(.dark)
                    .scaleEffect(2)
            }
        }
        .padding(.horizontal, 20)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(title), message: Text(message), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .fullScreenCover(isPresented: $toSignIn) {
            SignIn()
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
    
    
    func sendChangedPassword(changedPassword: String, number: String, header: String, usercode: String, password: String){
        guard let url = URL(string: "https://api.netgsm.com.tr/sms/send/otp") else {return}
        var xml = ""
        if number.first == "5" {
            xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Tebrikler! Şifreniz değiştirildi. Yeni Şifreniz :  \(changedPassword)]]></msg><no>0\(number)</no></body></mainbody>"
        }
        else {
            xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Tebrikler! Şifreniz değiştirildi. Yeni Şifreniz :  \(changedPassword)]]></msg><no>0\(number)</no></body></mainbody>"
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
