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

struct EditProfile: View {
    
    @Environment(\.presentationMode) var present
    
    //Stores
    @StateObject var userStore = UserInfoStore()
    @StateObject var countryCodes = CountryCodeStore()
    @StateObject var netgsmStore = NETGSMStore()
    @StateObject var cityTownStore = DataObserv()
    let detector = NSFWDetector.shared
    
    //Inputs
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var platformId : String = ""
    @State private var phoneNumber : String = ""
    @State private var nickname : String = ""
    @State private var addres : String = ""
    @State private var city : String = ""
    @State private var town : String = ""
    @State private var plaka : Int = 0
    @State private var selectedPlatform : String = ""
    @State private var countryCode : String = ""
    @State private var verificationCode : String = ""
    @State private var sendCode : Bool = false
    @State private var tempCode : Int = Int.random(in: 1000 ... 9999)
    @State private var townList : [String] = []
    
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
                    .overlay {
                        if blur {
                            Color.black.opacity(0.000000004).edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .colorScheme(.light)
                                .scaleEffect(2)
                        }
                    }
                    .blur(radius: blur ? 11 : 0)
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
                self.plaka = userStore.plaka
                self.countryCode = userStore.countryCode
                self.selectedPlatform = userStore.selectedPlatform
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
                ActionSheet.Button.cancel(Text("İptal"), action: {
                    self.showActionSheet.toggle()
                })
            ])
        }
        .fullScreenCover(isPresented: $toCamera) {
            if self.selectedImage != UIImage() {
                self.toPhotoEditor.toggle()
            }
            else {
                self.alertTitle = "Uyarı"
                self.alertBody = "Hiç bir fotoğraf seçilmedi!"
                self.showAlert.toggle()
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
                
                
                Button {
                    self.alertTitle = "Copied PayWoow ID"
                    self.alertBody = "Your PayWoow ID was copied."
                    self.showAlert.toggle()
                    UIPasteboard.general.string = "\(Auth.auth().currentUser!.uid)"
                } label: {
                    Text("PayWoow ID")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.light)
                }

            }
            .padding(20)
            
            
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
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                        .fill(Color.black.opacity(0.2))
                    
                    HStack{
                        TextField("Platform ID", text: $platformId)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            
                        Button {
                            self.toPlatformSelector.toggle()
                        } label: {
                            Image(self.selectedPlatform)
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
                    
                    HStack(spacing: 10){
                        if self.userStore.countryCode == self.countryCode {
                            Text("+\(countryCode)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.leading)
                                .onTapGesture {
                                    self.bodySelection = 1
                                }
                        }
                        else {
                            Text("\(countryCode)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.leading)
                                .onTapGesture {
                                    self.bodySelection = 1
                                }
                        }
                        
                        Divider()
                            .colorScheme(.dark)
                        
                        TextField("Cep Telefonu", text: $phoneNumber)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.trailing)
                        
                        if self.phoneNumber.count == 10 && self.userStore.isVerifiedNumber == false{
                            Button {
                                self.showPhoneVerificator.toggle()
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
                
                
                HStack{
                    Text("Address Informations")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()

                }
                .padding()
                
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
                            RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
                                .fill(Color.black.opacity(0.2))
                            
                            if self.showtownList {
                                PickerField("İlçe Seç", data: townList, selectionIndex: $townIndex)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .onChange(of: townIndex ?? 0) { index in
                                        self.town = cityTownStore.townList[index]
                                        
                                    }
                            }
                            else {
                                PickerField("İlçe Seç", data: townList, selectionIndex: $townIndex)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .onChange(of: townIndex ?? 0) { index in
                                        self.town = cityTownStore.townList[index]
                                        
                                    }
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
                        else if self.selectedImage != UIImage() {
                            detector.check(image: selectedImage, completion: { result in
                                switch result {
                                case let .success(nsfwConfidence: confidence):
                                    if confidence > 0.5  {
                                        self.alertTitle = "Detected an nude photo!"
                                        self.alertBody = "Please select a non-useable photo. If you continue to select nude photos, your account will be permanently banned!"
                                        self.showAlert = true
                                    } else {

                                        saveUpdates()
                                        self.blur = true
                                    }
                                default:
                                    break
                                }
                            })
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
                    else {
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

            if self.sendCode == true {
                Button {
                    if self.tempCode == Int(self.verificationCode)! {
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
                    
                    sendPushNotify(title: "Doğrulama Kodunuz", body: "Tek seferlik doğrulama kodunuz - \(tempCode)", userToken: userStore.token, sound: "pay.mp3")
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
            "town" : town,
            "phoneNumber" : "\(phoneNumber)",
            "countryCode" : "+"+countryCode,
            "bigoId" : platformId,
            "birthday" : "",
            "adress" : addres,
            "nickname" : nickname,
            "plaka" : (cityIndex ?? 0) + 1
        ] as [String : Any]
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        
        if self.selectedImage != UIImage() {
            savePhoto()
        }
        else {
            self.blur = false
            self.present.wrappedValue.dismiss()
        }
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
                
            })
        }

    }
}
