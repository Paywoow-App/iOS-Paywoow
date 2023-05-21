//
//  ManagerProfile.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct ManagerProfile: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @State private var toAccountManager : Bool = false
    @State private var toSecurity : Bool = false
    @State private var toSugestion : Bool = false
    @State private var toAgencyRequest : Bool = false
    
    @State private var alertTitle : String = ""
    @State private var alertMessage : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 15){
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("My Profile")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    
                    Spacer(minLength: 0)
                    
                    Text(userStore.managerPlatform)
                        .foregroundColor(.white)
                        .font(.title3)
                    
                    Image(userStore.managerPlatform)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(8)
                        .padding(.vertical)
                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    WebImage(url: URL(string: userStore.pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 160, height: 160)
                    
                    Text("\(userStore.firstName) \(userStore.lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .fontWeight(.medium)
                        .padding(.top, 5)
                    
                    Text("\(userStore.managerType)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Button {
                        self.toAccountManager.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                Text("Hesap Yönetimi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    }
                    
                    
                    Button {
                        self.toAgencyRequest.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Image(systemName: "building.columns.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                Text("Ajans Başvuruları")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    }
                    
                    
                    Button {
                        self.toSecurity.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Image(systemName: "shield")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                Text("Güvenlik")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    }
                    
                    Button {
                        self.toSugestion.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                Text("Bildir")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    }
                }

            }
        }
        .alert("Çıkış Yapmak Mı İstiyorsun", isPresented: $showAlert, actions: {
            Button {
                do {
                    try! Auth.auth().signOut()
                    self.present.wrappedValue.dismiss()
                }
                catch {
                    print("User cant sign out")
                }
            } label: {
                Text("Çıkış Yap")
            }

        })
        .popover(isPresented: $toSecurity) {
            SecurityView()
        }
        .fullScreenCover(isPresented: $toAgencyRequest) {
            ManagerAgencyRequest()
        }
        .popover(isPresented: $toSugestion) {
            Feedback()
        }
        .popover(isPresented: $toAccountManager) {
            AccountManagment(signOutBlur: .constant(false))
            
        }
    }
}
