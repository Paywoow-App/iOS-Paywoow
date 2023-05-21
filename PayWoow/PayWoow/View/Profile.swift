//
//  Profile.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/11/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import Lottie

struct Profile: View {
    @StateObject var userStore = UserInfoStore()
    @StateObject var myOrdersStore = MyOrdersStore()
    @StateObject var swapRequest = SwapRequestStore()
    @StateObject var netgsmStore = NETGSMStore()
    @StateObject var streammerRequest = MyStreamerRequestStore()
    @StateObject var statics_price = UserStaticsStore_Price()
    @StateObject var statics_diamond = UserStaticsStore_Diamond()
    @StateObject var vipCardStore = VIPCardStore()
    @StateObject var angelStore = AngelStore()
    @StateObject var devilRequestStore = DevilRequestStore()
    @StateObject var angelRequestStore = AngelRequestStore()
    @StateObject var blockTransactionStore = BlockTransactionStore()
    @StateObject var agencyApplicationStore = AgencyApplicationQuestionStore()
    @StateObject var agencyStreamerApplicationStore = AgencyStreamerApplicationStore()
    @StateObject var investStore = InvestorStore()
    @Binding var signOutBlur : Bool
    @State private var toAgencyView : Bool = false
    @State private var toVIPSetting : Bool = false
    @State private var cardTwoFactor = false
    @State private var alertBody : String = ""
    @State private var askToUser = false
    @State private var toSignIn = false
    @State private var taxFreeAlert = false
    @State private var requestGift = false
    @State private var toRemittenceHistory : Bool = false
    @State private var toMyOrders = false
    @State private var showAlert = false
    @State private var currentDate = ""
    @State private var toRequestGiftScreen = false
    @State private var showGiftalert = false
    @State private var toRemittenceMaker : Bool = false
    @State private var showAgain = false
    @State private var requestEmail = ""
    @State private var toMyBills = false
    @State private var showLevel = false
    @State private var showLastOrders = true
    @State private var reloadData = false
    @State private var toMyStreamer = false
    @State private var toMyStreamerRequest = false
    @State private var toDeallerProfile = false
    @State private var toBankInformation  = false
    @State private var toVIPPacks = false
    @State private var toNotifications = false
    @State private var toAgencyGroup = false
    @State private var showMyRefCode = false
    @State private var toAccountManager = false
    @State private var usingPlatform = false
    @State private var toTabView = false
    @State private var openConfetti = false
    @State private var toUserGuide = false
    @State private var showRefCodeCopied = false
    @State private var toSubs = false
    @State private var sliderHeight : CGFloat = CGFloat(110)
    @State private var card_showPasswordReset = false
    @State private var card_oldPassword = ""
    @State private var card_newPassword = ""
    @State private var toInvestDetails : Bool = false
    @State private var card_newPasswordVerify = ""
    @State private var card_phoneVerifyCode = ""
    @State private var card_tempCode = ""
    @State private var card_verifyTimer = 0
    @State private var toTransactionHistory = false
    @State private var showInfoCreditUpload = false
    @State private var toEditProfile = false
    @AppStorage("email") var storeEmail : String = ""
    @AppStorage("showRefCode") var openConfig : Bool = false
    let gradient = Gradient(colors: [.black, .pink])
    @AppStorage("usingPlatform") var usingPlatformPlaceholder : String = "BigoLive"
    @State private var showConffeti = false
    @State private var toLevelFAQ = false
    @State private var level : Int = 10
    @State private var point : Int = 500
    @State private var result : Double = Double(0.0)
    @State private var percent : Int = 0
    @State private var calculatedPoint : Int = 0
    @State private var tabSelection = 2
    @State private var selection = 0
    @State private var barColor = LinearGradient(colors: [Color.init(red: 0 / 255, green: 0 / 255, blue: 0 / 255), Color.init(red: 0 / 255, green: 0 / 255, blue: 0 / 255)], startPoint: .leading, endPoint: .trailing)
    @State private var showCardActivator = false
    @State private var contentSlider = 0
    @State private var showAnimation = false
    @State private var toManagerGroup = false
    @State private var toTaxFreeApplications : Bool = false
    @AppStorage("mainTabViewSelection") var mainTabViewSelection = 0
    //Swap
    @AppStorage("swap_takenUserId") var swap_takenUserId  : String = ""
    @AppStorage("swap_takenlevel") var swap_takenlevel : Int = 0
    @AppStorage("swap_takenfirstName") var swap_takenfirstName  : String = ""
    @AppStorage("swap_takenLastName") var swap_takenLastName  : String = ""
    @AppStorage("swap_takenBigoId ") var swap_takenBigoId  : String = ""
    @AppStorage("swap_takenTimeDate") var swap_takenTimeDate  : String = ""
    @AppStorage("swap_takenDiamond") var swap_takenDiamond : Int = 0
    @AppStorage("swap_takenPfImage") var swap_takenPfImage  : String = ""
    @AppStorage("showSwap") var showMatchSwap : Bool = false
    var body: some View{
        ZStack{
            VStack{
                
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("My Profile")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer(minLength: 0)
                    
                    if self.userStore.myAgencyId != "" {
                        Button {
                            self.toManagerGroup.toggle()
                        } label: {
                            Image(systemName: "quote.bubble")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }
                        .fullScreenCover(isPresented: $toManagerGroup) {
                            AgencyToManagerGroupChat()
                        }
                    }

                    if self.userStore.myAgencyId != "" || self.userStore.streamerAgencyID != "" {
                        Button {
                            self.toAgencyGroup.toggle()
                        } label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                        .fullScreenCover(isPresented: $toAgencyGroup) {
                            if userStore.myAgencyId != "" {
                                AgencyGroupChat(agencyID: userStore.myAgencyId)
                            }
                            else {
                                AgencyGroupChat(agencyID: userStore.streamerAgencyID)
                            }
                        }
                    }
                       
                    
                    Button {
                        self.toNotifications.toggle()
                    } label: {
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                    }
                    
                }
                .padding([.top, .horizontal])
                
                mainBody
                    .tag(0)
                
            }
            
            if self.showMyRefCode == true {
                ZStack{
                    Color.black.opacity(0.00000005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showMyRefCode.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 198 / 255, green: 141 / 255, blue: 143 / 255), Color.init(red: 198 / 255, green: 108 / 255, blue: 138 / 255), Color.init(red: 186 / 255, green: 104 / 255, blue: 131 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            VStack{
                                
                                Text(self.userStore.myRefeanceCode)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.top)
                                
                                Spacer(minLength: 0)
                                
                                Text("Congratulations! Your reference code is above. By sharing this code with your support, it gives a gift to you and the supporter who shopped from the app.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                                
                                Spacer(minLength: 0)
                                
                                Button(action: {
                                    UIPasteboard.general.string = self.userStore.myRefeanceCode
                                    if self.showRefCodeCopied == false {
                                        self.showRefCodeCopied = true
                                    }
                                }, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                        
                                        if showRefCodeCopied == true {
                                            Text("Copied")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18))
                                        }
                                        else {
                                            Text("Copy Referance Code")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18))
                                                .onAppear{
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                                        self.showRefCodeCopied = false
                                                    }
                                                }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                                })
                                .padding(.vertical)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.35)
                        .padding(.bottom, 10)
                    }
                }
            }
            
            if self.showConffeti {
                ZStack{
                    Color.black.opacity(0.0000001).edgesIgnoringSafeArea(.all)
                    
                    
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
            
        }
        .fullScreenCover(isPresented: $toRemittenceMaker, content: {
            RemittenceMaker()
        })
        .fullScreenCover(isPresented: $toMyBills) {
            MyBills()
        }
        .fullScreenCover(isPresented: $toRemittenceHistory) {
            RemittenceHistory()
        }
        .fullScreenCover(isPresented: $toSignIn) {
            LogoScreen()
        }
        .fullScreenCover(isPresented: $toMyOrders) {
            MyOrders()
        }
        .popover(isPresented: $toAccountManager) {
            AccountManagment(signOutBlur: $signOutBlur)
        }
        .popover(isPresented: $toInvestDetails) {
            Invests()
        }
        .popover(isPresented: $toRequestGiftScreen, content: {
            RequestGift(bigoId: userStore.bigoId, email: userStore.email, firstName: userStore.firstName, gift: userStore.gift, giftDate: currentDate, lastName: userStore.lastName, pfImage: userStore.pfImage, level: userStore.level)
        })
        .popover(isPresented: $toSubs) {
            VIPSubs()
        }
        
        .fullScreenCover(isPresented: $toTabView, content: {
            MainTabView(selection: 0, signOutMainTabView: $signOutBlur)
        })
        .onAppear{
            self.showAgain = true
            self.showAnimation = true
            self.showLevel = true
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            self.currentDate = formatter.string(from: date)
            
            statics_price.getData()
            statics_diamond.getData()
            
            //level manager
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                updateLevel()
                self.cardTwoFactor = self.vipCardStore.twoFactor
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .milliseconds(200)) {
                createBarColor()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.openConfetti = true
            }
        }
        .onChange(of: self.userStore.levelPoint, perform: { val in
            updateLevel()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                createBarColor()
            }
        })
        .onChange(of: userStore.level, perform: { val in
            if self.openConfetti {
                if self.userStore.level != level {
                    self.showConffeti.toggle()
                }
                else {
                    self.level = userStore.level
                }
            }
            else {
                
            }
        })
        .onDisappear{
            self.showAgain = false
            self.showLevel = false
            self.showAnimation = false
            self.showMyRefCode = false
        }
        .popover(isPresented: $toMyBills, content: {
            MyBills()
        })
        .popover(isPresented: $toMyStreamerRequest, content: {
            MyStreamerRequests()
        })
        
        .popover(isPresented: $toNotifications, content: {
            Notifications()
        })
        
        .popover(isPresented: $toMyStreamer, content: {
            MyStreamers()
        })
        .popover(isPresented: $toUserGuide, content: {
            UserGuide(goToId: 0)
        })
        .popover(isPresented: $toBankInformation, content: {
            BankInformation()
        })
        .popover(isPresented: $usingPlatform) {
            PlatformsSelector()
        }
        .popover(isPresented: $toTransactionHistory) {
            TransactionHistory()
        }
        .fullScreenCover(isPresented: $toEditProfile) {
            EditProfileScreen()
        }
        .popover(isPresented: $toAgencyView) {
            AgencyView()
        }
