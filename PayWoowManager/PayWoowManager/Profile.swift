//
//  Admin-Profile.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 9/29/21.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import Firebase

struct Profile: View {
    @AppStorage("storeNick") var storeNick : String = ""
    @AppStorage("storePassword") var storePassword : String = ""
    @AppStorage("storeSelectedApp") var storeSelectedApp : String = ""
    
    @StateObject var deallerStore = DeallerStore()
    @State private var bodySelection : Int = 0
    
    //Buttons
    @State private var signOut : Bool = false

    @State private var toStreammerSalaries : Bool = false
    @State private var toGiftRequest : Bool = false
    @State private var toTaxFree : Bool = false
    @State private var toAgencyRequests : Bool = false
    @State private var toEditProfile : Bool = false
    @State private var toInvest : Bool = false
    @State private var toVIPPoints : Bool = false
    @State private var toRemittence : Bool = false
    @State private var isNavigateToBackService: Bool = false
    //Data
    @State private var inputPrice : Int = 0
    @State private var dollar : Double = 0
    @State private var isNavigateToAccountManager: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            ScrollView(.vertical, showsIndicators: false) {
                SelectedAppsDetails()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Button {
                        isNavigateToAccountManager.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Hesap Yönetimi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }

                    
                    Button {
                        self.toTaxFree.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "newspaper.circle")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Muafiyet Başvuruları")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                        
                        Button {
                            storeNick = ""
                            
                            self.toGiftRequest.toggle() // 
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "gift")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Çekim Talepleri")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                    Button {
                        self.toInvest.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "banknote")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Yatırımcılar")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                        
                    Group {
                        
                        Button {
                            self.toRemittence.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "creditcard")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Havale EFT İşlemleri")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            self.toStreammerSalaries.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "music.mic.circle")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Yayıncı Maaşları")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            isNavigateToBackService.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "circle.slash")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Ban İşlemleri")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            self.toVIPPoints.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "crown")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("VIP Puan Yönetimi")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isNavigateToAccountManager, content: {
            AccountManager()
        })
        .fullScreenCover(isPresented: $isNavigateToBackService, content: {
            BlockServices()
        })

        .fullScreenCover(isPresented: $signOut) {
            AdminLogin()
        }

        .fullScreenCover(isPresented: $toStreammerSalaries) {
            StreammerSalaryWriter()
        }
        .fullScreenCover(isPresented: $toRemittence) {
            Remittences()
        }

        .popover(isPresented: $toGiftRequest, content: {
            GiftRequest(dealler: storeNick)
        })
        .popover(isPresented: $toAgencyRequests, content: {
            AgencyRequest()
        })
        .fullScreenCover(isPresented: $toEditProfile, content: {
            EditProfile(dealler: storeNick)
        })
        .fullScreenCover(isPresented: $toTaxFree, content: {
            TaxFreeApplications()
        })
        .fullScreenCover(isPresented: $toVIPPoints, content: {
            VIPPointManager()
        })
        .popover(isPresented: $toInvest, content: {
            Investories()
        })
    }
}

struct SelectedAppsDetails: View {
    @AppStorage("storeNick") var storeNick : String = "None"
    @AppStorage("storeSelectedApp") var storeSelectedApp : String = "None"
    let ref = Firestore.firestore()
    //Dealler
    @State private var deallerName : String = ""
    @State private var coverImage : String = ""
    //Data
    @State private var platformName : String = ""
    @State private var platformImage : String = ""
    @State private var platformDocID : String = ""
    @State private var productTotal : Int = 0
    @State private var dollar : Double = 0
    @State private var maxLimit : Int = 0
    @State private var boughtPrice : Int = 0
    @State private var sellPrice : Int = 0
    @State private var balance : Int = 0
    @State private var productType : String = ""
    @State private var isActive : Bool = false
    @State private var giftDiamond : Int = 0
    @State private var giftPrice : Int = 0
    @State private var profitPrice : Int = 0
    @State private var profitDiamond : Int = 0
    //Externals
    @State private var giftBlur : Bool = true
    @State private var selectedAppListen : String = ""
    
