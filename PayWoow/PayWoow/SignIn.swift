//
//  SignIn.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/7/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import SDWebImageSwiftUI
import LocalAuthentication
import DeviceKit
import CryptoKit
import GoogleSignIn
import Network

struct SignIn: View {
    @StateObject var authReseracher = Auth_Reseracher()
    @StateObject var userInfo = SignInUserInfo()
    @StateObject var locationManager = LocationManager()
    @StateObject var generalStore = GeneralStore()
    @AppStorage("userDeviceToken") var userDeviceToken : String = ""
    @AppStorage("mainTabViewSelection") var selection = 4
    @AppStorage("lastSignIn") var lastSignIn : String = ""
    @AppStorage("isNewUser") var isNewUser : Bool = false
    @State private var bodySelection = 0
    @State private var signInSelection = 0
    @State private var registerStep = 3
    @State private var phoneNumber : String = ""
    @State private var password : String = ""
    @State private var passwordAgain : String = ""
    @State private var email : String = ""
    @State private var firstName : String  = ""
    @State private var lastName : String = ""
    @State private var nickName : String = ""
    @State private var platformId : String = ""
    @State private var bDay : String = "Doğum tarihi seçiniz"
    @State private var age : Int = 0
    @State private var currentNonce: String?
    @State private var pin : String = ""
    @State private var forgotPasswordSelection : Int = 0
    
    // external
    @State private var date = Date()
    @State private var blur = false
    @State private var toMainTabView = false
    @State var showAlert = false
    @State var alertTitle : String = ""
    @State var alertBody : String = ""
    @State var isFromMainTabView = false
    @State private var logoutBlur : Bool = false
    @State private var device = Device.current
    @State private var internetProblem : Bool = false
    
    //Check
    @State private var userCanUseThisNickname : Bool = false
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    var body : some View {
        Button(action: {
            
        }, label: {
            Text("")
        })
        
    }
    
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        self.age = age!
        return age!
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, appleId: String, token: String, device: String, nickname: String){
        self.isNewUser = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let today = formatter.string(from: date)
        let timeStamp = Date().timeIntervalSince1970
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2)) {
            
            let ref = Firestore.firestore()
            let userData = [
                "firstName" : firstName,
                "lastName" : lastName,
                "email" : email,
                "platformID" : "",
                "pfImage" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Defulats%2FdefulatProfileImage.png?alt=media&token=402f2e36-2371-41d0-a4dc-4d9e0d790513",
                "gift" : 0,
                "birthday" : "",
                "level" : 1,
                "accountLevel" : 1,
                "gender" : "None",
                "phoneNumber" : "",
                "addres" : "",
                "refCode" : "",
                "signature" : "",
                "verify" : false,
                "myReferanceCode" : "",
                "levelPoint" : 1001,
                "selectedPlatform" : "BigoLive",
                "totalSoldDiamond" : 0,
                "application" : false,
                "today" : today,
                "block" : false,
                "city" : "",
                "town" : "",
                "plate" : 0,
                "password" : password,
                "isOwnStreamer" : false,
                "nickname" : nickname,
                "current" : "SignIn",
                "appleId" : appleId,
                "token" : userDeviceToken,
                "device" : device,
                "blockDesc" : "",
                "vipType" : "Casper",
                "isVerifiedNumber" : false,
                "agencyApplicationUserId" : "",
                "pin" : "",
                "agencyRequest" : false,
                "isSentAgencyApplication" : "",
                "countryCode" : "90",
                "townIndex" : 0,
                "cityIndex" : 0,
                "managerType" : "",
                "managerPlatform" : "BigoLive",
                "myAgencyId" : "",
                "taxApplicationId" : false,
                "remittenceLimit" : false,
                "vipPoint" : 0,
                "streamerAgencyID" : "",
                "isOnline" : true,
                "lat" : Double(0),
                "long" : Double(0),
                "accountCreatedDate" : Int(timeStamp),
                "casper" : false,
                "tcNo" : "",
                "isComplatedTax" : false
            ] as [String : Any]
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(userData)
            
            let platformData = [
                "platformId" : "",
                "platformLogo" : "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/unnamed.png?alt=media&token=49335882-c4d5-487c-a0ec-5d1b1dc384a1",
                "platformName" : "BigoLive"
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("Platforms").document("BigoLive").setData(platformData, merge: true)

            let requiredNumbers = Int.random(in: 100000000 ... 999999999)
            let cardNumber = "\(7299669)\(requiredNumbers)"
            let cardPassword = Auth.auth().currentUser!.uid
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let dayAndMonth = formatter.string(from: date)
            let expiryDate = "\(dayAndMonth).\(2027)"
            let cardData = [
                "cardNo" : cardNumber,
                "cardPassword" : cardPassword,
                "cardType" : "Casper",
                "expiryDate" : expiryDate,
                "isActivated" : false,
                "totalPrice" : 0,
                "twoFactor" : false
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document("Casper").setData(cardData, merge: true)
            
            let createStatics = [
                "Ocak" : 0,
                "Şubat" : 0,
                "Mart" : 0,
                "Nisan" : 0,
                "Mayıs" : 0,
                "Haziran" : 0,
                "Temmuz" : 0,
                "Ağustos" : 0,
                "Eylül" : 0,
                "Ekim" : 0,
                "Kasım" : 0,
                "Aralık" : 0,
            ]
            
            
            let currentYear = Date()
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let year = yearFormatter.string(from: currentYear)
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldDiamond").collection("Years").document("\(year)").setData(createStatics)
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("UserStatics").document("SoldPrice").collection("Years").document("\(year)").setData(createStatics)
            
            let device = "\(Device.current)"
            
            let dat = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.locale = Locale(identifier: "tr_TRPOSIX")
            let cDate = dateFormatter.string(from: dat)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH.mm"
            timeFormatter.locale = Locale(identifier: "tr_TRPOSIX")
            let time = timeFormatter.string(from: dat)
            
            let data = [
                "lat" : Double(userLatitude) ?? 0,
                "long" : Double(userLongitude) ?? 0,
                "device" : device,
                "time" : time,
                "date" : cDate,
                "timeDate" : "\(date) - \(time)",
                "accepted" : 1
            ] as [String : Any]
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SignInHistory").addDocument(data: data)
            authenticate()
            
            self.blur = false
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error:NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Hızlı ve güvenli giriş için doğrulamayı geçmelisin"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        if success {
                            self.toMainTabView.toggle()
                            haptic(style: .light)
                        } else {
//                            self.showSensors = true
                        }
                    }
                }
                else {
//                    self.showSensors = true
                }
            })
        }
    }
    
    
    
    func searchPlatformID(nickName : String){
        let ref = Firestore.firestore()
        self.userCanUseThisNickname = false
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let nickname = doc.get("nickname") as? String {
                        if nickname == nickName {
                            self.userCanUseThisNickname = true
                            print(userCanUseThisNickname)
                        }
                    }
                }
            }
        }
    }
}



