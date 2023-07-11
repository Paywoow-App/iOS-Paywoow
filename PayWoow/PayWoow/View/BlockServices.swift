//
//  VIPHizmetleri.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/21/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct BlockServices: View {
    @State private var keyboardHeight: CGFloat = 0
    
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var store = AngelStore()
    @Binding var showBottomBar : Bool
    @State private var angelSelection : Int = 0
    @State private var devilTabSelector : Int = 0
    @State private var angelTabSelector : Int = 0
    @State private var showAngelMaker: Bool = false
    @State private var showDevilMaker : Bool = false
    @State private var showDevilRequestMaker : Bool = false
    @State private var showAngelRequestMaker : Bool = false
    @State private var iAmAngel : Bool = false
    @AppStorage("mainTabViewSelection") var selection = 5
    
    @State private var selectedClass : String = "A Class"
    @State private var selectedDescription : String = "Ban'ım yarın açılsın"
    @State private var selectedPoint : Int = 100
    @State private var inputAngelPoint : String = "" 
    @State private var selectedUserID : String = "None"
    
    // MARK: User Details
    @State private var selectedFirstName : String = ""
    @State private var selectedLastName : String = ""
    @State private var selectedPfImage : String = ""
    @State private var selectedToken : String = ""
    @State private var selectedNickname : String = ""
    @State private var selectedLevel : Int = 0
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    @State private var isAnDevil : Bool = false
    
    @State private var lock : Bool = true
    @State private var toRules : Bool = false
    
    @State private var blockServicesed: Bool = false
    @State private var blockServicesed2: Bool = false
    
    @State private var isAmIAngel: Bool = true
    @State private var isAmIDevil: Bool = true
    
    @State private var checkedIsAmIAngel: Bool = false
    @State private var checkedIsAmIDevil: Bool = false
    
    init(showBottomBar: Binding<Bool>) {
        _showBottomBar = showBottomBar
    }
    
    func checkUserAngelsService() {

        let currentsUids = Auth.auth().currentUser!.uid

        guard !checkedIsAmIAngel else { return }
        
        Firestore.firestore().collection("Angels").getDocuments { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard let docs = snap?.documents else { return }

            for doc in docs {
                if currentsUids == doc.documentID {
                    self.isAmIAngel = false
                    print("I am Angel")
                }
            }
        }
        checkedIsAmIAngel = true
    }
    
    func checkUserDevilsService() {

        let currentsUids = Auth.auth().currentUser!.uid

        guard !checkedIsAmIDevil else { return }
        
        Firestore.firestore().collection("Devils").getDocuments { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard let docs = snap?.documents else { return }

            for doc in docs {
                if currentsUids == doc.documentID {
                    self.isAmIDevil = false
                    print("I am Devil")
                }
            }
        }
        checkedIsAmIDevil = true
    }
    
    var body : some View {
        ZStack {
        if userStore.accountLevel == 0 {
            if userStore.streamerAgencyID.isEmpty {
                ZStack(content: {
                    blockServiesView
                        .overlay(content: {
                            Rectangle()
                                .ignoresSafeArea()
                                .foregroundColor(.black)
                                .opacity(0.2)
                        })
                        .disabled(true)
                })
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        blockServicesed = true
                    }
                }
                .alert("Dikkat", isPresented: $blockServicesed) {
                    
                } message: {
                    Text("Bu özelliği kullanabilmek için lütfen bir ajansta bağlı kalınız.")
                }
            } else if  !(userStore.vipType == "VIPBLACK") && !(userStore.vipType == "VIPGOLD") {
                ZStack {
                    blockServiesView
                        .overlay {
                            Rectangle()
                                .ignoresSafeArea()
                                .foregroundColor(.black)
                                .opacity(0.2)
                        }
                        .disabled(true)
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        blockServicesed2 = true
                    }
                }
                .alert("Dikkat", isPresented: $blockServicesed2) {
                    
                } message: {
                    Text("Bu özelliği kullanabilmeniz için VIP BLACK veya VIP GOLD sahip olmalısınız.")
                }
            } else  {
                blockServiesView
            }
        } else {
            blockServiesView
        }
    }
       // Buraya bkaılacak
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.checkUserDevilsService()
                self.checkUserAngelsService()
            }
        }
    }
    
    var blockServiesView: some View {
        ZStack {
            
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Block Services")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.toRules.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .fullScreenCover(isPresented: $toRules) {
                        RulesOfBlockServices()
                    }

                }
                .padding(.horizontal)
                .padding(.top)
                HStack(spacing: 12){
                    Button {
                        self.angelSelection = 0
                    } label: {
                        if self.angelSelection == 0 {
                            Text("Angels")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Angels")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        self.angelSelection = 1
                    } label: {
                        if self.angelSelection == 1 {
                            Text("Devils")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("Devils")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.horizontal)
                //MARK: BlockServices - Angel List View
                if self.angelSelection == 0 {
                    ZStack{
                        
                        
                        if !self.store.angels.isEmpty {
                            VStack {
                                
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(store.angels) { item in
                                    AngelContent(userID: item.userID,
                                                 timeStamp: item.timeStamp,
                                                 showBottomBar: $showBottomBar,
                                                 selectedUserID: $selectedUserID,
                                                 showAngelRequestMaker: $showAngelRequestMaker,
                                                 iAmAngel: $iAmAngel)
                                        .onAppear{
                                            if item.userID == Auth.auth().currentUser!.uid {
                                                self.iAmAngel = true
                                            }
                                        }
                                        .onChange(of: selectedUserID) { val in
                                            findSelectedUserDetails(userID: val)
                                            print("\(val)")
                                        }
                                }
                                .onChange(of: store.angels.count) { v in
                                    self.iAmAngel = true
                                    print("\(v)")
                                }
                            }
                        }
                            .frame(height: UIScreen.main.bounds.height * 0.68)
                            .padding(.bottom, 50)
                        }

                        else {
                            Spacer(minLength: 0)
                        }
                        
                        VStack{
                            
                            Spacer(minLength: 0)
                            
                            if isAmIAngel && isAmIDevil {
                                Button {
                                    showAngelMaker.toggle()
                                    self.showBottomBar = false
                                    
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white)
                                        
                                        Text("Melek Ol")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                    }
                                    .frame(height: 30)
                                    .padding(.horizontal, 100)
                                    .padding(.bottom)
                                }
                            }
                        }
                    }
                }
                //MARK: BlockServices - Devil List View
                else if self.angelSelection == 1 {
                    ZStack {
                        if !self.store.devils.isEmpty {
                            VStack {
                                ScrollView(.vertical, showsIndicators: false) {
                                    ForEach(store.devils) { item in
                                        DevilContent(userID: item.userID, timeStamp: item.timeStamp, selectedUserID: $selectedUserID, selectedClass: $selectedClass, selectedDescription: $selectedDescription, selectedPoint: $selectedPoint, showBottomBar: $showBottomBar, showDevilRequestMaker: $showDevilRequestMaker, iAmAngel: $iAmAngel)
                                            .onChange(of: selectedUserID) { val in
                                                findSelectedUserDetails(userID: val)
                                            }
                                            .onAppear{
                                                if item.userID == Auth.auth().currentUser!.uid {
                                                    self.isAnDevil = true
                                                }
                                            }
                                            .onChange(of: store.devils.count) { newValue in
                                                self.isAnDevil = false
                                            }
                                            .onTapGesture {
                                                print("BURASIII ::\(item.userID)")
                                            }
                                    }
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.68)
                            .padding(.bottom, 50)
                        }
                        else {
                            Spacer(minLength: 0)
                        }
                        
                        VStack{
                            
                            Spacer(minLength: 0)
                            
                            if isAmIAngel && isAmIDevil {
                                Button {
                                    showDevilMaker.toggle()
                                    self.showBottomBar = false
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white)
                                        
                                        Text("Şeytan Ol")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                    }
                                    .frame(height: 30)
                                    .padding(.horizontal, 100)
                                    .padding(.bottom)
                                }
                            }
                        }
                    }
                }
            }
            //TODO: onApear
            
            if showAngelMaker {
                VStack{
                    angelMaker
                        .onAppear{
                            self.showDevilMaker = false
                        }
                }
            }
            
            if showDevilMaker {
                devilMaker
                    .onAppear{
                        self.showAngelMaker = false
                    }
            }
            
            if selectedUserID != "None" && self.showDevilRequestMaker == true {
                devilRequestMaker
            }
            
            if selectedUserID != "None" && self.showAngelRequestMaker == true {
                angelRequestMaker
                    .onAppear{
                        print(selectedUserID)
                        print(showAngelRequestMaker)
                    }
            }
        }
        .alert(alertBody, isPresented: $showAlert) {
            Button {
                self.showAlert = false
            } label: {
                Text("OK")
            }
    }
    }
    
    //MARK: AngelMaker -
    var angelMaker: some View {
        ZStack{

            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all).onTapGesture {
                self.showAngelMaker = false
                self.showBottomBar = true
                self.showAlert = false
            }

            if self.angelTabSelector == 0 {
                VStack(alignment: .center){
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .center,spacing: 15){
                        
                        Text("@"+userStore.nickname)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.top, 55)
                        
                        Divider()
                            .colorScheme(.dark)
                            .padding(.horizontal, 10)
                        
                        
                        Text("VIP olmanın temel özelliklerinden birisi de ban açtırma servisini kullanabilmektir. Burada kullanacağınız puanınız ile ban yemiş kullanıcılara yardım etmek, ve onların banların açtırmak için kullanabilirsiniz.")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .colorScheme(.dark)
                            .padding(.horizontal, 10)
                        
                        Text("Kullanılabilir Puanınız : \(userStore.vipPoint)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        TextField("Puan", text: $inputAngelPoint)
                            .foregroundColor(.black)
                            .font(.system(size: 25))
                            .colorScheme(.light)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.center)
                            .frame(width: 65)
                            .onChange(of: inputAngelPoint) { newValue in
                                 if let inputAsInt = Int(newValue), inputAsInt > userStore.vipPoint {
                                     inputAngelPoint = String(userStore.vipPoint)
                                 }
                             }
                        
                        Divider()
                            .colorScheme(.dark)
                            .padding(.horizontal, 50)
                        
                        Button {
                            // Melek Ol buttonu
//                            if self.userStore.vipType != "Casper" && self.userStore.vipType != "VIPSILVER" {
//                                if inputAngelPoint == "" {
//                                    self.alertTitle = "Hata"
//                                    self.alertBody = "En az 25 puan kullanabilirsiniz. Girdiğiniz değer çok az."
//                                    self.showAlert.toggle()
//                                }
//                                else if Int(inputAngelPoint)! == 0 || Int(inputAngelPoint)! < 25 {
//                                    self.alertTitle = "Hata"
//                                    self.alertBody = "En az 25 puan kullanabilirsiniz. Girdiğiniz değer çok az"
//                                    self.showAlert.toggle()
//                                }
//                                else if Int(self.userStore.totalSoldDiamond / 50) < Int(inputAngelPoint)! {
//                                    self.alertTitle = "Hata"
//                                    self.alertBody = "Limitinizin üstünde bir değer girdiniz"
//                                    self.showAlert.toggle()
//                                }
//                                else if Int(self.userStore.totalSoldDiamond / 50) > Int(inputAngelPoint)! {
                                    makeAngel()
//                                }
//                            }
//                            else {
//                                self.alertBody = "Melek olabilmek için öncelikle VIPBLACK veya VIPGOLD Olmalısınız"
//                                self.showAlert = true
//                            }
                            
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                Text("Melek Ol")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            .frame(height: 45)
                        }
                    }
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                    .overlay {
                        ZStack{
                            ZStack{
                                AsyncImage(url: URL(string: userStore.pfImage)) { img in
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 11)
                                } placeholder: {
                                    Image("defualtPf")
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 11)
                                }
                                
                                
                                LottieView(name: "angel_white", loopMode: .loop, speed: 2.0)
                                    .scaleEffect(1.5)
                                    .frame(width: 95, height: 95)
                                    .offset(y: -3)
                            }
                            .scaleEffect(1.3)
                            .padding(.top, -250)
                            
                            HStack{
                                Spacer()
                                
                                Button {
                                    self.angelTabSelector = 1
                                } label: {
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                }
                                
                            }.padding(.top, -175)
                                .padding(.horizontal, 40)
                        }
                        