    var body : some View{
        VStack(spacing: 15){
            HStack{
                WebImage(url: URL(string: coverImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 10){
                    Text(deallerName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Toggle("", isOn: $isActive)
                    .labelsHidden()
                    .onChange(of: isActive) { val in
                        ref.collection("Bayii").document(storeNick).collection("Apps").document(storeSelectedApp).setData(["isActive" : val], merge: true)
                    }
            }
            .padding(.all)
            
            HStack{
                
                Image("dia")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("\(productTotal)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 10){
                    Text("Toplam İşlem Tutarı")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Text("₺ \(balance)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            HStack{
                VStack(alignment: .leading, spacing: 10) {
                    Text("Elmas Kârı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("\(profitDiamond)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 10) {
                    Text("Kâr Karşılığı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("₺ \(profitPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal)
            
            HStack{
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hediye Cüzdanı")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    HStack {
                        Image(systemName: "gift")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                        Text("\(giftDiamond)  ≈")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Text("\(giftPrice) ₺")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                    }
                    .blur(radius: giftBlur ? 11 : 0)
                    .onTapGesture {
                        giftBlur.toggle()
                    }
                    .overlay {
                        if giftBlur {
                            Button {
                                giftBlur.toggle()
                            } label: {
                                Text("Göster")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }
                        }

                    }
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .trailing, spacing: 15) {
                    Text("Satış Kuru")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Text("$\(String(format: "%.2f", dollar))")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
        .onAppear{
            self.selectedAppListen = storeSelectedApp
            getData()
        }
        .onChange(of: self.storeSelectedApp) { item in
            self.selectedAppListen = item
        }
        .onChange(of: dollar) { newValue in
            calculate()
        }
        .onChange(of: giftDiamond) { newValue in
            calculateGift()
        }
        .onChange(of: selectedAppListen) { newValue in
            getData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                calculate()
                calculateGift()
            }
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Bayii").document(storeNick).collection("Apps").document(selectedAppListen).addSnapshotListener { doc, err in
            if let platformName = doc?.get("platformName") as? String {
                if let platformImage = doc?.get("platformImage") as? String {
                    if let productTotal = doc?.get("productTotal") as? Int {
                        if let dollar = doc?.get("dollar") as? Double {
                            if let maxLimit = doc?.get("maxLimit") as? Int {
                                if let boughtPrice = doc?.get("boughtPrice") as? Int {
                                    if let sellPrice = doc?.get("sellPrice") as? Int {
                                        if let balance = doc?.get("balance") as? Int {
                                            if let productType = doc?.get("productType") as? String {
                                                if let isActive = doc?.get("isActive") as? Bool {
                                                    if let giftDiamond = doc?.get("giftDiamond") as? Int {
                                                        if let coverImage = doc?.get("coverImage") as? String {
                                                            if let deallerName = doc?.get("deallerName") as? String {
                                                                self.platformName = platformName
                                                                self.platformImage = platformImage
                                                                self.productTotal = productTotal
                                                                self.dollar = dollar
                                                                self.maxLimit = maxLimit
                                                                self.boughtPrice = boughtPrice
                                                                self.sellPrice = sellPrice
                                                                self.balance = balance
                                                                self.productType = productType
                                                                self.isActive = isActive
                                                                self.coverImage = coverImage
                                                                self.deallerName = deallerName
                                                                self.giftDiamond = giftDiamond
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
                    }
                }
            }
        }
    }
    
    func calculate(){
        let step1 = Double(balance) / Double(dollar)
        print("newStap1 \(step1)")
        let step2 = step1 * Double(boughtPrice)
        print("newStap2 \(step2)")
        let step3 = step1 * Double(sellPrice)
        print("newStap3 \(step3)")
        self.profitDiamond = Int(step2 - step3)
        
        let step4 = profitDiamond / 50
        print("newStap4 \(step4)")
        let step5 = Double(step4) * dollar
        self.profitPrice = Int(step5)
    }
    
    func calculateGift(){
        let step1 = giftDiamond / 50
        print("GiftStep1 \(step1)")
        let step2 = Double(step1) * dollar
        print("GiftStep2 \(step2)")
        self.giftPrice = Int(step2)
    }
}

struct LevelAdmin: View{
    @State var level : Int
    var body: some View{
        ZStack{
            if self.level <= 11 && self.level >= 1 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255), Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("11 - 1")
                    }
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255), Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("22 - 12")
                    }
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 42 / 255, green: 78 / 255, blue: 100 / 255), Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("33 - 23")
                    }
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 142 / 255, green: 87 / 255, blue: 162 / 255), Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("44 - 34")
                    }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 195 / 255, green: 100 / 255, blue: 180 / 255), Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("55 - 45")
                    }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 253 / 255, green: 156 / 255, blue: 250 / 255), Color.init(red: 255 / 255, green: 188 / 255, blue: 195 / 255), Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("66 - 56")
                    }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 255 / 255, green: 190 / 255, blue: 207 / 255), Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("76 - 67")
                    }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 181 / 255, green: 50 / 255, blue: 85 / 255), Color.init(red: 255 / 255, green: 74 / 255, blue: 99 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("88 - 78")
                    }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color.init(red: 234 / 255, green: 87 / 255, blue: 126 / 255), Color.init(red: 240 / 255, green: 181 / 255, blue: 129 / 255), Color.init(red: 255 / 255, green: 237 / 255, blue: 152 / 255)], startPoint: .leading, endPoint: .trailing))
                    .onAppear{
                        print("100 - 89")
                    }
            }
            
            
            
            if self.level <= 11 && self.level >= 1 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }//
            
            else if self.level <= 22 && self.level >= 12 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            } //
            
