//
//  PasswordChanger.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 8/23/22.
//

import SwiftUI
import FirebaseFirestore

struct PasswordChanger: View {
    @Environment(\.presentationMode) var present
    @State var dealler : String
    @StateObject var store = DeallerStore()
    @State var oldPasswrod : String = ""
    @State private var newPassword : String = ""
    @State private var newPasswordVerify : String = ""
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var toAdminLogin : Bool = false
    @AppStorage("storeNick") var storeNick : String = ""
    @AppStorage("storePassword") var storePassword : String = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    if self.oldPasswrod != "" {
                        Text("Yeni Şifreni Tanımla")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.light)
                            .padding(.leading , 5)
                    }
                    else {
                        Text("Şifre Güncelle")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.light)
                            .padding(.leading , 5)
                    }
                    
                    Spacer()
                }
                .padding()
                
                
                Text("Değişitireceğiniz şifreniz eski şifreleriniz ile aynı olmamasına dikkat ediniz. Bu Yönetim uygulamasına girişte kullanacağınız size özel şifrenizdir.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Eski Şifre", text: $oldPasswrod)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .colorScheme(.dark)
                        .padding(.horizontal)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Yeni Şifre", text: $newPassword)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .colorScheme(.dark)
                        .padding(.horizontal)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Yeni Şifre Doğrula", text: $newPasswordVerify)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .colorScheme(.dark)
                        .padding(.horizontal)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                Button {
                    if self.oldPasswrod == "" {
                        self.alertTitle = "Eksik Alan"
                        self.alertBody = "Eski şifreniz boş olamaz!"
                        self.showAlert.toggle()
                    }
                    else if self.oldPasswrod != store.password {
                        self.alertTitle = "Yanlış Şifre"
                        self.alertBody = "Eski şifrenizi doğru girmediniz!"
                        self.showAlert.toggle()
                    }
                    else if self.oldPasswrod.count != 6 {
                        self.alertTitle = "Fazla veya eksik karakter"
                        self.alertBody = "Eski şifreniz 6 karakterden oluşmalıdır!"
                        self.showAlert.toggle()
                    }
                    else if self.newPassword == "" {
                        self.alertTitle = "Eksik Alan"
                        self.alertBody = "Yeni şifreniz boş olamaz!"
                        self.showAlert.toggle()
                    }
                    else if self.newPassword.count != 6 {
                        self.alertTitle = "Fazla veya eksik karakter"
                        self.alertBody = "Eski şifreniz 6 karakterden oluşmalıdır!"
                        self.showAlert.toggle()
                    }
                    else if self.newPassword != newPasswordVerify {
                        self.alertTitle = "Yeni şifrelerinizi kontrol edin"
                        self.alertBody = "Yeni şifreniz ile doğrulama şifreniz eşleşmiyor!"
                        self.showAlert.toggle()
                    }
                    else {
                        let ref = Firestore.firestore()
                        ref.collection("Bayii").document(dealler).setData(["password" : newPassword, "isActiveSecure" : false], merge: true)
                        self.storeNick = ""
                        self.storePassword = ""
                        self.toAdminLogin.toggle()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(red: 65 / 255, green: 139 / 255, blue: 132 / 255))
                        
                        Text("Şifremi Güncelle")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                }

                
                Spacer(minLength: 0)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .fullScreenCover(isPresented: $toAdminLogin) {
            AdminLogin(alertTitle: "Şifreniz değiştirildi", alertBody: "Lütfen tekrar giriş yapınız", showAlert: true)
        }
    }
}
