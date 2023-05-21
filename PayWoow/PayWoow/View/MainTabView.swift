//
//  SwiftUIView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/29/21.
//

import SwiftUI
import Firebase
import UserNotifications
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import MapKit
import Lottie
import DeviceKit
import SDWebImageSwiftUI
import Network

struct MainTabView: View {
    
 
    
    @StateObject var userStore = UserInfoStore()
    @StateObject var notify = NotificationsStore()
    @StateObject var generalStore = GeneralStore()
    @StateObject var statics_price = UserStaticsStore_Price()
    @StateObject var statics_diamond = UserStaticsStore_Diamond()
    @StateObject var sentvippointcontrol = SentVipPointControl()
    @StateObject var netgsmStore = NETGSMStore()
    @StateObject var angelStore = AngelStore()
    @StateObject var vipInfo = VIPInfo()
    @Environment(\.presentationMode) var present
    @AppStorage("userDeviceToken") var userDeviceToken : String = ""
    @AppStorage("usingPlatform") var usingPlatformPlaceholder : String = "BigoLive"
    @AppStorage("verifyEmail") var verifyEmail : String = ""
    @AppStorage("verifyPassword") var verifyPassword : String = ""
    @AppStorage("netgsmNumber") var netgsm_saved_phoneNumber = ""
    @AppStorage("currentYear") var currentYear: String = ""
    @AppStorage("email") var storeEmail : String = ""
    @AppStorage("vipSelection") var VipSelection = "n" // Dont Forget
    @AppStorage("mainTabViewSelection") var selection = 0
    @AppStorage("securityToken") var token : String = ""
    @State private var showNotify = false
    @Binding var signOutMainTabView : Bool
    @State private var showDM = false
    @State private var showAddBankCard = false
    @State private var showConffeti = false
    @State private var showQuestionsTop50 = false
    @AppStorage("level") var level : Int = 0
    @State var toLogoScreen = false
    @State private var toSwapMessanger = false
    @AppStorage("isNewUser") var isNewUser : Bool = false
    @State private var device = ""
    @State private var trustDeviceSelector = 0
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.00 , longitude: 0.00), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @StateObject var locationManager = LocationManager()
    @State private var verifyCode = ""
    @State private var verifyError = false
    @State private var tempCode = 8855
    @AppStorage("verifiedNumber") var verifiedNumber: String = ""
    @State private var temporaryTime = false
    @State private var verifyOpacity : CGFloat = CGFloat(0)
    @State private var beDevil = false
    @State private var beAngel  = false
    @State private var keyboardHider : Bool = false
    @State private var showBottomBar : Bool = true
    
    @State private var signOutBlur : Bool = false
    
    @AppStorage("orderWriterBayiId") var orderWriterBayiId = ""
    @AppStorage("toOrderWriter") var toOrderWriter = false
    
    @State private var showPopup = false
    @State private var classSelection = 0
    @State private var barHeight : CGFloat = CGFloat(538)
    @State private var requestTitle: String = ""
    @State private var totalPoint = 0
    @State private var requestSelection = 0
    @State private var classTitle : String = ""
    
    //Swap
    @State var main_platformId : String = ""
    @State var main_platformName : String = ""
    @State var main_country : String = ""
    @State var main_diamond : Int = 0
    @State var main_firstName : String = ""
    @State var main_lastName : String = ""
    @State var main_level : Int = 0
    @State var main_nickname : String = ""
    @State var main_pfImage : String = ""
    @State var main_timeDate : String = ""
    @State var main_userID : String = ""
    @State var main_vipType : String = ""
    @State var main_token : String = ""
    @State var showMatchSwap : Bool = false
    
    
    
    @State private var lottieScale : CGFloat = 1.8
    @State private var offsetY : CGFloat = -3
    @State private var successAlert : Bool = false
    
    @State private var internetProblem : Bool = false
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                if self.userStore.accountLevel == 0{
                    
                    if selection == 0 {
                        OfficalDealler()
                    }
                    else if selection == 1 {
                        Swap(showBottomBar: $showBottomBar)
                    }
                    else if selection == 2 {
                        BlockServices(store: angelStore, showBottomBar: $showBottomBar)
                    }
                    else if selection == 3{
                        VStack{
                            if userStore.isComplatedTax {
                                PaymentSalary()
                            }
                            else {
                                TaxFreeApplication(successAlert: $successAlert, showBackButton: false)
                            }
                        }
                    }
                    else if selection == 4 {
                        Top50().tag(4)
                    }
                    else if selection == 5 {
                        Profile(signOutBlur: $signOutBlur).tag(5)
                    }
                    else {
                        VStack{
                            
                        }.onAppear{
                            self.selection = 0
                        }
                    }
                }
                else if self.userStore.accountLevel == 2{
                    
                    if selection == 0 {
                        OfficalDealler()
                    }
                    else if selection == 1 {
                        Swap(showBottomBar: $showBottomBar)
                    }
                    else if selection == 2 {
                        BlockServices(store: angelStore, showBottomBar: $showBottomBar)
                    }
                    else if selection == 3{
                        VStack{
                            if userStore.isComplatedTax {
                                PaymentSalary()
                            }
                            else {
                                TaxFreeApplication(successAlert: $successAlert, showBackButton: false)
                            }
                        }
                    }
                    else if selection == 4 {
                        Top50().tag(4)
                    }
                    else if selection == 5 {
                        Profile(signOutBlur: $signOutBlur).tag(5)
                    }
                    else {
                        VStack{
                            
                        }.onAppear{
                            self.selection = 0
                        }
                    }
                }
                
                else if self.userStore.accountLevel == 1 {
                    
                    if selection == 0 {
                        OfficalDealler()
                    }
                    else if selection == 1 {
                        BankInformation(forTabView: false)
                    }
                    else if selection == 2 {
                        BlockServices(store: angelStore, showBottomBar: $showBottomBar)
                    }
                    else if selection == 3 {
                        Top50()
                    }
                    else if selection == 4 {
                        MyOrders(forTabView: true)
                    }
                    else if selection == 5 {
                        Profile(signOutBlur: $signOutBlur).tag(4)
                    }
                    else {
                        VStack{
                            
                        }.onAppear{
                            self.selection = 0
                        }
                    }
                }
                
                else if self.userStore.accountLevel == 3 {
                    if selection == 0 {
                        ManagerAgencyGroups()
                    }
                    else if selection == 1 {
                        ManagerDocs()
                    }
                    else if selection == 2 {
                        ManagerAgencyDeclarations()
                    }
                    
                    else if selection == 3 {
                        ManagerAgencyInfo()
                    }
                    else if selection == 4 {
                        ManagerStreamerDemos()
                    }
                    else if selection == 5 {
                        ManagerProfile()
                    }
                    else {
                        VStack{
                            
                        }.onAppear{
                            self.selection = 5
                        }
                    }
                }
                if showBottomBar {
                    BottomBar(selection: $selection)
                }
                
            }// vstack end
            .blur(radius: internetProblem ? 11 : 0)
            .fullScreenCover(isPresented: $toOrderWriter, onDismiss: {
                self.orderWriterBayiId = "Nil"
                self.toOrderWriter = false
            }, content: {
                OrderMaker(bayiiId: orderWriterBayiId, selectedApp: userStore.selectedPlatform)
            })
            .allowsHitTesting(!isNewUser)
            .blur(radius: isNewUser ? 11 : 0)
            .alert(isPresented: $successAlert) {
                Alert(title: Text("Beklemede Kalın!"), message: Text("Başvuru talebiniz bize ulaştı. Yakında iletişim için istediğimiz numara üzerinden sizi arayacağız!"), dismissButton: Alert.Button.default(Text("Tamam")))
            }
            .onChange(of: Auth.auth().currentUser?.uid) { val in
                if val == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)){
                        self.signOutBlur = false
                        self.present.wrappedValue.dismiss()
                    }
                }
            }
            .onChange(of: signOutBlur) { val in
                self.signOutMainTabView = val
            }
            Group{
                
                if self.isNewUser {
                    NewUserDetails()
                        .background(Color.black.opacity(0.4))
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                
                if userStore.block {
                    ZStack{
                        Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 40){
                            
                            LottieView(name: "blockedAccount", loopMode: .playOnce)
                                .frame(width: 150, height: 150)
                            
                            Text("Your account was blocked")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                            
                            
                            Text(self.userStore.blockDesc)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button {
                                let mailtoString = "mailto:destek@paywoow.com?subject=Desteğe ihtiyacım var! &body=Merhaba\nBen \(self.userStore.firstName) \(self.userStore.lastName)\nUserId: \(Auth.auth().currentUser!.uid)\nBigoId: \(self.userStore.bigoId)\nHesabım banlanmıştır. Yardım lütfen".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let mailtoUrl = URL(string: mailtoString!)!
                                if UIApplication.shared.canOpenURL(mailtoUrl) {
                                    UIApplication.shared.open(mailtoUrl, options: [:])
                                }
                            } label: {
                                ZStack{
                                    Capsule()
                                        .fill(Color.white)
                                    
                                    Text("Contact Us")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                .frame(width: 200, height: 40)
                            }
                            
                            Button {
                                self.storeEmail = self.userStore.email
                                self.verifyEmail = ""
                                self.verifyPassword = ""
                                self.netgsm_saved_phoneNumber = ""
                                try? Auth.auth().signOut()
                                self.toLogoScreen.toggle()
                            } label: {
                                Text("Sign Out")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            .fullScreenCover(isPresented: $toLogoScreen) {
                                self.toLogoScreen = true
                            } content: {
                                LogoScreen()
                            }
                        }
                    }
                }
                
                if signOutBlur == true {
                    ZStack{
                        Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20){
                            
                            ProgressView()
                                .foregroundColor(.white)
                                .colorScheme(.light)
                                .scaleEffect(2)
                            
                            Text("Çıkış Yapılıyor")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                if self.generalStore.lockApp == true {
                    LockAppContent()
                }
            }
            
            if self.showMatchSwap == true {
                ZStack{
                    
                    Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        
                        VStack{
                            AnimatedImage(url: URL(string: self.main_pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100, alignment: Alignment.center)
                            
                            Text("\(self.main_firstName) \(self.main_lastName)")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                            
                            Text("ID : \(self.main_platformId)")
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(.system(size: 20))
                                .fontWeight(.light)
                            
                            
                        }
                        .padding(.top, 20)
                        
                        
                        LottieView(name: "lightning", loopMode: .repeat(2))
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
                                    
                                    let date = Date()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd.MM.yyyy - HH:mm"
                                    let timeDate = formatter.string(from: date)
                                    let ref = Firestore.firestore()
                                    let data = [
                                        "platformId" : userStore.bigoId,
                                        "platformName" : userStore.selectedPlatform,
                                        "country" : main_country,
                                        "diamond" : main_diamond,
                                        "firstName" : userStore.firstName,
                                        "lastName" : userStore.lastName,
                                        "level" : userStore.level,
                                        "nickname" : userStore.nickname,
                                        "pfImage" :  userStore.pfImage,
                                        "timeDate" : timeDate,
                                        "userID" : Auth.auth().currentUser!.uid,
                                        "vipType" : userStore.vipType,
                                        "token" : userStore.token
                                    ] as [String : Any]
                                    
                                    ref.collection("Users").document(main_userID).collection("SwapRequest").document(Auth.auth().currentUser!.uid).setData(data)
                                    ref.collection("AllSwaps").document("Swaps").collection("WaitingSwaps").document(main_userID).delete()
                                    
                                    self.showMatchSwap.toggle()
                                }
                            }
                        
                        
                        VStack{
                            AnimatedImage(url: URL(string: self.userStore.pfImage))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100, alignment: Alignment.center)
                            
                            Text("\(self.userStore.firstName) \(self.userStore.lastName)")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                            
                            Text("ID : \(self.userStore.bigoId)")
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(.system(size: 20))
                                .fontWeight(.light)
                            
                            
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            //
            
            if self.showConffeti {
                ZStack{
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    
                    
                    ConfettiLottieView(name: "levelConfetti", loopMode: .playOnce)
                    
                    VStack(spacing: 20){
                        
                    }.onAppear{
                        haptic(style: .rigid)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                            self.showConffeti.toggle()
                        }
                        playSound(sound: "confetti", type: "mp3")
                    }
                }
            }
            
            if self.internetProblem {
                ZStack{
                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20){
                        LottieView(name: "noInternet", loopMode: .loop, speed: 1.0)
                            .padding(.top)
                            .padding(.horizontal)
                            .padding(.bottom, -100)
                        
                        Text("Oopss!")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .bold()
                        
                        Text("Sanırım internet bağlantınızda bir\nproblem var?")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .onAppear {
            self.orderWriterBayiId = ""
            self.toOrderWriter = false
            self.selection = 0
            self.device = "\(Device.current)"
            let ref = Firestore.firestore()
            if Auth.auth().currentUser != nil {
                ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["token" : userDeviceToken], merge: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                if Auth.auth().currentUser != nil {
                    let ref = Firestore.firestore()
                    let data = ["lat" : Double(userLatitude), "long" : Double(userLongitude)] as! [String : Double]
                    ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                }
            }
            
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            self.currentYear = formatter.string(from: currentDate)
            
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "InternetConnectionMonitor")
            
            monitor.pathUpdateHandler = { pathUpdateHandler in
                if pathUpdateHandler.status == .satisfied {
                    print("Internet connection is on.")
                    self.internetProblem = false
                } else {
                    print("There's no internet connection.")
                    self.internetProblem = true
                }
            }
            
            monitor.start(queue: queue)
            
        }
        .onChange(of: token, perform: { vaal in
            if self.userDeviceToken != vaal {
                do {
                    try Auth.auth().signOut()
                    self.toLogoScreen.toggle()
                }
                catch {
                    //
                }
            }
        })
        
        .sheet(isPresented: $showNotify, onDismiss: {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "MainTabView"], merge: true)
        }, content: {
            Notifications()
        })
        
        .sheet(isPresented: $showAddBankCard, onDismiss: {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "MainTabView"], merge: true)
        }, content: {
            AddBankCard()
        })
        .sheet(isPresented: $showQuestionsTop50, onDismiss: {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "MainTabView"], merge: true)
        }, content: {
            Top50FAQ()
        })
        
        .sheet(isPresented: $toSwapMessanger, onDismiss: {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["current" : "MainTabView"], merge: true)
        }, content: {
            SwapMessageList()
        })
    }
}

struct LockAppContent : View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 30){
                Text("Our app developing on this time")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("We will back soon")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .bold()
                    .multilineTextAlignment(.center)
                
                
                Button {
                    exit(0)
                } label: {
                    ZStack{
                        Capsule()
                            .fill(Color.white)
                        
                        Text("Ok")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                        
                    }
                    .frame(width: 200, height: 50, alignment: Alignment.center)
                }
                
            }
            .padding()
        }
    }
}
