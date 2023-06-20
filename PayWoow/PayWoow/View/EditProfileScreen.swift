//
//  NewEditProfile.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/25/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseStorage
import Mantis
import NSFWDetector
import Firebase

struct EditProfileScreen: View {
    
    @Environment(\.presentationMode) var present
    
    //Stores
    @StateObject var userStore = UserInfoStore()
    @StateObject var countryCodes = CountryCodeStore()
    @StateObject var netgsmStore = NETGSMStore()
    @StateObject var cityTownStore = DataObserv()
    @StateObject var bankStore = BankCardStore()
    @AppStorage("usingPlatform") var usingPlatformPlaceholder : String = "BigoLive"
    
    //Inputs
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var platformId : String = ""
    @State private var phoneNumber : String = ""
    @State private var nickname : String = ""
    @State private var addres : String = ""
    @State private var tcKimlikNo : String = ""
    @State private var city : String = ""
    @State private var town : String = ""
    @State private var plaka : Int = 0
    @State private var selectedPlatform : String = ""
    @State private var countryCode : String = ""
    @State private var email : String = ""
    @State private var verificationCode : String = ""
    @State private var sendCode : Bool = false
    @State private var tempCode : Int = Int.random(in: 1000 ... 9999)
    @State private var townList : [String] = []
    @State private var birthdayTimeStamp : Int = 0
    @State private var birthday : String = ""
    @State private var birthdayDate = Date()
    @State private var isStillUsingPhone: Bool = false
    
    // External
    @State private var bodySelection : Int = 0
    @State private var selectedImage : UIImage = UIImage()
    @State private var actionSheetSelector : Int = 0
    @State private var showActionSheet : Bool = false
    @State private var toPhotoLibrary : Bool = false
    @State private var toCamera : Bool = false
    @State private var showSearchBar : Bool = false
    @State private var dialSearch : String = ""
    @State private var toPlatformSelector : Bool = false
    @State private var showPhoneVerificator : Bool = false
    @State private var cityIndex : Int?
    @State private var townIndex : Int?
    @State private var showtownList : Bool = false
    @State private var blur : Bool = false
    @State private var isAcceptedTC : Bool = false
    
    // Mantis
    @State private var toPhotoEditor : Bool = false
    @State private var cropShapeType : Mantis.CropShapeType = .square
    @State private var presetFixedRatioType : Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    //Alerts
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            if self.bodySelection == 0 {
                InfoBody
                    .blur(radius: blur ? 11 : 0)
                    .overlay {
                        if blur {
                            Color.black.opacity(0.000000004).edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .colorScheme(.light)
                                .scaleEffect(2)
                        }
                    }
            }
            else if self.bodySelection == 1 {
                countryCodeBody
            }
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.firstName = userStore.firstName
                self.lastName = userStore.lastName
                self.pfImage = userStore.pfImage
                self.platformId = userStore.bigoId
                self.phoneNumber = userStore.phoneNumber
                self.nickname = userStore.nickname
                self.addres = userStore.adress
                self.city = userStore.city
                self.town = userStore.town
                self.plaka = userStore.plate
                self.cityIndex = userStore.cityIndex
                self.countryCode = userStore.countryCode
                self.townIndex = userStore.townIndex
                self.selectedPlatform = userStore.selectedPlatform
                self.tcKimlikNo = userStore.tcNo
                self.email = userStore.email
                
                self.cityTownStore.findTowns(cityInput: self.city)
                self.townList = self.cityTownStore.townList
                
                let bd = Date(timeIntervalSince1970: TimeInterval(Int(userStore.birthday) ?? 0))
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                self.birthday = formatter.string(from: bd)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Yeni profil fotoğrafını nereden seçmek istersin?"), message: Text("İstersen Fotoğraf kütüphanesinden, istersende kendi iPhone kameranı kullanarak"), buttons: [
                ActionSheet.Button.default(Text("Kamera"), action: {
                    showActionSheet.toggle()
                    self.toCamera.toggle()
                }),
                ActionSheet.Button.default(Text("Fotoğraf Kütüphanesi"), action: {
                    showActionSheet.toggle()
                    self.toPhotoLibrary.toggle()
                }),
                