//                        if self.showAlert {
//                            VStack(alignment: .center, spacing: 15){
//                                Text(alertTitle)
//                                    .foregroundColor(.black)
//                                    .font(.system(size: 18))
//                                    .fontWeight(.medium)
//
//                                Text(alertBody)
//                                    .foregroundColor(.black)
//                                    .font(.system(size: 15))
//                                    .multilineTextAlignment(.center)
//
//
//                                Button {
//                                    self.showAlert = false
//                                } label: {
//                                    Text("Ok")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 15))
//                                        .padding(.horizontal, 20)
//                                        .padding(.vertical, 7)
//                                        .background(Color.black)
//                                        .cornerRadius(25)
//                                }
//
//                            }
//                            .padding(.all, 10)
//                            .background(Color.white)
//                            .cornerRadius(12)
//                            .shadow(radius: 3)
//                            .padding(.all, 40)
//                        }
                        
                    }
                }
                .padding(.bottom, keyboardHeight)
                .onAppear {
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                let height = value.height

                                self.keyboardHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                            }

                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                                self.keyboardHeight = 0
                            }
                        }
            }
            
            else {
                
                VStack{
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading, spacing: 15){
                        
                        HStack{
                            Text("Ödüller")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                self.angelTabSelector = 0
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                
                            }
                            
                        }
                        
                        HStack{
                            Text("Ceza Sınıfı")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            
                            Spacer(minLength: 0)
                        }
                        
                        HStack{
                            ForEach(general.devilClasses){ item in
                                if item.classTitle == self.selectedClass {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black)
                                        
                                        Text(item.classTitle)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                }
                                else {
                                    Button {
                                        self.selectedClass = item.classTitle
                                        for doc in item.request {
                                            self.selectedDescription = doc.desc
                                            self.selectedPoint = doc.point
                                        }
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                            
                                            Text(item.classTitle)
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .frame(height: 45)
                        
                        
                        HStack{
                            Text("Kurtarma sonrası ödül")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            
                            Spacer(minLength: 0)
                        }
                        
                        ForEach(general.devilClasses){ item in
                            if self.selectedClass == item.classTitle {
                                ForEach(item.request){ des in
                                    HStack(spacing: 12){
                                        
                                        Text(des.desc)
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(des.point * 50)")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                        
                                        Image("dia")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                    }
                                    
                                }
                            }
                        }
                        
                        Text("Her hangi bir şeytanı kurtardığınız taktirde alacağınız ödüller üstte belirtilmiştir.")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                }
                
            }
        }
    }
    //MARK: DevilMaker -
    var devilMaker : some View {
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    
                    self.showDevilMaker = false
                    self.showBottomBar = true
                }
            if self.devilTabSelector == 0 {
                VStack{
                    Spacer(minLength: 0)
                    
                    
                    ZStack{
                        AsyncImage(url: URL(string: userStore.pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 80, height: 80)
                                .shadow(radius: 11)
                        }
                        
                        
                        LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                            .scaleEffect(1.5)
                            .frame(width: 95, height: 95)
                            .offset(x: 1.5,y: -3.5)
                    }
                    .scaleEffect(1.3)
                    .offset(y: 60)
                    .zIndex(1)
                    
                    
                    VStack(alignment: .leading, spacing: 10){
                        ZStack{
                            HStack{
                                
                                Spacer(minLength: 0)
                                
                                Text("@"+userStore.nickname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.top, 40)
                            
                            HStack{
                                Spacer(minLength: 0)
                                
                                Button {
                                    self.devilTabSelector = 1
                                } label: {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                                
                            }
                        }
                        
                        Divider()
                            .colorScheme(.dark)
                        
                        Text("Sınıf")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        HStack{
                            ForEach(general.devilClasses){ item in
                                if item.classTitle == self.selectedClass {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black)
                                        
                                        Text(item.classTitle)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                }
                                else {
                                    Button {
                                        self.selectedClass = item.classTitle
                                        for doc in item.request {
                                            self.selectedDescription = doc.desc
                                            self.selectedPoint = doc.point
                                        }
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                            
                                            Text(item.classTitle)
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .frame(height: 45)
                        
                        
                        HStack{
                            Text("İstenilen Hizmet")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Text("Puan")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        ForEach(general.devilClasses){ item in
                            if self.selectedClass == item.classTitle {
                                ForEach(item.request){ des in
                                    Button {
                                        self.selectedDescription = des.desc
                                        self.selectedPoint = des.point
                                    } label: {
                                        HStack(spacing: 12){
                                            Circle()
                                                .stroke(Color.black)
                                                .frame(width: 20, height: 20)
                                                .overlay {
                                                    if self.selectedDescription == des.desc {
                                                        Circle()
                                                            .fill(Color.black)
                                                            .frame(width: 12, height: 12)
                                                    }
                                                }
                                            
                                            Text(des.desc)
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                            
                                            Spacer(minLength: 0)
                                            
                                            Text("\(des.point)")
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                                .fontWeight(.medium)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        Text("Kullanılabilir Puanınız : \(((userStore.totalMoney / 21) * 50) / 50)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                            Button {
                                
                                if self.userStore.vipType != "Casper" {
                                    if selectedPoint > (((userStore.totalMoney / 21) * 50) / 50) {
                                        self.alertBody = "Sadece paunınız kadar işlem yapabilirsiniz"
                                        self.showAlert = true
                                    }
                                    else {
                                        makeDevil()
                                    }
                                }
                                else {
                                    self.alertBody = "Şeytan olabilmeniz için öncelikle VIP olmalısınız"
                                    self.showAlert = true
                                }
                                
                                
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                    
                                    Text("Şeytan Ol")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                }
                                .frame(height: 45)
                            }
                    }
                    .padding(.all)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                    .zIndex(0)
                }
            }
            else {
                VStack{
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading, spacing: 15){
                        
                        HStack{
                            Text("Kredi Nasıl Alınır?")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                self.devilTabSelector = 0
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                
                            }
                            
                        }
                        
                        HStack{
                            Text("Ceza Sınıfı")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            
                            Spacer(minLength: 0)
                        }
                        
                        HStack{
                            ForEach(general.devilClasses){ item in
                                if item.classTitle == self.selectedClass {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.black)
                                        
                                        Text(item.classTitle)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                }
                                else {
                                    Button {
                                        self.selectedClass = item.classTitle
                                        for doc in item.request {
                                            self.selectedDescription = doc.desc
                                            self.selectedPoint = doc.point
                                        }
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.2))
                                            
                                            Text(item.classTitle)
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .frame(height: 45)
                        
                        
                        HStack{
                            Text("Yüklemeniz gereken tutar")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            
                            Spacer(minLength: 0)
                        }
                        
                        ForEach(general.devilClasses){ item in
                            if self.selectedClass == item.classTitle {
                                ForEach(item.request){ des in
                                    HStack(spacing: 12){
                                        
                                        Text(des.desc)
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(des.point * 50)")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                        
                                        Image("dia")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                    }
                                    
                                }
                            }
                        }
                        
                        Text("Kredilerinizi kullanabilmeniz için cüzdanınıza gerekli ceza karşılığı ürün tutarını yatırmanız gerekmektedir.")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.all)
                }
            }
        }
    }
    
    var devilRequestMaker: some View {
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all).onTapGesture {
                self.selectedUserID = "None"
                self.showDevilRequestMaker = false
                self.showAngelRequestMaker = false
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
                            .frame(width: 80, height: 80)
                            .shadow(radius: 11)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .shadow(radius: 11)
                    }
                    
                    
                    LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                        .scaleEffect(1.5)
                        .frame(width: 95, height: 95)
                        .offset(x: 1.5,y: -3.5)
                }
                .scaleEffect(1.3)
                .offset(y: 60)
                .zIndex(1)
                
                VStack(spacing: 15){
                    Text("@"+selectedNickname)
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.top, 40)
                    
                    HStack{
                        Text("Sınıf - devil req maker")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(selectedClass)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Talep")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(selectedDescription)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    
                    
                    HStack{
                        Text("Gerekli Puan")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("\(selectedPoint)")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                    
                    HStack{
                        Text("Mevcut Puanın")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        if self.userStore.vipPoint < selectedPoint {
                            Text("\(self.userStore.vipPoint)")
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                        }
                        else {
                            Text("\(self.userStore.vipPoint)")
                                .foregroundColor(.green)
                                .font(.system(size: 15))
                        }
                    }
                    
                    
                    HStack{
                        Button {
                            self.selectedUserID = "None"
                            self.selectedClass = ""
                            self.selectedDescription = ""
                            self.selectedPoint = 0
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
                            if self.userStore.vipPoint < selectedPoint {
                                self.alertTitle = "Yetersiz Kredi!"
                                self.alertBody = "Kurtarmanız için gerekli puan \(selectedPoint)\nKurtarabilmeniz için \(((selectedPoint - self.userStore.vipPoint) * 50 ) / 50 * 19) Türk Lirası kadar Casper Kartınıza para yüklemelisiniz."
                                self.showAlert.toggle()
                            }
                            else {
                                helpToDevil()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black)
                                
                                Text("Kurtar")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                    }
                    .frame(height: 45)
                }
                .padding(.all)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.all)
                .zIndex(0)
                
            }
        }
    }
    
    var angelRequestMaker: some View {
        
        ZStack{
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showDevilRequestMaker = false
                    self.showAngelRequestMaker = false
                    self.selectedUserID = "None"
                    self.showBottomBar = true
                }
            VStack{
                Spacer(minLength: 0)
                
                
                ZStack{
                    AsyncImage(url: URL(string: userStore.pfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .shadow(radius: 11)
                    } placeholder: {
                        Image("defualtPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .shadow(radius: 11)
                    }
                    
                    
                    LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                        .scaleEffect(1.5)
                        .frame(width: 95, height: 95)
                        .offset(x: 1.5,y: -3.5)
                }
                .scaleEffect(1.3)
                .offset(y: 60)
                .zIndex(1)
                
                
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        Text("@"+userStore.nickname)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 40)
                    
                    Divider()
                        .colorScheme(.dark)
                    
                    Text("Sınıf")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    HStack{
                        ForEach(general.devilClasses){ item in
                            if item.classTitle == self.selectedClass {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.black)
                                    
                                    Text(item.classTitle)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                            else {
                                Button {
                                    self.selectedClass = item.classTitle
                                    for doc in item.request {
                                        self.selectedDescription = doc.desc
                                        self.selectedPoint = doc.point
                                    }
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.gray.opacity(0.2))
                                        
                                        Text(item.classTitle)
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                    }
                                }
                                
                            }
                        }
                    }
                    .frame(height: 45)
                    
                    
                    HStack{
                        Text("İstenilen Hizmet")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        Text("Puan")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                    }
                    ForEach(general.devilClasses){ item in
                        if self.selectedClass == item.classTitle {
                            ForEach(item.request){ des in
                                Button {
                                    self.selectedDescription = des.desc
                                    self.selectedPoint = des.point
                                } label: {
                                    HStack(spacing: 12){
                                        Circle()
                                            .stroke(Color.black)
                                            .frame(width: 20, height: 20)
                                            .overlay {
                                                if self.selectedDescription == des.desc {
                                                    Circle()
                                                        .fill(Color.black)
                                                        .frame(width: 12, height: 12)
                                                }
                                            }
                                        
                                        Text(des.desc)
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(des.point)")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    Text("Kullanılabilir Puanınız : \(Int(userStore.totalMoney / 50))")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Button {
                        if selectedPoint < Int(userStore.totalSoldDiamond / 50) {
                            //send request
                        }
                        else if selectedPoint > Int(userStore.totalSoldDiamond / 50) {
                            self.alertTitle = "Yetersiz Puan!"
                            self.alertBody = "Bu talebi gerçekleştirebilmek için \(((selectedPoint - Int(userStore.totalSoldDiamond / 50)) * 50) / 50 * 19) Türk lirası değerinde sipariş vermelisiniz."
                            self.showAlert.toggle()
                            print("Error")
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                            
                            Text("Yardım İste")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                        }
                        .frame(height: 45)
                    }
                    
                }
                .padding(.all)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.all)
                .zIndex(0)
                .overlay{                    
                    if self.showAlert {
                        VStack(alignment: .center, spacing: 15){
                            Text(alertTitle)
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            Text(alertBody)
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.center)
                            
                            Button {
                                self.showAlert = false
                            } label: {
                                Text("Tamam")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .padding(.vertical, 7)
                                    .background(Color.black)
                                    .cornerRadius(12)
                            }
                            
                        }
                        .padding(.all, 15)
                        .background(Color.white)
                        .shadow(radius: 3)
                        .cornerRadius(12)
                        .padding(.all, 40)
                    }
                }
            }
        }
        
    }
    
    func helpToDevil(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        dateFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        let timeDate = dateFormatter.string(from: date)
        let ref = Firestore.firestore()
        let data = [
            "angelID" : Auth.auth().currentUser!.uid,
            "devilID" : selectedUserID,
            "point" : selectedPoint,
            "product" : selectedPoint * 50,
            "productType" : "diamond",
            "class" : selectedClass,
            "desc" : selectedDescription,
            "step0Time" : timeDate,
            "step1Time" : "",
            "step2Time" : "",
            "step3Time" : "",
            "step4Time" : "",
            "step5Time" : "",
            "step6Time" : "",
            "step7Time" : "",
            "step" : 0,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "stepUserID" : selectedUserID
        ] as [String : Any]

        ref.collection("BlockTransactions").document("\(Int(Date().timeIntervalSince1970))").setData(data, merge: true)

        ref.collection("Devils").document(selectedUserID).delete()

        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "vipPoint" : userStore.vipPoint - selectedPoint
        ], merge: true)

        self.selectedUserID = "None"
        self.showBottomBar = true
        self.selection = 5
    }
    
    func makeAngel(){
        let ref = Firestore.firestore()
        let data = [
            "userID" : Auth.auth().currentUser!.uid,
            "totalPoint" : Int(inputAngelPoint)!,
            "timeStamp" : Int(Date().timeIntervalSince1970)
        ] as [String : Any]
        ref.collection("Angels").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        ref.collection("Devils").document(Auth.auth().currentUser!.uid).delete()
        self.showAngelMaker = false
        self.showBottomBar = true
    }
    
    func makeDevil(){
        let ref = Firestore.firestore()
        let data = [
            "class" : selectedClass,
            "title" : selectedDescription,
            "point" : selectedPoint,
            "timeStamp" : Int(Date().timeIntervalSince1970),
        ] as [String : Any]
        ref.collection("Devils").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
        ref.collection("Angels").document(Auth.auth().currentUser!.uid).delete()
        self.showDevilMaker = false
        self.showBottomBar = true
    }
    
    func findSelectedUserDetails(userID: String){
        let ref = Firestore.firestore()
        ref.collection("Users").document(selectedUserID).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let nickname = doc?.get("nickname") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        self.selectedFirstName = firstName
                                        self.selectedLastName = lastName
                                        self.selectedPfImage = pfImage
                                        self.selectedToken = token
                                        self.selectedNickname = nickname
                                        self.selectedLevel = level
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
