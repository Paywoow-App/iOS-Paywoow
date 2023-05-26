//
//  EditProfile.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/30/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import NSFWDetector
import Mantis


struct EditProfileOld: View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var netgsmStore = NETGSMStore()
    @StateObject var cityTownData = DataObserv()
    @Environment(\.presentationMode) var present
    let detector = NSFWDetector.shared
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var platformId : String = ""
    @State private var phoneNumber : String = ""
    @State private var nickname : String = ""
    @State private var adress : String = ""
    @State private var city : String = "City"
    @State private var town : String = ""
    @State private var selectedPlaka : Int = 0
    @State private var cropShapeType: Mantis.CropShapeType = .square
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    // External
    @State private var selectedImage: UIImage = UIImage()
    @State private var tempCode = Int.random(in: 1000 ... 9999)
    @State private var verificationCode : String = ""
    @State private var openVerificator = false
    @State private var sendCode : Bool = false
    @State private var toImageEditor = false
    @State private var openBlur = false
    @State private var showLibrary = false
    @State private var showAlert = false
    @State private var alertMessage : String = ""
    @State private var alertTitle : String = ""
    @State private var toPlatformSelector = false
    @State private var toCitySelector : Bool = false
    @State private var cityTownSelector = 0
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 56 / 255, blue: 56 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 43, height: 43)

                    Text("Edit Profile")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading, 5)

                    Spacer(minLength: 0)

                    Button {
                        self.alertTitle = "Copied PayWoow ID"
                        self.alertMessage = "Your PayWoow ID was copied."
                        self.showAlert = true
                        UIPasteboard.general.string = "\(Auth.auth().currentUser!.uid)"
                    } label: {
                        Text("PayWoow ID")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.light)
                    }

                }
                .padding()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10){
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
                                        self.showLibrary = true
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
                                self.showLibrary = true
                            }
                        }

                        HStack{
                            Text("Personal Informations")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()

                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)

                        HStack(spacing: 10){
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                TextField("First Name", text: $firstName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 20)
                                    .preferredColorScheme(.dark)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                            self.firstName = userStore.firstName
                                        }
                                    }
                            }
                            .padding(.leading)

                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                TextField("Last Name", text: $lastName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 20)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                            self.lastName = userStore.lastName
                                        }
                                    }
                            }
                            .padding(.trailing)
                        }
                        .frame(height: 50)

                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            HStack{

                                Text("+90")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 10)

                                TextField("Phone Number", text: $phoneNumber)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.trailing, 20)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                            self.phoneNumber = userStore.phoneNumber
                                        }
                                    }
                                
                                if self.phoneNumber.count == 10 && self.userStore.isVerifiedNumber == false{
                                    Button {
                                        self.openVerificator = true
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

                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            TextField("Username", text: $nickname)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal, 20)
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                        self.nickname = userStore.nickname
                                    }
                                }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)

                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            HStack{
                                TextField("Platform ID", text: $platformId)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                            self.platformId = userStore.bigoId
                                        }
                                    }
                                    .allowsHitTesting(userStore.hideId ? false : true)
                                
                                
                                Image(userStore.selectedPlatform)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.trailing, 15)
                                    .onTapGesture {
                                        self.toPlatformSelector.toggle()
                                    }
                                
                                
                            }.padding(.leading, 20)
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

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                HStack{
                                    
                                    Text(city)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .onAppear{
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                                self.city = userStore.city
                                            }
                                        }
                                        

                                    
                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal)
                            }

                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                HStack{
                                    Text(town)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .onAppear{
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                                self.town = userStore.town
                                            }
                                        }

                                    Spacer(minLength: 0)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)

                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            TextField("Adres", text: $adress)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                if self.userStore.adress != "" {
                                    self.adress = userStore.adress
                                }
                            }
                        }



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
                                if self.userStore.isVerifiedNumber {
                                    
                                    if self.selectedImage != UIImage(){
                                        detector.check(image: selectedImage, completion: { result in
                                            switch result {
                                            case let .success(nsfwConfidence: confidence):
                                                if confidence > 0.5  {
                                                    self.alertTitle = "Detected an nude photo!"
                                                    self.alertMessage = "Please select a non-useable photo. If you continue to select nude photos, your account will be permanently banned!"
                                                    self.showAlert = true
                                                } else {
                                                    
                                                    SaveChanges()
                                                    self.openBlur = true
                                                }
                                            default:
                                                break
                                            }
                                        })
                                    }
                                    else {
                                        SaveChanges()
                                    }
                                    
                                    
                                }
                                else {
                                    self.alertTitle = "Non-Verified Number"
                                    self.alertMessage = "Please verify the phone number"
                                    self.showAlert = true
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
                        .padding()

                    }
                }
            }
            .blur(radius: openBlur ? 3 : 0)
            .blur(radius: openVerificator ? 3 : 0)
            .overlay{
                if openBlur {
                    ProgressView()
                        .preferredColorScheme(.dark)
                        .scaleEffect(2)
                }
            }
            
            if self.openVerificator {
                verificationScreen
            }
        }
        .fullScreenCover(isPresented: $showLibrary, onDismiss: {

            if self.selectedImage != UIImage() {
                self.toImageEditor.toggle()
            }
            
            
        }, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        })
        .fullScreenCover(isPresented: $toImageEditor, onDismiss: {
           
        }, content: {
            ImageCropper(image: $selectedImage, cropShapeType: $cropShapeType, presetFixedRatioType: $presetFixedRatioType)
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(self.alertMessage), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .popover(isPresented: $toPlatformSelector) {
            PlatformsSelector()
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.selectedPlaka = userStore.plate
            }
        }
        
    }
    
    
    var verificationScreen : some View {
        
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
                        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["phoneNumber" : phoneNumber, "isVerifiedNumber" : true], merge: true)
                        self.openVerificator = false
                    }
                    else {
                        self.alertMessage = "The verification code you entered is incorrect. Please check again!"
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
            Alert(title: Text("Incorrect Code"), message: Text(self.alertMessage), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    
    func SaveChanges(){
        if self.selectedImage != UIImage() {
            guard let imageData: Data = selectedImage.jpegData(compressionQuality: 0.75) else {
                return
            }
            
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
                    self.openBlur = false
                    
                })
            }
        }
        
        
        let ref = Firestore.firestore()
        
        let data = [
            "firstName" : firstName,
            "lastName" : lastName,
            "city":  city,
            "town" : town,
            "phoneNumber" : "\(phoneNumber)",
            "platformID" : platformId,
            "birthday" : "",
            "adress" : adress,
            "nickname" : nickname,
            "plate" : (selectedPlaka ?? 0) + 1
        ] as [String : Any]
        
        if self.platformId != "" {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document(userStore.selectedPlatform).setData(["platformId" : self.platformId], merge: true)
        }
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        self.openBlur = false
        self.present.wrappedValue.dismiss()
        
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
}

