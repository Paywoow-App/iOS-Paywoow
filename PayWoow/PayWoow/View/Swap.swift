//
//  Swap.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import Lottie

struct Swap: View {
    @StateObject var swapStore = SwapStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var general = GeneralStore()
    @StateObject var countryStore = CountryCodeStore()
    @Binding var showBottomBar : Bool
    @State private var selection : Int = 0
    @State private var selectedCountry : String = "Turkey"
    @State private var selectedCountryImage : String = "https://countryflagsapi.com/png/tr"
    @State private var showCountries : Bool = false
    @State private var showSwapMaker : Bool = false
    @State private var selectedSwapProduct : String = "5000"
    
    @State private var selectedSwapUserId : String = ""
    @State private var selectedProduct : Int = 0
    @State private var selectedProductType : String = ""
    @State private var selectedPlatformID : String = ""
    @State private var selectedNickname : String = ""
    @State private var selectedPfImage : String = ""
    @State private var selectedToken : String = ""
    @State private var selectedCountrySwap : String = ""
    @State private var selectedLevel : Int = 0
    @State private var selectedVipType : String = ""
    @State private var showMatchView : Bool = false
    @State private var showSwapRequest : Bool = false
    
    @State private var toSwapMessages : Bool = false
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    @State private var isAlreadyAgency: Bool = false
    