            else if self.level <= 33 && self.level >= 23 {
                Text("Lv\(self.level)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
            }//
            
            else if self.level <= 44 && self.level >= 34 {
                HStack(spacing: 0){
                    
                    Image(systemName: "rhombus.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 55 && self.level >= 45 {
                HStack(spacing: 0){
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 66 && self.level >= 56 {
                HStack(spacing: 0){
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 77 && self.level >= 67 {
                HStack(spacing: 0){
                    
                    Image(systemName: "sun.min.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 88 && self.level >= 78 {
                HStack(spacing: 0){
                    
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            else if self.level <= 100 && self.level >= 89 {
                HStack(spacing: 0){
                    
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10, alignment: Alignment.center)
                    
                    Text("\(self.level)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                }
            }
            
            
        }
        .frame(width: 30, height: 20, alignment: Alignment.center)
        .offset(x: 35, y: -35)
    }
}


struct AccountManager: View {
    
    @AppStorage("storeNick") var storeNick : String = ""
    @AppStorage("storePassword") var storePassword : String = ""
    @AppStorage("storeSelectedApp") var storeSelectedApp : String = ""
    
    @State private var toDeallerChanger : Bool = false
    @State private var toBalanceMaker : Bool = false
    @State private var toCustomerServices : Bool = false
    @State private var toLiveData : Bool = false
    @State private var isNavigateToLogin: Bool = false

    @State private var toPasswordChager : Bool = false
    @State private var toAppManager : Bool = false
    @State private var toConfirmation : Bool = false
    @State private var toListPreparator : Bool = false
    @State private var toBankIbans : Bool = false
    
    @Environment(\.presentationMode) var present
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack {
                HStack(spacing: 15){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text("Hesap Yönetimi")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    Group {
                        // Dips First
                        Button {
                            self.toCustomerServices.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                
                                HStack{
                                    
                                    Image(systemName: "headphones")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Müşteri Hizmetleri")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            self.toDeallerChanger.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "arrow.2.squarepath")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Bayiliği Değiştir")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                            Button {
                                self.toBalanceMaker.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    HStack{
                                        
                                        Image(systemName: "dollarsign")
                                            .foregroundColor(.white)
                                            .frame(width: 20)
                                        
                                        Text("Bakiye Güncelle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                        Spacer(minLength: 0)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 45)
                                .padding(.horizontal)
                            }
                        
                            Button {
                                self.toLiveData.toggle()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    HStack{
                                        
                                        Image(systemName: "arrow.triangle.merge")
                                            .foregroundColor(.white)
                                            .frame(width: 20)
                                        
                                        Text("Canlı Veri Bilgileri")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                        
                                        Spacer(minLength: 0)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 45)
                                .padding(.horizontal)
                            }
                        
                        Button {
                            self.toConfirmation.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "lanyardcard")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Hesap Onayı Bekleyenler")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }

                        Button {
                            self.toAppManager.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "gearshape.arrow.triangle.2.circlepath")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Müşteri Paneli Ayarları")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            self.toListPreparator.toggle()
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Satış Listesi Hazırla")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                        
                        Button {
                            self.toBankIbans.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Image(systemName: "building.2.crop.circle")
                                        .foregroundColor(.white)
                                        .frame(width: 20)
                                    
                                    Text("Havale EFT Bankaları")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }
                    }
                    
                    Button {
                        toPasswordChager.toggle()
                    } label: {
                        ZStack{
                            
                            
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "key.icloud")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                
                                Text("Şifre Güncelleme")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                    
                
                    Button {
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "hand.point.up.braille")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Destek")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                    
                    Button {
                        storeNick = ""
                        storePassword = ""
                        isNavigateToLogin.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Çıkış Yap")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $toBankIbans) {
            if #available(iOS 16.0, *) {
                BankIbans()
            }
        }
        .popover(isPresented: $toPasswordChager, content: {
            PasswordChanger(dealler: storeNick)
        })
        .fullScreenCover(isPresented: $toDeallerChanger) {
            MyDeallers(selectedDeallerID: storeSelectedApp)
        }
        .fullScreenCover(isPresented: $toBalanceMaker) {
            BalanceMaker()
        }
        .fullScreenCover(isPresented: $isNavigateToLogin, content: {
            AdminLogin()
        })
        .fullScreenCover(isPresented: $toCustomerServices, content: {
            CustomerServices(dealler: storeNick)
        })
        .fullScreenCover(isPresented: $toLiveData, content: {
            LiveDataListener()
        })
        .popover(isPresented: $toConfirmation) {
            AccountConfirmation()
        }
        .popover(isPresented: $toListPreparator) {
            ListPreparator()
        }
        .popover(isPresented: $toAppManager, content: {
            AppManager(dealler: storeNick)
        })
    }
}
