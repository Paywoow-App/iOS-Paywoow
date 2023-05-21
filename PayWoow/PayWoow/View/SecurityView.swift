//
//  SecurityView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/15/22.
//

import SwiftUI
import Firebase

struct SecurityView : View {
    @StateObject var userStore = UserInfoStore()
    @State private var toPasswordChange = false
    @State private var toSignInHistory = false
    @State private var toPinChanger = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body : some View {
        ZStack{
            LinearGradient(colors: [Color.init(hex: "#343A3A"), Color.init(hex: "#101010")], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Account Security")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading){
                        Text("You can make security settings for your account via this screen.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal)
                        
                        Button {
                            if self.userStore.signInMethod == "Apple" || self.userStore.signInMethod == "Google"{
                                self.alertTitle = "Şifre değiştirebilmeniz için sadece email ile kayıt yapmış olmalısınız"
                                self.showAlert.toggle()
                            }
                            else {
                                self.toPasswordChange.toggle()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack(spacing: 10){
                                    Image(systemName: "key")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .regular))
                                        .frame(width: 25, height: 25)
                                    
                                    Text("Change Password")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }
                        .popover(isPresented: $toPasswordChange){
                            PasswordChanger()
                        }
                        
                        Button {
                            if self.userStore.signInMethod == "Apple" || self.userStore.signInMethod == "Google"{
                                self.alertTitle = "Şifre değiştirebilmeniz için sadece email ile kayıt yaomış olmalısınız"
                                self.showAlert.toggle()
                            }
                            else {
                                self.toPinChanger.toggle()
                            }
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack(spacing: 10){
                                    Image(systemName: "number.circle")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .regular))
                                        .frame(width: 25, height: 25)
                                    
                                    if self.userStore.pin != "" {
                                        Text("Change Pin Code")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .fontWeight(.medium)
                                    }
                                    else {
                                        Text("Create Pin Code")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                            .fontWeight(.medium)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }
                        .popover(isPresented: $toPinChanger){
                            PinChanger()
                        }
                       
                        Button {
                            self.toSignInHistory.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack(spacing: 10){
                                    Image(systemName: "lock.rotation")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .regular))
                                        .frame(width: 25, height: 25)
                                    
                                    Text("Sign In History")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }
                        .popover(isPresented: $toSignInHistory){
                            SignInHistory()
                        }

                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button {
                self.showAlert = false
            } label: {
                Text("Tamam")
            }

        }
    }
}

