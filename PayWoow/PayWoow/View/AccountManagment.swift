//
//  AccountManagment.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PencilKit

struct AccountManagment: View {
    @Environment(\.presentationMode) var present
    @AppStorage("notfiy") var notify : String = ""
    @AppStorage("email") var storeEmail : String = ""
    @StateObject var userStore = UserInfoStore()
    @AppStorage("usingPlatform") var usingPlatformPlaceholder : String = "BigoLive"
    @AppStorage("verifyEmail") var verifyEmail : String = ""
    @AppStorage("verifyPassword") var verifyPassword : String = ""
    @AppStorage("netgsmNumber") var netgsm_saved_phoneNumber = ""
    @Binding var signOutBlur : Bool
    
    @State private var personalInfo = false
    @State private var notifications = false
    @State private var usingPlatform = false
    @State private var verifyRequest = false
    @State private var languege = false
    @State private var accountBinding = false
    @State private var ads = false
    @State private var help = false
    @State private var suggestion = false
    @State private var apply = false
    @State private var logout = false
    @State private var askToUser = false
    @State private var accountType = false
    @State private var toFAQ = false
    @State private var toSecurity = false
    @State private var blur = false
    
    @State private var currentDate : String = ""
    @State private var currentLanguege = Locale.autoupdatingCurrent.languageCode
    @State private var signatureImage = UIImage()
    @State private var selectedIDCard = UIImage()
    @State private var openIDShot = false
    @State private var showVerifyAlert = false
    @State private var showVerifyIndicator = false
    @State private var showAdsAlert = false
    @State private var accountConfirmation = false
    @State private var openSignEditor : Bool = false
    @State private var canvasView = PKCanvasView()
    @State private var toRequestGiftScreen : Bool = false
    let imgRect = CGRect(x: 0, y: 0, width: 300.0, height: 300.0)
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
                    
