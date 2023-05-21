//
//  ForgotPasswordScreen.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/16/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordScreen: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @State private var email : String = ""
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
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
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Şifremi Unuttum")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 25){
                        Image("forgotpassword")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 40)
                        
                        Text("Aşağıda dolduracağınız mail adresinize bir şifre sıfırlama linki göndereceğiz")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Email Adresiniz", text: $email)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        Button {
                            Auth.auth().sendPasswordReset(withEmail: email) { err in
                                if err != nil {
                                    print(err!.localizedDescription)
                                    if err!.localizedDescription == "The email address is badly formatted." {
                                        self.alertTitle = "Link Gönderilemedi"
                                        self.alertBody = "Email adresiniz geçersiz bir formattadır"
                                        self.showAlert.toggle()
                                    }
                                    else if err!.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                                        self.alertTitle = "Link Gönderilemedi"
                                        self.alertBody = "Bu email adresi ile kayıtlı bir kullanıcı yoktur!"
                                        self.showAlert.toggle()
                                    }
                                }
                                else {
                                    self.present.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(hex: "#00CBC3"))
                                
                                Text("Şifreni Sıfırla")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            .frame(height: 43)
                            .padding(.horizontal)
                        }

                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
}