                ActionSheet.Button.default(Text("Varsayılan Fotoğraf"), action: {
                    showActionSheet.toggle()
                    self.selectedImage = UIImage(named: "defualtPf")!
                }),
                ActionSheet.Button.cancel(Text("İptal"), action: {
                    self.showActionSheet.toggle()
                })
            ])
        }
        .fullScreenCover(isPresented: $toCamera) {
            
            self.toPhotoEditor.toggle()
            if self.selectedImage != UIImage() {
                
                //                let detector = NSFWDetector.shared
                //
                //                detector.check(image: selectedImage, completion: { result in
                //                    switch result {
                //                    case let .success(nsfwConfidence: confidence):
                //                        if confidence > 0.5  {
                //                            self.selectedImage = UIImage(named: "defaultPf")!
                //                            self.alertTitle = "Detected an nude photo!"
                //                            self.alertBody = "Please select a non-useable photo. If you continue to select nude photos, your account will be permanently banned!"
                //                            self.showAlert = true
                //
                //                        } else {
                //                            self.toPhotoEditor.toggle()
                //                            self.blur = false
                //                        }
                //                    default:
                //                        break
                //                    }
                //                })
            }
        } content: {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        
        .fullScreenCover(isPresented: $toPhotoLibrary) {
            
            if self.selectedImage != UIImage() {
                self.toPhotoEditor.toggle()
                
            }
        } content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $toPhotoEditor) {
            ImageCropper(image: $selectedImage, cropShapeType: $cropShapeType, presetFixedRatioType: $presetFixedRatioType)
        }
        .popover(isPresented: $toPlatformSelector) {
            PlatformsSelector()
            
        }
        .onChange(of: userStore.selectedPlatform) { newValue in
            let ref = Firestore.firestore()
            print("changed ")
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document(newValue).addSnapshotListener { doc, err in
                if err == nil {
                    if let platformID = doc?.get("platformId") as? String {
                        self.platformId = platformID
                        print("changed 2")
                    }
                }
            }
        }
    }
    
    var InfoBody : some View {
        VStack(spacing: 15){
            HStack(spacing: 12){
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            
            ScrollView(.vertical, showsIndicators: false) {
                if self.userStore.vipType == "None" {
                    ZStack{
                        AnimatedImage(url: URL(string: self.userStore.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 180, height: 180)
                        
                        
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 180, height: 180)
                            .onTapGesture {
                                self.showActionSheet.toggle()
                            }
                    }
                }
                else {
                    ZStack{
                        AnimatedImage(url: URL(string: self.userStore.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 180, height: 180)
                        
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 180, height: 180)
                        
                        
                        if self.userStore.vipType == "VIPSILVER" {
                            LottieView(name: "crown_silver", loopMode: .loop, speed: 0.5)
                                .frame(width: 180, height: 180)
                                .scaleEffect(1.7)
                                .offset(y: -22)
                        }
                        else if self.userStore.vipType == "VIPBLACK" {
                            LottieView(name: "crown_black", loopMode: .loop, speed: 0.5)
                                .frame(width: 180, height: 180)
                                .scaleEffect(1.7)
                                .offset(y: -22)
                        }
                        else if self.userStore.vipType == "VIPGOLD" {
                            LottieView(name: "crown_gold", loopMode: .loop, speed: 0.5)
                                .frame(width: 180, height: 180)
                                .scaleEffect(1.7)
                                .offset(y: -22)
                        }
                        
                        if self.userStore.level == 100 {
                            LottieView(name: "king", loopMode: .loop)
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(41))
                                .offset(x: 80, y: -50)
                        }
                    }
                    .padding(.top, 55)
                    .onTapGesture {
                        self.showActionSheet.toggle()
                    }
                }
                
                HStack{
                    Text("Personal Informations")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .padding(.bottom)
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Ad", text: $firstName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                        
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Soyad", text: $lastName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                        
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Kullanıcı Adı", text: $nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                    
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                Group{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            TextField("Platform ID", text: $platformId)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .disabled(true)
                            
                            Button {
                                self.toPlatformSelector.toggle()
                            } label: {
                                Image(usingPlatformPlaceholder)
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(radius: 6, corners: .allCorners)
                            }
                            
                        }.padding(.horizontal)
                        
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                            .fill(Color.black.opacity(0.2))
                        
                        HStack{
                            TextField("Email Adresiniz", text: $email)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            if Auth.auth().currentUser!.isEmailVerified {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                            }
                            else {
                                Button {
                                    Auth.auth().currentUser!.sendEmailVerification { err in
                                        if err != nil {
                                            self.alertTitle = "Hata"
                                            self.alertBody = "Email adresi doğrulama talebi gönderilemedi lütfen daha sonra tekrar deneyiniz"
                                        }
                                        else {
                                            self.alertTitle = "Mail adresinize bir doğrulama linki gönderdik"
                                            self.alertBody = "Emailinizi kontrol ederek doğrulama işlemini devam ediniz. Kısa süre içerisinde onaylanacaktır."
                                        }
                                    }
                                } label: {
                                    Text("Verifiy")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 16))
                                }
                            }
                            
                        }.padding(.horizontal)
                        
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack(spacing: 10){
                        Text("\(countryCode)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.leading)
                            .onTapGesture {
                                self.bodySelection = 1
                            }
                        
                        Divider()
                            .colorScheme(.dark)
                        
                        TextField("Cep Telefonu", text: $phoneNumber)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.trailing)
                            .keyboardType(.numberPad)
                            .onChange(of: phoneNumber) { newValue in
                                if newValue.count == 10 {
                                    Firestore.firestore().collection("users").whereField("phoneNumber", isEqualTo: phoneNumber)
                                            .getDocuments { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    if querySnapshot!.documents.count > 0 {
                                                        // Telefon numarası zaten var
                                                        self.isStillUsingPhone = true
                                                        print("Bu telefon numarası zaten kullanılıyor!")
                                                    } else {
                                                        // Telefon numarası kullanılmıyor
                                                        self.isStillUsingPhone = false
                                                        print("Bu telefon numarası kullanılabilir!")
                                                    }
                                                }
                                            }
                                }
                            }
                                                
                        if self.phoneNumber.count == 10 && self.userStore.isVerifiedNumber == false{
                            Button {
                                if isStillUsingPhone {
                                    
                                    self.alertTitle = "Telefon numarası kullanılıyor"
                                    self.alertBody = "Bu telefon numarası sistemlerimizde kayıtlı"
                                    self.showAlert = true
                                    
                                } else {
                                    self.showPhoneVerificator.toggle()
                                }
                            } label: {
                                Text("Verifiy")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 16))
                            }
                            .padding(.trailing)
                        }
                        else if self.phoneNumber.count == 10 && self.userStore.isVerifiedNumber == true {
                            Text("Verified")
                                .foregroundColor(Color.init(hex: "#1CC4BE"))
                                .font(.system(size: 16))
                                .padding(.trailing)
                        }
                    }
                    
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                Group {
                    if userStore.tcNo == "" {
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                DatePicker("Doğum Tarihiniz", selection: $birthdayDate, in: ...Date.now, displayedComponents: .date)
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
                                    .onChange(of: birthdayDate) { val in
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "dd.MM.yyyy"
                                        self.birthday = formatter.string(from: val)
                                        self.birthdayTimeStamp = Int(val.timeIntervalSince1970)
                                    }
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .onChange(of: birthday) { V in
                            print("debugggg \(V)")
                        }
                        if birthday != "01.01.1970" {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack {
                                    TextField("TC Kimlik Numaranız", text: $tcKimlikNo)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .colorScheme(.dark)
                                    
                                    if isAcceptedTC {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.green)
                                            .font(.system(size: 20))
                                    }
                                    else {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 20))
                                    }
                                }
                                .onChange(of: tcKimlikNo, perform: { newValue in
                                    if newValue.count == 11 {
                                        checkTCID()
                                    }

                                    
                                    if newValue.count > 11 {
                                        self.tcKimlikNo.dropLast(1)
                                    }
                                })
                                
                                .onChange(of: firstName, perform: { newValue in
                                    checkTCID()
                                })
                                
                                .onChange(of: lastName, perform: { newValue in
                                    checkTCID()
                                })
                                
                                .onChange(of: birthdayTimeStamp, perform: { newValue in
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        checkTCID()
                                    }
                                })
                                .padding(.horizontal)
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                        }
                    
                    
                       
                    
                    
                }
                    
                    
                    HStack{
                        Text("Address Informations")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .bold()
                        
                    }
                    .padding()
                }
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                            .fill(Color.black.opacity(0.2))
                        
                        PickerField("İl Seç", data: cityTownStore.cityList, selectionIndex: $cityIndex)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .onChange(of: cityIndex ?? 0) { index in
                                self.city = cityTownStore.cityList[index]
                                cityTownStore.findTowns(cityInput: city)
                                
                                self.townIndex = 0
                                self.showtownList.toggle()
                            }
                        
                        
                    }
                    .frame(height: 50)
                    
                    
                    if !self.townList.isEmpty {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            if self.showtownList {
                                PickerField("İlçe Seç", data: townList, selectionIndex: $townIndex)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .onChange(of: townIndex ?? 0) { index in
                                        self.town = cityTownStore.townList[index]
                                    }
                                    .colorScheme(.light)
                            }
                            else {
                                PickerField("İlçe Seç", data: townList, selectionIndex: $townIndex)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .onChange(of: townIndex ?? 0) { index in
                                        self.town = cityTownStore.townList[index]
                                    }
                                    .colorScheme(.light)
                            }
                            
                        }
                        .frame(height: 50)
                    }
                }
                .padding(.horizontal)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Adres", text: $addres)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                    
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                HStack{
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Cancel")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                            
                        }
                    }
                    
                    
                    Button {
                        
                        if self.userStore.isVerifiedNumber == false {
                            self.alertTitle = "Non-Verified Number"
                            self.alertBody = "Please verify the phone number"
                            self.showAlert = true
                        }
                        else if isAcceptedTC == false && self.userStore.tcNo == "" {
                            self.alertTitle = "Non-Verified TC Number"
                            self.alertBody = "Please verify the your TC ID Number!"
                            self.showAlert = true
                        }
                        else {
                            saveUpdates()
                            
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(hex: "#1CC4BE"))
                            
                            Text("Complate")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                            
                        }
                    }
                    
                }
                .frame(height: 50)
                .padding(.all)
            }
        }
        .blur(radius: showPhoneVerificator ? 11 : 0)
        .overlay {
            if self.showPhoneVerificator {
                ZStack{
                    Color.black.opacity(0.000000005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPhoneVerificator.toggle()
                        }
                    phoneVerificator
                }
            }
        }
        .onChange(of: cityIndex) { val in
            self.townList = self.cityTownStore.townList
            
        }
    }
    
    var countryCodeBody : some View {
        VStack(spacing: 15){
            HStack(spacing: 12){
                Button {
                    self.bodySelection = 0
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 40, height: 40)
                }
                
                
                
                Text("Ülke Kodu Seç")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
                Button {
                    self.showSearchBar.toggle()
                } label: {
                    Image(systemName : "magnifyingglass")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                
            }
            .padding(.init(top: 20, leading: 20, bottom: 0, trailing: 20))
            
            if self.showSearchBar {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Ülke Ara", text: $dialSearch)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                }
                .frame(height: 50)
                .padding(.horizontal)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(countryCodes.list, id: \.self) { item in
                    if self.dialSearch != "" && item.name.contains(dialSearch) {
                        HStack{
                            Text(item.dial_code)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            Text(item.name)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            if self.countryCode == item.dial_code {
                                Text("Seçildi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            self.bodySelection = 0
                            self.countryCode = item.dial_code
                        }
                        
                        Divider()
                            .colorScheme(.dark)
                            .padding(.horizontal)
                    }
                    else if dialSearch == ""{
                        HStack{
                            Text(item.dial_code)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            Text(item.name)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            if self.countryCode == item.dial_code {
                                Text("Seçildi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            self.bodySelection = 0
                            self.countryCode = item.dial_code
                        }
                        
                        Divider()
                            .colorScheme(.dark)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    var phoneVerificator : some View {
        
        VStack(spacing: 15){
            
            Text("Verifiy Phone Number")
                .foregroundColor(.black)
                .font(.system(size: 18))
                .bold()
                .padding(.top)
            
            Text("We have sent a verification code to your phone number. We need this to verify this phone number.")
                .foregroundColor(.black)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if self.sendCode {
                TextField("Code", text: $verificationCode)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .preferredColorScheme(.dark)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)

                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.25)
            }
            // Phone auth problem
            if self.sendCode == true {
                Button {
                    if self.tempCode == Int(self.verificationCode) {
                        let ref = Firestore.firestore()
                        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                            ["phoneNumber" : phoneNumber,
                             "isVerifiedNumber" : true,
                             "countryCode" : countryCode
                            ], merge: true)
                        self.showPhoneVerificator.toggle()
                    }
                    else {
                        self.alertBody = "The verification code you entered is incorrect. Please check again!"
                        self.showAlert = true
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(hex: "#1CC4BE"))
                        
                        Text("Verify Number")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                    }
                    .frame(height: 50)
                    .padding()
                }
            }
            else {
                Button {
                    self.sendCode = true
                    sendCode(code: "\(tempCode)", number: phoneNumber, header: self.netgsmStore.header, usercode: self.netgsmStore.usercode, password: self.netgsmStore.password)
                    print("temporaryCode = \(tempCode)")
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black)
                        
                        Text("Send Code")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                    }
                    .frame(height: 50)
                    .padding()
                }
            }
            
            
        }
        .background(Color.white)
        .cornerRadius(8)
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Incorrect Code"), message: Text(self.alertBody), dismissButton: Alert.Button.default(Text("Ok")))
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
            print(String(data: dat!, encoding: .utf8)!)
            
            if err == nil, let data = dat, let response = res as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                addCountNetGSM()
            } else {
                print("Status code 404")
            }
            
        }.resume()
        
        
    }
    
    func saveUpdates(){
        self.blur = true
        let ref = Firestore.firestore()
        let data = [
            "firstName" : firstName,
            "lastName" : lastName,
            "city":  city,
            "town" : townList[townIndex ?? 0],
            "phoneNumber" : "\(phoneNumber)",
            "countryCode" : countryCode,
            "platformID" : platformId,
            "birthday" : birthdayTimeStamp,
            "addres" : addres,
            "nickname" : nickname,
            "plate" : (cityIndex ?? 0) + 1,
            "cityIndex" : cityIndex ?? 0,
            "townIndex" : townIndex ?? 0,
            "tcNo" : tcKimlikNo
        ] as [String : Any]
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document(self.usingPlatformPlaceholder).setData([
            "platformId" : platformId
        ], merge: true)
        
        if self.selectedImage != UIImage() {
            savePhoto()
        }
        
        self.blur = false
        self.present.wrappedValue.dismiss()
    }
    
    func savePhoto(){
        guard let imageData: Data = selectedImage.jpegData(compressionQuality: 0.75) else {return}
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "\(currentUser)/pfImage")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL!, error: Error?) in
                print(url!.absoluteString) // <- Download URL
                
                let ref = Firestore.firestore()
                
                let data = ["pfImage" : url.absoluteString] as [String : Any]
                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                
                self.blur = false
                self.present.wrappedValue.dismiss()
            })
        }
        
    }
    
    func checkTCID(){
        
            let xml = """
            <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
              <soap12:Body>
                <TCKimlikNoDogrula xmlns="http://tckimlik.nvi.gov.tr/WS">
                  <TCKimlikNo>\(tcKimlikNo)</TCKimlikNo>
                  <Ad>\(firstName)</Ad>
                  <Soyad>\(lastName)</Soyad>
                  <DogumYili>2000</DogumYili>
                </TCKimlikNoDogrula>
              </soap12:Body>
            </soap12:Envelope>
"""
            
            var request = URLRequest(url: URL(string: "https://tckimlik.nvi.gov.tr/Service/KPSPublic.asmx?WSDL")!)
            request.httpMethod = "POST"
            request.httpBody = xml.data(using: .utf8)
            request.addValue("application/soap+xml", forHTTPHeaderField:  "Content-Type")
            
            let session = URLSession(configuration: .default)
            session.dataTask(with: request) { dat, res, err in
                print(String(data: dat!, encoding: .utf8)!)
                
                if err == nil, let data = dat, let response = res as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    print(String(data: data, encoding: .utf8) ?? "")
                    let resultString = "\(String(data: data, encoding: .utf8))"
                    if resultString.contains("true") {
                        self.isAcceptedTC = true
                    }
                    else {
                        self.isAcceptedTC = false
                    }
                    
                } else {
                    print("Status code 404")
                }
                
            }.resume()
        
    }
}