//        .fullScreenCover(isPresented: $toTaxFreeApplications){
//            TaxFreeApplication(successAlert: $taxFreeAlert)
//        }
        .alert(isPresented: $taxFreeAlert) {
            Alert(title: Text("Beklemede Kalın!"), message: Text("Başvuru talebiniz bize ulaştı. Yakında iletişim için istediğimiz numara üzerinden sizi arayacağız!"), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .alert(alertBody, isPresented: $showAlert) {
            Button {
                self.showAlert = false
            } label: {
                Text("Ok")
            }

        }
        
        
    }
    
    var mainBody: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                
                TabView{
                    profileContent
                        .tag(0)
                    
                    cardContent
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 390)
                
                
                Group{
                    
                    if self.openConfig == true {
                        GrapicStatics()
                    }
                    
                    
                    
                    
                    TabView(selection: $contentSlider) {
                        
                        VStack{
                            if self.myOrdersStore.lastOrders.isEmpty {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    VStack{
                                        Text("You have not any order")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                        
                                        Button {
                                            self.mainTabViewSelection = 0
                                        } label: {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.white)
                                                
                                                Text("Order Now")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 15))
                                            }
                                            .frame(width: 120, height: 30)
                                        }
                                    }
                                }
                                .frame(height: 100, alignment: Alignment.center)
                                .padding(.horizontal, 10)
                            }
                            else {
                                ForEach(self.myOrdersStore.lastOrders){ item in
                                    MyOrderContent(userId: item.userId, platformID: item.platformID, platform: item.platform, price: item.price, timeStamp: item.timeStamp, transferType: item.transferType, signatureURL: item.signatureURL, hexCodeTop: item.hexCodeTop, hexCodeBottom: item.hexCodeBottom, refCode: item.refCode, product: item.product, streamerGivenGift: item.streamerGivenGift, month: item.month, year: item.year, deallerID: item.deallerID, result: item.result, isProfile: true)
                                }
                            }
                        }.tag(0)
                        
                        Image("VIPButton")
                            .resizable()
                            .frame(height: 100)
                            .clipped()
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .onTapGesture {
                                self.toSubs = true
                            }
                            .tag(1)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(width: UIScreen.main.bounds.width, height: sliderHeight)
                    .cornerRadius(8)
                    
                    
                }
                
                Group{
                    
                    ForEach(agencyApplicationStore.req){ item in
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init(hex: "#1CC4BE"))
                            
                            HStack(spacing: 15){
                                WebImage(url: URL(string: item.pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(item.agencyName)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .bold()
                                    
                                    Text("\(item.firstName) \(item.lastName)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15))
                                    
                                    Text("Bu ajanta yayinci misin?")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                Spacer(minLength: 0)
                                
                                Button {
                                    let ref = Firestore.firestore()
                                    ref.collection("AgencyRequests").document(item.userId).collection("Streamers").document(Auth.auth().currentUser!.uid).setData(["isAccepted" : 1], merge: true)
                                    
                                    sendPushNotify(title: "\(userStore.nickname), teyiti reddetti", body: "Sizin ajansınızda olmadıını bildirdi!", userToken: item.token, sound: "pay.mp3")
                                    
                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyApplicationQuestion").document(item.userId).delete()
                                } label: {
                                    ZStack{
                                        Circle()
                                            .fill(Color.black.opacity(0.5))
                                        
                                        Circle()
                                            .stroke(Color.white)
                                        
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 15, height: 15)
                                    }
                                    .frame(width: 35, height: 35)
                                }
                                
                                Button {
                                    let ref = Firestore.firestore()
                                    ref.collection("AgencyRequests").document(item.userId).collection("Streamers").document(Auth.auth().currentUser!.uid).setData(["isAccepted" : 2], merge: true)
                                    sendPushNotify(title: "Tebrikler!", body: "\(userStore.nickname)' sizin ajansınızda, yayıncı olduğunu doğruladı!", userToken: item.token, sound: "pay.mp3")
                                    ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("AgencyApplicationQuestion").document(item.userId).delete()
                                } label: {
                                    ZStack{
                                        Circle()
                                            .fill(Color.white)
                                        
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.black)
                                            .frame(width: 15, height: 15)
                                    }
                                    .frame(width: 35, height: 35)
                                }
                                
                            }
                            .padding(10)
                        }
                        .frame(height: 100)
                        .padding(.horizontal, 10)
                    }
                    
                    ForEach(agencyStreamerApplicationStore.requests){ item in
                        AgencyStreamerApplicationContent(agencyUserId: item.agencyUserId, pfImage: item.pfImage, firstName: item.firstName, lastName: item.lastName, nickname: item.nickname, platformID: item.platformID, platformName: item.platformName, token: item.token, timeDate: item.timeDate, agencyName: item.agencyName, agencyID: item.agencyID)
                    }

                    ForEach(blockTransactionStore.list) { item in
                        BlockTransactionContent(angelID: item.angelID, classTitle: item.classTitle, desc: item.desc, devilID: item.devilID, point: item.point, product: item.product, productType: item.productType, step: item.step, step0Time: item.step0Time, step1Time: item.step1Time, step2Time: item.step2Time, step3Time: item.step3Time, step4Time: item.step4Time, step5Time: item.step5Time, step6Time: item.step6Time, step7Time: item.step7Time, stepUserID: item.stepUserID, timeStamp: item.timeStamp, docID: item.docID)
                    }
                    
                    ForEach(swapRequest.list){ item in
                        SwapRequestContent(userID: item.userID, product: item.product, productType: item.productType, timeStamp: item.timeStamp, platform: item.platform, country: item.country, docID: item.docID)
                    }
                    
                    
                    Button {
                        self.toAccountManager.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, -5)
                                
                                
                                Text("Account Managment")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                    }
                    
                    if self.userStore.myRefeanceCode != "" {
                        Button {
                            self.showMyRefCode.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                
                                HStack{
                                    
                                    Image(systemName: "link")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 10)
                                    
                                    Text("Reference Code")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .colorScheme(.dark)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                    
                                }
                            }
                            
                            .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                            
                        }
                    }
                    
                    
                    
                    
                    
                    if self.investStore.totalPrice != 0 {
                        Button {
                            self.toInvestDetails.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "dollarsign.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 18, height: 18)
                                        .padding(.leading, -5)
                                    
                                    
                                    Text("Yatırımlarım")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                        }
                    }
                    
                    
                    Group {
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
                                        .frame(width: 18, height: 18)
                                        .padding(.leading, -5)
                                    
                                    
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
                        
                        if userStore.vipType != "Casper" {
                            Button {
                                self.toVIPSetting.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    HStack{
                                        
                                        Image(systemName: "crown")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 18, height: 18)
                                            .padding(.leading, -5)
                                        
                                        
                                        Text("VIP Özelliklerim")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                        
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
                            }
                            .popover(isPresented: $toVIPSetting) {
                                VIPSettings()
                            }
                        }
                    }
                    
                    
                    if self.userStore.accountLevel != 1 {
                        Button {
                            self.toBankInformation.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                
                                HStack{
                                    
                                    Image(systemName: "creditcard.and.123")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 10)
                                    
                                    
                                    Text("Banka Informations")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .colorScheme(.dark)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                    
                                }
                            }
                            
                            .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                            
                        }
                    }
                    
                    
                    
                }
                