    var body: some View {
        if userStore.streamerAgencyID.isEmpty {
            ZStack {
                swapBody
                    .disabled(true)
                    .overlay {
                        Rectangle()
                            .foregroundColor(.black)
                            .opacity(0.3)
                            .ignoresSafeArea()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isAlreadyAgency = true
                        }
                    }
                    .alert("Bir Ajansta Ol", isPresented: $isAlreadyAgency) {
                        
                    } message: {
                        Text("Lütfen Bir ajansta olun")
                    }
            }
        } else {
            swapBody
        }
    }
    
    var swapBody: some View {
        ZStack{
            
            
            VStack{
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Swap")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.toSwapMessages.toggle()
                    } label: {
                        Image(systemName: "quote.bubble")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }

                }
                .padding([.horizontal, .top])
                
                HStack(spacing: 12){
                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Bekleyenler")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Bekleyenler")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("Eşleşenler")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Eşleşenler")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                if selection == 0 {
                    swapListBody
                }
                else {
                    matchedSwapListBody
                }
                
            }
            .overlay{
                VStack(alignment: .trailing){
                    Spacer()
                    
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            if self.userStore.streamerAgencyID != "" || self.userStore.myAgencyId != "" {
                                showSwapMaker.toggle()
                                self.showBottomBar = false
                            }
                            else {
                                self.alertTitle = "Henüz değil"
                                self.alertBody = "Takas yapabilmek için bir ajansa bağli olmalısın"
                                self.showAlert.toggle()
                                print(userStore.streamerAgencyID)
                                print(userStore.myAgencyId)
                            }
                        } label: {
                            ZStack{
                                
                                Circle()
                                    .fill(Color.white)
                                
                                LottieView(name: "eye", loopMode: .loop, speed: 1.5)
                                
                            }
                            .frame(width: 45, height: 45)
                            .background {
                                    LinearGradient(gradient: Gradient(colors: [Color.init(hex: "#141414")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(height: 50)
                                }
                        }
                        .padding([.bottom, .trailing])
                    }
                    
                }

                if showSwapMaker {
                    swapMaker
                }
                if showSwapRequest {
                    swapRequestSenderBody
                }
                if showMatchView {
                    matchUsersNow
                }
            }
        }
        .alert(alertBody, isPresented: $showAlert, actions: {
            Button {
                self.showAlert = false
            } label: {
                Text("Ok")
            }

        })
        .onChange(of: selectedSwapUserId) { val in
            findSelectedUserData()
            if val != "" {
                self.showBottomBar = false
            }
            else {
                self.showBottomBar = true
            }
        }
        .fullScreenCover(isPresented: $toSwapMessages) {
            SwapMessageList()
        }
    }
    
    var swapListBody: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(swapStore.swapList){ item in
                SwapContent(userID: item.userID, timeStamp: item.timeStamp, product: item.product, productType: item.productType, selectedPlatform: item.selectedPlatform, country: item.country, selectedUserID: $selectedSwapUserId, selectedProduct: $selectedProduct, selectedPlatformID: $selectedPlatformID, showSwapRequest: $showSwapRequest)
            }
            .padding(.top, 25)
        }
    }
    
    var matchedSwapListBody: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(swapStore.complatedList){ item in
                ComplatedSwapContent(firstUserID: item.firstUserID, secondUserID: item.secondUserID, product: item.product, productType: item.productType, platform: item.platform, timeStamp: item.timeStamp, country: item.country, platformID: item.platformID)
                    .padding(.vertical, 10)
            }
            .padding(.top, 25)
        }
    }
    
    var swapMaker: some View {
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showSwapMaker = false
                    self.showBottomBar = true
                }
            
            
            VStack(spacing: 0){
                
                Spacer(minLength: 0)
                
                if showCountries {
                    VStack(alignment: .leading, spacing: 15){
                        HStack{
                            Text("Ülkeni Seç")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                self.showCountries = false
                            } label: {
                                Text("Geri")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                            
                        }
                        
                        ScrollView(showsIndicators: false){
                            VStack{
                                ForEach(countryStore.list, id: \.self) { item in
                                    HStack(spacing: 10){
                                        AsyncImage(url: URL(string: "https://countryflagsapi.com/png/\(item.code)")) { img in
                                            img
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 20)
                                        } placeholder: {
                                            ProgressView()
                                                .preferredColorScheme(.light)
                                        }
                                        
                                        Text(item.name)
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .onTapGesture {
                                                self.selectedCountry = item.name
                                                self.selectedCountryImage = "https://countryflagsapi.com/png/\(item.code)"
                                                self.showCountries = false
                                            }
                                        
                                        
                                        Spacer(minLength: 0)
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                }
                else {
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: userStore.pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        }
                        
                        
                        if userStore.vipType == "VIPSILVER" {
                            LottieView(name: "crown_silver")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        else if userStore.vipType == "VIPBLACK" {
                            LottieView(name: "crown_black")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        else if userStore.vipType == "VIPGOLD" {
                            LottieView(name: "crown_gold")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        
                        LevelContentProfile(level: userStore.level)
                            .scaleEffect(0.6)
                            .offset(x: 0, y: 32.5)
                    }
                    .scaleEffect(1.5)
                    .padding(.bottom, -30)
                    .zIndex(1)
                    
                    VStack(alignment: .center, spacing: 15){
                        Text("@\(userStore.nickname)")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.top, 55)
                        
                        Button {
                            self.showCountries = true
                        } label: {
                            HStack{
                                AsyncImage(url: URL(string: self.selectedCountryImage)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 20)
                                } placeholder: {
                                    ProgressView()
                                        .preferredColorScheme(.light)
                                }
                                
                                Text("\(selectedCountry)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                
                            }
                        }
                        
                        Picker("Takas Miktarı Seç", selection: $selectedSwapProduct) {
                            ForEach(general.swapArray, id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .preferredColorScheme(.light)
                        
                        HStack{
                            Button {
                                self.showSwapMaker = false
                                self.showBottomBar = true
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.black)
                                    
                                    Text("Vazgeç")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                }
                            }
                            
                            Button {
                                createSwap()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black)
                                    
                                    Text("Oluştur")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                        .frame(height: 45)
                    }
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding([.horizontal, .bottom])
                    .zIndex(0)
                }
            }
        }
    }
    
    var swapRequestSenderBody : some View {
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.selectedSwapUserId = ""
                    self.showSwapRequest = false
                    self.showBottomBar = true
                }
            
            VStack{
                Spacer(minLength: 0)
                
                
                ZStack{
                    
                    AsyncImage(url: URL(string: selectedPfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    }
                    
                    
                    if selectedVipType == "VIPSILVER" {
                        LottieView(name: "crown_silver")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if selectedVipType == "VIPBLACK" {
                        LottieView(name: "crown_black")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if selectedVipType == "VIPGOLD" {
                        LottieView(name: "crown_gold")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    
                    LevelContentProfile(level: selectedLevel)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
                .scaleEffect(1.5)
                .padding(.bottom, -30)
                .zIndex(1)
                
                VStack(alignment: .center, spacing: 15){
                    Text(selectedNickname)
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.top, 40)
                    
                    HStack{
                        Text("Takas ID :")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                        
                        Text(selectedPlatformID)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .onTapGesture {
                                self.alertTitle = "ID Koyalandı!"
                                self.alertBody = "Şimdi takas yapmak istediğiniz platforma giderek takasınızı gerçkleştirebilirsiniz!"
                                self.showAlert = true
                                UIPasteboard.general.string = selectedPlatformID
                            }
                    }
                    
                    HStack{
                        
                        Image("dia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                        Text("\(selectedProduct)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    
                    Text("Takas isteği göndermek istediğinden emin misin? Takas isteğin onaylandıktan sonra eşleşenler arasında bulunacaksın.")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Button {
                            self.selectedSwapUserId = ""
                            self.showSwapRequest = false
                            self.showBottomBar = true
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.black)
                                
                                Text("Vazgeç")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }

                        Button {
                            self.showMatchView = true
                            self.showSwapRequest = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black)
                                
                                Text("Gönder")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .frame(height: 45)
                }
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding([.horizontal, .bottom])
                .zIndex(0)
            }
        }
    }
    
    var matchUsersNow: some View {
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){

                ZStack{
                    
                    AsyncImage(url: URL(string: selectedPfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    }
                    
                    
                    if selectedVipType == "VIPSILVER" {
                        LottieView(name: "crown_silver")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if selectedVipType == "VIPBLACK" {
                        LottieView(name: "crown_black")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if selectedVipType == "VIPGOLD" {
                        LottieView(name: "crown_gold")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    
                    LevelContentProfile(level: selectedLevel)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
                .scaleEffect(1.5)
                .padding(.top, 45)
                
                
                Text("@\(selectedNickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.top, 30)
                
                Text("Takas ID: \(selectedPlatformID)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                
                Spacer(minLength: 0)
                
                LottieView(name: "lightning", loopMode: .loop, speed: 1.5)
                    .frame(height: 130)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                            self.showMatchView = false
                            self.showBottomBar = true
                            sendSwapRequest()
                        }
                    }
                
                Spacer(minLength: 0)
                
                ZStack{
                    
                    AsyncImage(url: URL(string: userStore.pfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 62, height: 62)
                    }
                    
                    
                    if userStore.vipType == "VIPSILVER" {
                        LottieView(name: "crown_silver")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if userStore.vipType == "VIPBLACK" {
                        LottieView(name: "crown_black")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    else if userStore.vipType == "VIPGOLD" {
                        LottieView(name: "crown_gold")
                            .frame(width: 62, height: 62)
                            .scaleEffect(1.7)
                            .offset(x: 0, y: -7)
                    }
                    
                    LevelContentProfile(level: userStore.level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
                .scaleEffect(1.5)
                .padding(.bottom, 25)
                .padding(.top, 15)
                
                Text("@\(userStore.nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                
                Text("Takas ID: \(userStore.bigoId)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.bottom, 15)
              
            }
        }
    }
    
    func createSwap(){
        let ref = Firestore.firestore()
        let data = [
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "product" : Int(selectedSwapProduct)!,
            "productType" : "diamond",
            "selectedPlatform" : self.userStore.selectedPlatform,
            "country" : selectedCountry
        ] as [String : Any]
        ref.collection("Swaps").document(Auth.auth().currentUser!.uid).setData(data)
        self.showSwapMaker = false
        self.showBottomBar = true
    }
    
    func findSelectedUserData(){
        if self.selectedSwapUserId != "" {
            let ref = Firestore.firestore()
            ref.collection("Users").document(selectedSwapUserId).addSnapshotListener { doc, err in
                if err == nil {
                    if let nickname = doc?.get("nickname") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let vipType = doc?.get("vipType") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        self.selectedNickname = nickname
                                        self.selectedPfImage = pfImage
                                        self.selectedToken = token
                                        self.selectedVipType = vipType
                                        self.selectedLevel = level
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            ref.collection("Swaps").document(selectedSwapUserId).addSnapshotListener { doc, err in
                if err == nil {
                    if let country = doc?.get("country") as? String {
                        if let productType = doc?.get("productType") as? String {
                            self.selectedCountrySwap = country
                            self.selectedProductType = productType
                        }
                    }
                }
            }
        }
    }
    
    func sendSwapRequest(){
        let ref = Firestore.firestore()
        let data = [
            "userID" : Auth.auth().currentUser!.uid,
            "product" : selectedProduct,
            "productType" : selectedProductType,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "platform" : userStore.selectedPlatform,
            "country" : selectedCountrySwap
        ] as [String : Any]
        
        ref.collection("Users").document(selectedSwapUserId).collection("SwapRequests").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        
        ref.collection("Swaps").document(selectedSwapUserId).delete()
        
        sendPushNotify(title: "Hey Dostum?", body: "Takas yapmak ister misin?", userToken: selectedToken, sound: "pay.mp3")
        
        print("requst was sent")
    }
}