                    Text("Acccount Settings")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false){
                    Group{
                        Button {
                            self.personalInfo.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "person")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Personal Information")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "bell")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                
                                
                                Text("Notifications")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                
                                Spacer()
                                
                                Toggle("", isOn: $notifications)
                                    .onChange(of: notifications) { value in
                                        if self.notifications == true {
                                            self.notify = "true"
                                        }
                                        else {
                                            self.notify = "false"
                                        }
                                    }
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        
                        Button {
                            self.usingPlatform.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "rectangle.on.rectangle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Using Platform")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                    
                                    Text(usingPlatformPlaceholder)
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        
                        if self.userStore.verify != true {
                            if self.selectedIDCard == UIImage() || self.signatureImage == UIImage() {
                                
                                    Button {
                                        
                                        if self.signatureImage != UIImage() {
                                            self.openIDShot.toggle()
                                            
                                        } else {
                                            self.openSignEditor.toggle()
                                        }
                                        
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.2))
                                            
                                            
                                            HStack{
                                                Image(systemName: "checkmark.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.white)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Account Verification")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 18))
                                                    .colorScheme(.dark)
                                                
                                                Spacer(minLength: 0)
                                                
                                                Text("Non-Verified")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 15))
                                                
                                                Image(systemName: "exclamationmark.triangle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.red)
                                                    .frame(width: 20, height: 20)
                                            
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                                    }
                            }
                            
                            else {
                                Button {
                                    verifyAccount1()
                                    self.showVerifyIndicator.toggle()
                                } label: {
                                    if self.showVerifyIndicator == true {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.2))
                                            
                                            
                                            HStack{
                                                ProgressView()
                                                    .colorScheme(.dark)
                                                
                                                Text("Processing..")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 18))
                                                    .colorScheme(.dark)
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                                    }
                                    else {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.2))
                                            
                                            
                                            HStack{
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.white)
                                                    .frame(width: 20, height: 20)
                                                
                                                Text("Complate Verification")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 18))
                                                    .colorScheme(.dark)
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                                    }
                                }

                            }
                        }
                        
                        else {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                
                                HStack{
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Account Verification")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .colorScheme(.dark)
                                    
                                    Spacer()
                                    
                                    Text("Verified")
                                        .foregroundColor(.green)
                                        .font(.system(size: 15))
                                    
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.green)
                                        .frame(width: 20, height: 20)
                                
                                }
                                .padding(.horizontal)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                        }
                    }
                    
                    Group{
                        
                        Button {
                            self.toSecurity.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "shield")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    
                                    Text("Security")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
    
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }

                        Button {
                            self.languege.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                HStack{

                                    Image(systemName: "l.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)

                                    Text("Languege")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))


                                    Spacer()

                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        
                        
                        
                        Button {
                            self.accountType.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    
                                    Text("Account Type")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()

                                    if self.userStore.accountLevel == 0 {
                                        Text("Streamer")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.system(size: 15))
                                    }
                                    else if self.userStore.accountLevel == 1 {
                                        Text("Supporter")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.system(size: 15))
                                    }
                                    else if self.userStore.accountLevel == 2 {
                                        Text("Agency")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.system(size: 15))
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        
                        
                        if self.userStore.myRefeanceCode != "" {
                            Button {
                                self.ads.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    HStack{
                                        
                                        Image(systemName: "a.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                        
                                        
                                        Text("Partnership")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                            }
                            
                        }
                        
                    }
                    
                    Group{
                        
                        
                        
                        Button {
                            let mailtoString = "mailto:support@paywoow.com?subject=Desteğe ihtiyacım var! &body=Merhaba\nBen \(self.userStore.firstName) \(self.userStore.lastName)\nUserId: \(Auth.auth().currentUser!.uid)\nBigoId: \(self.userStore.bigoId)\nŞu Konuda Desteğe ihtiyacım var...".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            let mailtoUrl = URL(string: mailtoString!)!
                            if UIApplication.shared.canOpenURL(mailtoUrl) {
                                UIApplication.shared.open(mailtoUrl, options: [:])
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "headphones")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Support")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                    
                                    Text("7/24")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        
                        Button {
                            self.toFAQ.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    
                                    Text("FAQ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
                        Button {
                            self.suggestion.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "paperplane")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    
                                    Text("Suggetions")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        
//                        if self.userStore.application == false {
//                            
//                            Button {
//                                self.apply.toggle()
//                            } label: {
//                                ZStack{
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color.black.opacity(0.2))
//                                    
//                                    HStack{
//                                        
//                                        Image(systemName: "note.text")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .foregroundColor(.white)
//                                            .frame(width: 20, height: 20)
//                                        
//                                        Text("Application")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 20))
//                                        
//                                        
//                                        Spacer()
//                                    }
//                                    .padding(.horizontal)
//                                }
//                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
//                            }
//                        }
                        
                        Button {
                            self.blur = true

                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Sign Out")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                        .padding(.bottom)
                    }
                }
            }
           
            
            if self.languege == true {
                ZStack{
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.languege.toggle()
                        }
                    
                    VStack(spacing: 15){
                        Text("How can I change the app languege?")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding([.horizontal, .top])
                        
                        
                        Text("There are different steps where you can change Paywoow language due to phone updates.\n\n1. Continue to next screen\n\n2. Tap Language to select the language you want.\n\nIf there is no language setting, first go to general iPhone language settings to set your preferred language.")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                        
                
                        HStack{
                            Button {
                                self.languege.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black)
                                    
                                    Text("Cancel")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                }
                            }
                            
                            Button {
                                settingsOpener()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                    
                                    Text("Continue")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }

                        }
                        .frame(height: 40)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding()
                }

            }
            
            if self.openSignEditor == true {
                ZStack{
                    Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.openSignEditor.toggle()
                        }
                    
                    VStack{
                        
                        Text("You shold draw your signature to continue")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        PencilCanvas(canvasView: $canvasView)
                            .cornerRadius(16)
                            .colorScheme(.light)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        
                        
                        Button {
                            saveSignature()
                            self.openSignEditor.toggle()
                            self.openIDShot.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.init(red: 88 / 255, green: 186 / 255, blue: 176 / 255))
                                
                                Text("Complate")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                        }
                    }
                }
            }
        }
        .onAppear{
            if self.notify == "true" {
                self.notifications = true
            }
            else {
                self.notifications = false
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            self.currentDate = formatter.string(from: date)
            
        }
        .blur(radius: blur ? 11 : 0)
        .overlay{
            if self.blur {
                ZStack{
                    Color.white.opacity(0.00000004).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20){
                        Text("Bu hesaptan çıkış yapmak mı\nistiyorsun?")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.all)
                        
                        HStack{
                            
                            Button {
                                self.blur = false
                            } label: {
                                Text("Hayır")
                                    .foregroundColor(.red)
                                    .font(.system(size: 15))
                            }
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                self.present.wrappedValue.dismiss()
                                Task {
                                    do {
                                      try! Auth.auth().signOut()
                                        self.signOutBlur = true
                                    }
                                    catch {}
                                }
                            } label: {
                                Text("Evet")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .bold()
                            }
                        }.padding(.bottom)
                            .padding(.horizontal, 50)

                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        
        
        .fullScreenCover(isPresented: $logout, content: {
            SignIn()
        })
        .fullScreenCover(isPresented: $openIDShot, onDismiss: {
            verifyAccount1()
            self.showVerifyIndicator.toggle()
        }, content: {
            IDCardEditor(idImage: $selectedIDCard)
        })
        .fullScreenCover(isPresented: $personalInfo) {
            EditProfileScreen()
        }
        .popover(isPresented: $usingPlatform) {
            PlatformsSelector()
        }
        .fullScreenCover(isPresented: $accountType) {
            AccountType()
        }
        .popover(isPresented: $apply) {
            Application()
        }
        .popover(isPresented: $toFAQ) {
            FAQ()
        }
        .popover(isPresented: $suggestion) {
            Feedback()
        }
        .popover(isPresented: $ads) {
            Statics()
        }
        
        .popover(isPresented: $toSecurity) {
            SecurityView()
        }
        .popover(isPresented: $toRequestGiftScreen, content: {
            RequestGift(bigoId: userStore.bigoId, email: userStore.email, firstName: userStore.firstName, gift: userStore.gift, giftDate: currentDate, lastName: userStore.lastName, pfImage: userStore.pfImage, level: userStore.level)
        })
        
    }
    
    
    private func settingsOpener(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    private func saveSignature() {
        let img = canvasView.drawing.image(from: imgRect, scale: 1.0)
        self.signatureImage = img
    }
    
    
    private func verifyAccount1(){
        
        guard let signatureData: Data = signatureImage.jpegData(compressionQuality: 0.50) else {
            return
        }

        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Confirmation/\(currentUser)/signature")
        
        storageRef.putData(signatureData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (signatureURL: URL!, error: Error?) in
                
                
                verifyAccount2(signatureURL: "\(signatureURL!)")
                
            })
        }
  
    }
    
    private func verifyAccount2(signatureURL : String){

        guard let IDCardData: Data = selectedIDCard.jpegData(compressionQuality: 1.00) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Confirmation/\(currentUser)/idCard")
        
        storageRef.putData(IDCardData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                
                
                return
            }
            
            storageRef.downloadURL(completion: { (IDCardURL: URL!, error: Error?) in
                
                let data = ["pfImage" : self.userStore.pfImage, "fullname" : "\(self.userStore.firstName) \(self.userStore.lastName)", "siganture" : "\(signatureURL)", "idCard" : "\(IDCardURL!.absoluteString)", "platformID" : self.userStore.bigoId, "birtday" : self.userStore.birthday, "email" : self.userStore.email]
                let ref = Firestore.firestore()

                ref.collection("AccountConfirmation").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                self.showVerifyAlert.toggle()

                self.present.wrappedValue.dismiss()
                
            })
        }
    }
    
}