//                if userStore.accountLevel == 0 || userStore.accountLevel == 2 {
//                    Button {
//                        self.toTaxFreeApplications.toggle()
//                    } label: {
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.black.opacity(0.2))
//
//
//                            HStack{
//
//                                Image(systemName: "doc.on.doc")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .foregroundColor(.white)
//                                    .frame(width: 20, height: 20)
//                                    .padding(.leading, 10)
//
//                                Text("Tax Free Application")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 18))
//                                    .colorScheme(.dark)
//
//                                Spacer()
//
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.white)
//                                    .padding(.trailing)
//
//                            }
//                        }.frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
//                    }
//                }
                
                
                if self.userStore.myAgencyId != "" {
                    Button {
                        self.toAgencyView.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            
                            HStack{
                                
                                Image(systemName: "building")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("My Agency")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                        
                    }
                }
                
                
                Button {
                    self.toMyOrders.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        
                        HStack{
                            
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                            
                            Text("Orders")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                            
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                    
                }
                
                
                Button {
                    self.toRemittenceHistory.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        
                        HStack{
                            Image(systemName: "repeat")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                            
                            Text("Havale / EFT Geçmişi")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                            
                        }
                    }
                    
                    .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                    
                }
                
                Button {
                    self.toUserGuide.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        
                        HStack{
                            
                            Image(systemName: "book")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                            
                            Text("User Guide")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                            
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                }
                
                Button {
                    
                    if ( self.userStore.vipType == "Casper" || self.userStore.vipType == "VIPSILVER" ) && self.userStore.gift < 1000 && self.userStore.referanceCode == ""{
                        self.alertBody = "En az 1000 hediyeye sahip olmalısın"
                        self.showAlert = true
                    }
                    else if ( self.userStore.vipType == "Casper" || self.userStore.vipType == "VIPSILVER" ) && self.userStore.gift >= 1000 && self.userStore.referanceCode == ""{
                        self.toRequestGiftScreen.toggle()
                    }
                    else if ( self.userStore.vipType == "VIPGOLD" || self.userStore.vipType == "VIPBLACK" ) && self.userStore.gift < 10000 && self.userStore.referanceCode == ""{
                        self.alertBody = "VIP GOLD veya VIP BLACK olarak çekim talebinde bulunabilmek için en az 10000 hediyeye shaip olmalısın"
                        self.showAlert = true
                    }
                    else if ( self.userStore.vipType == "VIPGOLD" || self.userStore.vipType == "VIPBLACK" ) && self.userStore.gift >= 10000 && self.userStore.referanceCode == ""{
                        self.toRequestGiftScreen.toggle()
                    }
                    else if self.userStore.referanceCode == "" && self.userStore.gift >= 1000 {
                        self.toRequestGiftScreen.toggle()
                    }
                    else if self.userStore.referanceCode == "" && self.userStore.gift < 1000 {
                        self.alertBody = "En az 1000 hediyeye sahip olmalısın"
                        self.showAlert = true
                    }
                    else if self.userStore.referanceCode != "" && self.userStore.gift >= 10000 {
                        self.toRequestGiftScreen.toggle()
                    }
                    else if self.userStore.referanceCode != "" && self.userStore.gift < 10000 {
                        self.alertBody = "Referans kodu sahibi olarak en az 10000 hediyeye sahip olmalısın"
                        self.showAlert = true
                    }
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        
                        HStack{
                            
                            Image(systemName: "target")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                            
                            Text("Pull Requests")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .colorScheme(.dark)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding(.trailing)
                            
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95 ,height: 50, alignment: Alignment.center)
                    
                }
                
            }
        }
    }
    
    var cardContent: some View {
        
        VStack{
            ZStack{
            if self.vipCardStore.cardType == "VIP GOLD" {
                ZStack{
                    Image("goldCard")
                        .resizable()
                        .scaledToFit()
                    
                    VStack{
                        Spacer()
                        HStack{
                            Text("\(userStore.nickname)")
                                .foregroundColor(Color.init(hex: "#BAA775"))
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .padding(.leading, 30)
                            
                            Spacer()
                        }
                        .padding(.bottom, 50)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            else if self.vipCardStore.cardType == "VIP BLACK" {
                ZStack{
                    Image("blackCard")
                        .resizable()
                        .scaledToFit()
                    
                    VStack{
                        Spacer()
                        HStack{
                            Text("\(userStore.nickname)")
                                .foregroundColor(Color.init(hex: "#252424"))
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .padding(.leading, 30)
                            
                            Spacer()
                        }
                        .padding(.bottom, 50)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            else if self.vipCardStore.cardType == "VIP SILVER" {
                ZStack{
                    Image("grayCard")
                        .resizable()
                        .scaledToFit()
                    
                    VStack{
                        Spacer()
                        HStack{
                            Text("\(userStore.nickname)")
                                .foregroundColor(Color.init(hex: "#989797"))
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .padding(.leading, 30)
                            
                            Spacer()
                        }
                        .padding(.bottom, 50)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            else if self.vipCardStore.cardType == "Casper" {
                
                ZStack{
                    Image("casperCard")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                    
                    VStack{
                        
                        Spacer(minLength: 0)
                        
                        HStack{
                            Text("\(userStore.nickname)")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .padding(.leading, 30)
                            
                            Spacer()
                        }
                        .padding(.bottom, 50)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
            }
            
            HStack{
                Text("\(vipCardStore.totalPrice)₺")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                
                if Auth.auth().currentUser != nil {
                    if self.angelStore.devils.contains(where: {$0.userID == Auth.auth().currentUser!.uid}){
                        Image(systemName: "circle.slash")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                    }
                }
                
                
                Spacer(minLength: 0)
            }
            .padding(.leading, 50)
        }

            
            HStack{
                Button {
                    self.toRemittenceMaker.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white)
                        
                        HStack(spacing: 10){
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                            Text("Bakiye Yükle")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Button {
                    self.mainTabViewSelection = 0
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                            
                            Text("Bakiye Kullan")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                }
                
            }
            .frame(height: 45)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
    
    var profileContent: some View {
        VStack{
            
            if self.userStore.vipType == "Casper" {
                AnimatedImage(url: URL(string: self.userStore.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 180, height: 180)
                    .onTapGesture {
                        toEditProfile.toggle()
                    }
            }
            else {
                ZStack{
                    AnimatedImage(url: URL(string: self.userStore.pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 180, height: 180)
                        .onTapGesture {
                            toEditProfile.toggle()
                        }
                    
                    
                    if self.showAnimation == true {
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
                    toEditProfile.toggle()
                }
            }
            
            
            Text(self.userStore.nickname)
                .foregroundColor(.white)
                .font(.system(size: 22))
                .onAppear{
                    self.requestEmail = "\(userStore.email)"
                }
                .padding(.vertical, 10)
            
            HStack{
                VStack{
                    Image(systemName: "gift")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20, alignment: Alignment.center)
                }
                
                
                Text("\(userStore.gift)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                if self.userStore.verify {
                    Image("checkmarkNew")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                ForEach(self.userStore.levelStore){item in
                    LevelContentProfile(level: item.level)
                        .onTapGesture {
                            self.toLevelFAQ.toggle()
                        }
                        .popover(isPresented: $toLevelFAQ) {
                            LevelFAQ()
                        }
                        .scaleEffect(0.8)
                        .padding(.leading, -5)
                }
                
                
                if self.userStore.vipType == "VIPSILVER" {
                    LottieView(name: "rosette_silver", loopMode: .loop, speed: 1)
                        .frame(width: 40, height: 40)
                        .padding(.leading, -5)
                }
                else if self.userStore.vipType == "VIPBLACK" {
                    LottieView(name: "rosette_black", loopMode: .loop, speed: 1)
                        .frame(width: 40, height: 40)
                        .padding(.leading, -5)
                }
                else if self.userStore.vipType == "VIPGOLD" {
                    LottieView(name: "rosette_gold", loopMode: .loop, speed: 1)
                        .frame(width: 40, height: 40)
                        .padding(.leading, -5)
                }
                
//                if self.angelStore.availableOnAngels == true {
//                    LottieView(name: "wings_white", loopMode: .loop)
//                        .frame(width: 40, height: 40)
//                        .scaleEffect(1.5)
//                        .offset(x: 0, y: 2)
//                        .padding(.leading, 5)
//                }
//                if self.angelStore.availableOnDevils == true {
//                    LottieView(name: "wings_red", loopMode: .loop)
//                        .frame(width: 40, height: 40)
//                        .scaleEffect(1.5)
//                        .padding(.leading, 5)
//                }
//                
                Spacer(minLength: 0)
                
                if self.userStore.bigoId != ""{
                    Text("@\(userStore.bigoId)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                else {
                    Button {
                        toEditProfile.toggle()
                    } label: {
                        Text("ID'nizi girin")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            ZStack{
                HStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: 5)
                    
                    Spacer(minLength: 0)
                }
                
                HStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(barColor)
                        .frame(width: UIScreen.main.bounds.width * result, height: 5)
                    
                    
                    Spacer(minLength: 10)
                    
                    if self.userStore.level != 100 {
                        Text("%\(percent)")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.light)
                    }
                    else {
                        Text("MAX")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.light)
                    }
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .animation(.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 2))
        }
    }
    
    
    func updateLevel(){
        
        if self.userStore.levelPoint >= 1000 && self.userStore.levelPoint <= 2000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 1], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1000
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
        }
        
        if self.userStore.levelPoint >= 2001 && self.userStore.levelPoint <= 3000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 2], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 3001 && self.userStore.levelPoint <= 4000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 3], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 4001 && self.userStore.levelPoint <= 5000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 4], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 5001 && self.userStore.levelPoint <= 6000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 5], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 6001 && self.userStore.levelPoint <= 7000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 6], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 6001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 7001 && self.userStore.levelPoint <= 8000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 7], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 7001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 8001 && self.userStore.levelPoint <= 9000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 8], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 8001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 9001 && self.userStore.levelPoint <= 10000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 9], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 9001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
        }
        
        if self.userStore.levelPoint >= 10001 && self.userStore.levelPoint <= 11000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 10], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 10001
            self.percent = Int(Double(calculatedPoint) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 11001 && self.userStore.levelPoint <= 14000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 11], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 11001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 14001 && self.userStore.levelPoint <= 17000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 12], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 14001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 17001 && self.userStore.levelPoint <= 20000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 13], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 17001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 20001 && self.userStore.levelPoint <= 23000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 14], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 20001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 23001 && self.userStore.levelPoint <= 26000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 15], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 23001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 26001 && self.userStore.levelPoint <= 29000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 16], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 26001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 29001 && self.userStore.levelPoint <= 32000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 17], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 29001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 32001 && self.userStore.levelPoint <= 35000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 18], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 32001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 35001 && self.userStore.levelPoint <= 38000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 19], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 35001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 38001 && self.userStore.levelPoint <= 41000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 20], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 38001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 41001 && self.userStore.levelPoint <= 44000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 21], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 41001
            let update = calculatedPoint / 3
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 44001 && self.userStore.levelPoint <= 54000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 22], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 44001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 54001 && self.userStore.levelPoint <= 64000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 23], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 54001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 64001 && self.userStore.levelPoint <= 74000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 24], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 64001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 74001 && self.userStore.levelPoint <= 84000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 25], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 74001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 84001 && self.userStore.levelPoint <= 94000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 26], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 84001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 94001 && self.userStore.levelPoint <= 104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 27], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 94001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        
        if self.userStore.levelPoint >= 104001 && self.userStore.levelPoint <= 114000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 28], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 104001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 114001 && self.userStore.levelPoint <= 124000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 29], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 114001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 124001 && self.userStore.levelPoint <= 134000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 30], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 124001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 134001 && self.userStore.levelPoint <= 144000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 31], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 134001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 144001 && self.userStore.levelPoint <= 154000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 32], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 144001
            let update = calculatedPoint / 10
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 154001 && self.userStore.levelPoint <= 204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 33], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 154001
            self.percent = 50000 / 5000 * (calculatedPoint / 5000)
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 204001 && self.userStore.levelPoint <= 254000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 34], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 204001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 254001 && self.userStore.levelPoint <= 304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 35], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 254001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 304001 && self.userStore.levelPoint <= 354000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 36], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 304001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 354001 && self.userStore.levelPoint <= 404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 37], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 354001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 404001 && self.userStore.levelPoint <= 454000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 38], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 404001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 454001 && self.userStore.levelPoint <= 504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 39], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 454001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 504001 && self.userStore.levelPoint <= 554000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 40], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 504001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        
        if self.userStore.levelPoint >= 554001 && self.userStore.levelPoint <= 604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 41], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 554001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 604001 && self.userStore.levelPoint <= 654000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 42], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 604001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 654001 && self.userStore.levelPoint <= 704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 43], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 654001
            let update = calculatedPoint / 50
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 704001 && self.userStore.levelPoint <= 804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 44], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 704001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 804001 && self.userStore.levelPoint <= 904000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 45], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 804001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 904000 && self.userStore.levelPoint <= 1004000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 46], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 904000
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1004001 && self.userStore.levelPoint <= 1104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 47], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1004001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1104001 && self.userStore.levelPoint <= 1204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 48], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1104001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1204001 && self.userStore.levelPoint <= 1304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 49], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1204001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1304001 && self.userStore.levelPoint <= 1404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 50], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1304001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1404001 && self.userStore.levelPoint <= 1504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 51], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1404001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1504001 && self.userStore.levelPoint <= 1604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 52], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1504001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1604001 && self.userStore.levelPoint <= 1704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 53], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1604001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1704001 && self.userStore.levelPoint <= 1804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 54], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1704001
            let update = calculatedPoint / 100
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 1804001 && self.userStore.levelPoint <= 2104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 55], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 1804001
            print("hereeeeeeee \(calculatedPoint)")
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2104001 && self.userStore.levelPoint <= 2404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 56], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2404001 && self.userStore.levelPoint <= 2704000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 57], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 2704001 && self.userStore.levelPoint <= 3004000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 58], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 2704001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3004001 && self.userStore.levelPoint <= 3304000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 59], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3004001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3304001 && self.userStore.levelPoint <= 3604000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 60], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3304001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3604001 && self.userStore.levelPoint <= 3904000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 61], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3604001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 3904001 && self.userStore.levelPoint <= 4204000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 62], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 3904001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4204001 && self.userStore.levelPoint <= 4504000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 63], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4204001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4504001 && self.userStore.levelPoint <= 4804000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 64], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4504001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 4804000 && self.userStore.levelPoint <= 5104000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 65], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 4804000
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 5104001 && self.userStore.levelPoint <= 5404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 66], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5104001
            let update = calculatedPoint / 300
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 5404001 && self.userStore.levelPoint <= 6404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 67], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 5404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 6404001 && self.userStore.levelPoint <= 7404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 68], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 6404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 7404001 && self.userStore.levelPoint <= 8404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 69], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 7404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 8404001 && self.userStore.levelPoint <= 9404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 70], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 8404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 9404001 && self.userStore.levelPoint <= 10404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 71], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 9404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 10404001 && self.userStore.levelPoint <= 11404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 72], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 10404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 11404001 && self.userStore.levelPoint <= 12404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 73], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 11404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 12404001 && self.userStore.levelPoint <= 13404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 74], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 12404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 13404001 && self.userStore.levelPoint <= 14404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 75], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 13404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 14404001 && self.userStore.levelPoint <= 15404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 76], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 14404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 15404001 && self.userStore.levelPoint <= 16404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 77], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 15404001
            let update = calculatedPoint / 1000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 16404001 && self.userStore.levelPoint <= 21404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 78], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 16404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 21404001 && self.userStore.levelPoint <= 26404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 79], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 21404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 26404001 && self.userStore.levelPoint <= 31404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 80], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 26404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 31404001 && self.userStore.levelPoint <= 36404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 81], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 31404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 36404001 && self.userStore.levelPoint <= 41404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 82], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 36404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 41404001 && self.userStore.levelPoint <= 46404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 83], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 41404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 46404001 && self.userStore.levelPoint <= 51404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 84], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 46404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 51404001 && self.userStore.levelPoint <= 56404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 85], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 51404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 56404001 && self.userStore.levelPoint <= 61404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 86], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 56404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 61404001 && self.userStore.levelPoint <= 66404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 87], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 61404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 66404001 && self.userStore.levelPoint <= 71404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 88], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 66404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 71404001 && self.userStore.levelPoint <= 76404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 89], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 71404001
            let update = calculatedPoint / 5000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 76404001 && self.userStore.levelPoint <= 86404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 90], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 76404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 86404001 && self.userStore.levelPoint <= 96404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 91], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 86404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 96404001 && self.userStore.levelPoint <= 106404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 92], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 96404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 106404001 && self.userStore.levelPoint <= 116404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 93], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 106404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 116404001 && self.userStore.levelPoint <= 126404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 94], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 116404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 126404000 && self.userStore.levelPoint <= 136404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 95], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 126404000
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 136404001 && self.userStore.levelPoint <= 146404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 96], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 136404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 146404001 && self.userStore.levelPoint <= 156404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 97], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 146404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
            
        }
        
        
        if self.userStore.levelPoint >= 156404001 && self.userStore.levelPoint <= 166404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 98], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 156404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        if self.userStore.levelPoint >= 166404001 && self.userStore.levelPoint <= 176404000 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 99], merge: true)
            let calculatedPoint = self.userStore.levelPoint - 166404001
            let update = calculatedPoint / 10000
            self.percent = Int(Double(update) * 0.1) //OK
            let step2 = Double(750 * percent)
            self.result = step2 / 100000
            
            
        }
        
        
        if self.userStore.levelPoint >= 176404001 {
            let ref = Firestore.firestore()
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["level" : 100], merge: true)
            self.result = 0.75
            self.percent = 100
        }
        
        
        
    }
    
    func createBarColor(){
        if self.userStore.level >= 1 && self.userStore.level <= 11 {
            self.barColor = LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 12 && self.userStore.level <= 22 {
            self.barColor = LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 23 && self.userStore.level <= 33 {
            self.barColor = LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 34 && self.userStore.level <= 44 {
            self.barColor = LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 45 && self.userStore.level <= 55 {
            self.barColor = LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 56 && self.userStore.level <= 66 {
            self.barColor = LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 180 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 67 && self.userStore.level <= 77 {
            self.barColor = LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        if self.userStore.level >= 78 && self.userStore.level <= 88 {
            self.barColor = LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing)
        }
        
        
        if self.userStore.level >= 89 && self.userStore.level <= 100 {
            self.barColor = LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing)
        }
    }
    
}





/*
 
 VStack{ //card
 
 ScrollView(.vertical, showsIndicators: false){
 
 if self.vipCardStore.cardType == "VIP GOLD" {
 ZStack{
 Image("goldCard")
 .resizable()
 .scaledToFit()
 
 VStack{
 Spacer()
 HStack{
 Text("\(userStore.nickname)")
 .foregroundColor(Color.init(hex: "#BAA775"))
 .font(.system(size: 20))
 .fontWeight(.medium)
 .padding(.leading, 30)
 
 Spacer()
 }
 .padding(.bottom, 50)
 }
 }
 .frame(height: 280)
 .padding(.horizontal, 20)
 .padding(.bottom, 20)
 }
 else if self.vipCardStore.cardType == "VIP BLACK" {
 ZStack{
 Image("blackCard")
 .resizable()
 .scaledToFit()
 
 VStack{
 Spacer()
 HStack{
 Text("\(userStore.nickname)")
 .foregroundColor(Color.init(hex: "#252424"))
 .font(.system(size: 20))
 .fontWeight(.medium)
 .padding(.leading, 30)
 
 Spacer()
 }
 .padding(.bottom, 50)
 }
 }
 .frame(height: 280)
 .padding(.horizontal, 20)
 .padding(.bottom, 20)
 }
 else if self.vipCardStore.cardType == "VIP SILVER" {
 ZStack{
 Image("grayCard")
 .resizable()
 .scaledToFit()
 
 VStack{
 Spacer()
 HStack{
 Text("\(userStore.nickname)")
 .foregroundColor(Color.init(hex: "#989797"))
 .font(.system(size: 20))
 .fontWeight(.medium)
 .padding(.leading, 30)
 
 Spacer()
 }
 .padding(.bottom, 50)
 }
 }
 .frame(height: 280)
 .padding(.horizontal, 20)
 .padding(.bottom, 20)
 }
 
 HStack{
 Text("VIP Türü :")
 .foregroundColor(.white)
 .font(.system(size: 18))
 .bold()
 
 Spacer()
 
 ZStack{
 if self.vipCardStore.cardType == "VIP GOLD" {
 Capsule()
 .fill(LinearGradient(colors: [Color.init(hex: "#EDDDB3"), Color.init(hex: "#D3C08B")], startPoint: .topLeading, endPoint: .bottomTrailing))
 
 Spacer(minLength: 0)
 
 Text("VIP GOLD")
 .foregroundColor(.white)
 .font(.system(size: 16))
 .bold()
 }
 else if self.vipCardStore.cardType == "VIP SILVER" {
 Capsule()
 .fill(LinearGradient(colors: [Color.init(hex: "#FFFFFF"), Color.init(hex: "#A2A2A2")], startPoint: .topLeading, endPoint: .bottomTrailing))
 
 Spacer(minLength: 0)
 
 Text("VIP SILVER")
 .foregroundColor(.white)
 .font(.system(size: 16))
 .bold()
 }
 else if self.vipCardStore.cardType == "VIP BLACK" {
 Capsule()
 .fill(LinearGradient(colors: [Color.init(hex: "#000000"), Color.init(hex: "#606060")], startPoint: .topLeading, endPoint: .bottomTrailing))
 
 Spacer(minLength: 0)
 
 Text("VIP BLACK")
 .foregroundColor(.white)
 .font(.system(size: 16))
 .bold()
 }
 }
 .frame(width: 100, height: 23)
 }
 .padding(.horizontal)
 
 
 VStack(spacing: 10){
 HStack{
 Text("Bakiye:")
 .foregroundColor(.white)
 .font(.system(size: 18))
 .bold()
 
 Spacer()
 
 
 Text("\(self.vipCardStore.totalDiamond)")
 .foregroundColor(.white)
 .font(.system(size: 16))
 }
 .padding(.horizontal)
 
 HStack{
 Text("Kart Numarası :")
 .foregroundColor(.white)
 .font(.system(size: 18))
 .bold()
 
 Spacer(minLength: 0)
 
 Text(self.vipCardStore.cardNo[0 ..< 4])
 .foregroundColor(.white)
 .font(.system(size: 16))
 
 Text("****")
 .foregroundColor(.white)
 .font(.system(size: 16))
 
 Text("****")
 .foregroundColor(.white)
 .font(.system(size: 16))
 
 Text(self.vipCardStore.cardNo[12 ..< 16])
 .foregroundColor(.white)
 .font(.system(size: 16))
 }
 .padding(.horizontal)
 
 HStack{
 Text("Expiry Date")
 .foregroundColor(.white)
 .font(.system(size: 18))
 .bold()
 
 Spacer(minLength: 0)
 
 Text(self.vipCardStore.expiryDate)
 .foregroundColor(.white)
 .font(.system(size: 16))
 }
 .padding(.horizontal)
 }
 
 }
 }
 */


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
