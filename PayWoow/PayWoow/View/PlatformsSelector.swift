//
//  Platforms.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/14/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct PlatformsSelector: View {
    @StateObject var addedPlatformStore = AddedPlatformStore()
    @StateObject var allPlatforms = PlatformStore()
    @StateObject var userStore = UserInfoStore()
    @AppStorage("usingPlatform") var usingPlatformPlaceholder : String = "BigoLive"
    @State private var myPlatforms : [String] = []
    @State private var showPlatformSelectedError = false
    @State private var showIdError = false
    @State private var selectedPlatform = ""
    @State private var selectedPlatformId : String = ""
    @State private var search = ""
    @State private var showSearch = false
    
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("My Using Platform")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    Button {
                        self.showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                    }

                }
                .padding(.horizontal)
                
                if self.showSearch {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        HStack{
                            
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 20)
                            
                            TextField("Search Platform", text: $search)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding(.horizontal)
                                .colorScheme(.dark)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                }

                ScrollView(showsIndicators: false){
                    if self.showSearch == false {
                        ForEach(self.addedPlatformStore.platforms){ item in
                            AddedPlatformContent(platformId: item.platformId, platformLogo: item.platformLogo, platformName: item.platformName)
                                .onTapGesture {
                                    self.showPlatformSelectedError.toggle()
                                    self.selectedPlatform = item.platformName
                                    self.selectedPlatformId = item.platformId
                                }
                                .onAppear{
                                    self.myPlatforms.append(item.platformName)
                                }
                                .contextMenu{
                                    if self.addedPlatformStore.platforms.count > 1 {
                                        Button {
                                            let ref = Firestore.firestore()
                                            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document(item.platformName).delete()
                                        } label: {
                                            Text("Bu platformu kaldır")
                                        }
                                    }

                                }
                        
                        }
                    }
                    else {
                        ForEach(self.allPlatforms.platforms){ item in
                            if myPlatforms.contains(where: {$0 == item.platformName}) {
                               
                            } else if item.platformName.contains(search) {
                                PlatformContent(platformDocId: item.platformDocId, platformLogo: item.platformImage, platformName: item.platformName, globalUsers: item.globalUsers, isActive: item.isActive)
                                    .onTapGesture {
                                        if item.isActive {
                                            print(item.isActive)
                                            let ref = Firestore.firestore()
                                            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document(item.platformDocId).setData([
                                                "platformId" : "",
                                                "platformLogo" : item.platformImage,
                                                "platformName" : item.platformName])
                                            self.showSearch = false
                                        }
                                        else {
                                            self.alertTitle = "Maalesef"
                                            self.alertBody = "Şu anlık toplantılarımız devam ediyor. Kısa süre sonra aktif olacaktır!"
                                            self.showAlert.toggle()
                                        }
                                    }
                            }
                                
                                
                        }
                    }
                    
                    
                   
                    
                    VStack(spacing: 10){
                        Text("The platform you choose in this panel; All transactions you make through the Paywoow application will be processed for that platform. Make sure you choose the correct platform when uploading.")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 15))
                        
                        Text("Paywoow makes your in-app purchases to the chosen platform. Statistics, trade, top 50, referral code and recommendations.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
            }
            
            if self.showPlatformSelectedError == true {

                ZStack{
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showPlatformSelectedError.toggle()
                        }

                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.init(red: 56 / 255, green: 56 / 255, blue: 56 / 255))

                            VStack{
                                Text("Are you sure?")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(10)


                                Text("The platform you choose in this panel; \nAll transactions you will make through the Paywoow application will be processed for that platform.\nMake sure you choose the right platform when you upload,\nPaywoow will make your in-app purchases on the selected platform. Statistics, trade, top 50, referral code and recommendations.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .padding(10)
                                
                                Divider()
                                    .background(Color.init(red: 112 / 255 , green: 112 / 255, blue: 112 / 255))

                                Button {
                                    let ref = Firestore.firestore()
                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["selectedPlatform" : self.selectedPlatform, "platformID" : selectedPlatformId], merge: true)
                                    self.showPlatformSelectedError.toggle()
                                    self.usingPlatformPlaceholder = selectedPlatform
                                } label: {
                                    Text("Continue")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 10)

                                Divider()
                                    .background(Color.init(red: 112 / 255 , green: 112 / 255, blue: 112 / 255))

                                Button {
                                    self.showPlatformSelectedError.toggle()
                                } label: {
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 10)

                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 350)
                    }
                }
            }
        }
    }
}
