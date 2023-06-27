//
//  OrderMaker.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/19/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import WebKit
import SDWebImageSwiftUI
import PencilKit

struct OrderMaker: View {
    //MARK: Store
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var vipCardStore = VIPCardStore()
    @StateObject var selectedBankStore = SelectedBankStore()
    @StateObject var onlinePaymentSystem = OnlinePaymentSystem()
    @StateObject var listener = OrderResultListener()
    @StateObject var angelStore = AngelStore()
    
    //MARK: Researchers
    @StateObject var bayiResearcher = OrderWriterBayiiStore()
    @StateObject var referanceResearcher = RefResearcher()
    
    //MARK: AppStorage
    @AppStorage("savedTopHex") var savedTopHex : String = ""
    @AppStorage("savedTopHex") var savedBottomHex : String = ""
    
    
    //MARK: Bayi Input Values
    @State var bayiiId : String
    @State var selectedApp : String
    @State var bayiiImage : String = ""
    @State var bayiiName : String = ""
    @State var balance : Int = 0
    @State var bigoId : String = ""
    @State var change : Double = 1
    @State var giftTotal : Int = 0
    @State var inputBalance : Int = 0
    @State var isOnline : Bool = false
    @State var level : Int = 0
    @State var star : Int = 0
    @State var takenDiamond : Int = 0
    @State var totalBalance : Int = 0
    @State var willSellDiamond : Int = 0
    @State var barSize : CGFloat = 0
    @State var bayiiToken : String = ""
    @State var diamondLimit : Int = 0
    @State var isVIPCard : Bool = false
    
    //MARK: Values
    @Environment(\.presentationMode) var present
    @State private var diamond : String = "0"
    @State private var price : Int = 0
    @State private var inputPrice : String = ""
    @State private var cardSelector : Int = 0
    @State private var paymentCardSelector : Int = 1
    @State private var hexCodeTop: String = "#EDEFF4"
    @State private var hexCodeBottom:  String = "#77787A"
    @State private var lockPriceInput : Bool = false
    @State private var showCustomCard : Bool = false
    @State private var platformID : String = ""
    @State private var referanceCode : String = ""
    @State private var showQuestionForRefCode : Bool = false
    @State private var bodySelection : Int = 0
    @State private var canvasView = PKCanvasView()
    @State private var responseHTML : String = ""
    @State private var isSuccess : Bool = false
    @State private var state = UIApplication.shared.applicationState
    @State private var imgRect = CGRect(x: 0, y: 0, width: 300.0, height: 300.0)
    @State private var signatureImage = UIImage()
    @State private var isFindRefCode : Bool = false
    @State private var refCodeOwnerID : String = ""
    @State private var showRefCodeInfo : Bool = false
    
    //MARK: Bank Card Details
    @State private var cc_owner : String = ""
    @State private var cardNumber : String = ""
    @State private var expiryMonth : String = ""
    @State private var expiryYear : String = ""
    @State private var ccvSecurty : String = ""
    @State private var bankCode : String = ""
    @State private var selectedBankCode : String = ""
    
    //MARK: Presentations
    @State private var toListBankCard : Bool = false
    @State private var showPolicy : Bool = false
    
    //MARK: Alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    //MARK: Secure
    @State private var merchantoid : String = ""
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if self.bodySelection == 0 {
                getReadyBody
            }
            else if bodySelection == 1{
                signatureBody
            }
            else if bodySelection == 2 {
                paymentBody
            }
            else if bodySelection == 3 {
                paymentResult
            }
        }
        .onAppear{
            self.bayiResearcher.getData(bayiId: self.bayiiId, selectedDealler: "BigoLive")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.bayiiImage = bayiResearcher.bayiiImage
                self.bayiiName = bayiResearcher.bayiiName
                self.balance = bayiResearcher.balance
                self.bigoId = bayiResearcher.bigoId
                self.change = bayiResearcher.change
                print("debug \(change)")
                self.giftTotal = bayiResearcher.giftTotal
                self.isOnline = bayiResearcher.isOnline
                self.level = bayiResearcher.level
                self.star = bayiResearcher.star
                self.takenDiamond = bayiResearcher.takenDiamond
                self.totalBalance = bayiResearcher.totalBalance
                self.willSellDiamond = bayiResearcher.willSellDiamond
                self.bayiiToken = bayiResearcher.token
                self.diamondLimit = bayiResearcher.diamondLimit
                self.inputPrice = "100"
                self.platformID = userStore.bigoId
                let step1 = Double(inputPrice)! / self.change
                let result = step1 * Double(willSellDiamond)
                self.diamond = "\(Int(result))"
                self.price = Int(inputPrice)!
            }
        }
        .popover(isPresented: $showPolicy) {
            Policy(diamond: Int(self.diamond)!, price: Int(self.inputPrice)!)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .onChange(of: self.listener.result) { val in
            if val == 1 {
                self.isSuccess = true
                self.bodySelection = 3
            }
            else if val == 2 {
                self.isSuccess = false
                self.bodySelection = 3
            }
        }
        .onChange(of: state, perform: { val in
            let state = UIApplication.shared.applicationState
            if state == .active {
               print("I'm active")
                if self.merchantoid != "" {
                    self.listener.listen(merchant_oid: merchantoid)
                }
            }
            else if state == .inactive {
               print("I'm inactive")
            }
            else if state == .background {
               print("I'm in background")
            }
        })
    }
    
    var getReadyBody: some View {
        VStack{
            HStack{
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                
                Text("Get Ready Order")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            
            ZStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10){
                        
                        OrderWriterBayii(bayiiImage: $bayiiImage, bayiiName: $bayiiName, balance: $balance, bayiiId: $bayiiId, bigoId: $bigoId, change: $change, giftTotal: $giftTotal, inputBalance: $inputBalance, isOnline: $isOnline, level: $level, star: $star, takenDiamond: $takenDiamond, totalBalance: $totalBalance, willSellDiamond: $willSellDiamond, diamondLimit: $diamondLimit)
                            .padding(.bottom, 10)
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    TextField("Price", text: Binding(get: { self.inputPrice },
                                                                     set: { newValue in
                                        if self.isVIPCard {
                                            if let intValue = Int(newValue), intValue <= 50000 {
                                                self.inputPrice = newValue
                                            }
                                        } else {
                                            if let intValue = Int(newValue), intValue <= 20000 {
                                                self.inputPrice = newValue
                                            }
                                        }
                                    }))
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .preferredColorScheme(.dark)
                                        .padding(.horizontal)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .onChange(of: inputPrice) { value in
                                            if self.lockPriceInput == false {
                                                if Int(value) ?? 98 > 99 {
                                                    if value == "100" {
                                                        self.cardSelector = 0
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                    }
                                                    else if value == "200" {
                                                        self.cardSelector = 1
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                    }
                                                    
                                                    else if value == "500" {
                                                        self.cardSelector = 2
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                    }
                                                    
                                                    else if value == "1000" {
                                                        self.cardSelector = 3
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                    }
                                                    
                                                    else if value == "2000" {
                                                        self.cardSelector = 4
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                    }
                                                    else {
                                                        let step1 = Double(value)! / self.change
                                                        let result = step1 * Double(willSellDiamond)
                                                        self.diamond = "\(Int(result))"
                                                        self.price = Int(value)!
                                                        self.showCustomCard = true
                                                        self.cardSelector = 5
                                                    }
                                                }
                                                else {
                                                    self.showCustomCard = false
                                                    self.price = 100
                                                    self.diamond = "0"
                                                }
                                            }
                                        }
                                    
                                    Text("₺")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                }.padding(.horizontal)
                            }
                            
                            Text("=")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    
                                    Text("\(diamond)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    
                                    
                                    Image("dia")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20, alignment: Alignment.center)
                                }
                                .padding(.horizontal)
                                
                            }
                        }
                        .frame(height: 60)
                        .padding(.horizontal)

                            TabView(selection: $cardSelector){
                                
                                PricePack(price: 100, change: $change, willSellDiamond: $willSellDiamond, topLeadingColor: Color.init(red: 237 / 255, green: 239 / 255, blue: 244 / 255), bottomTrailingColor: Color.init(red: 119 / 255, green: 120 / 255, blue: 122 / 255), position1: .topLeading, position2: .bottomTrailing)
                                    .tag(0)
                                    .frame(height: 310)

                                PricePack(price: 200, change: $change, willSellDiamond: $willSellDiamond, topLeadingColor: Color.init(red: 231 / 255, green: 180 / 255, blue: 227 / 255), bottomTrailingColor: Color.init(red: 210 / 255, green: 116 / 255, blue: 188 / 255), position1: .topLeading, position2: .bottomTrailing)
                                    .tag(1)
                                    .frame(height: 310)

                                PricePack(price: 500, change: $change, willSellDiamond: $willSellDiamond, topLeadingColor: Color.init(red: 235 / 255, green: 138 / 255, blue: 80 / 255), bottomTrailingColor: Color.init(red: 160 / 255, green: 57 / 255, blue: 221 / 255), position1: .topLeading, position2: .bottomTrailing)
                                    .tag(2)
                                    .frame(height: 310)
                                
                                PricePack(price: 1000, change: $change, willSellDiamond: $willSellDiamond, topLeadingColor: Color.init(red: 34 / 255, green: 230 / 255, blue: 151 / 255), bottomTrailingColor: Color.init(red: 101 / 255, green: 34 / 255, blue: 117 / 255), position1: .topLeading, position2: .bottomTrailing)
                                    .tag(3)
                                    .frame(height: 310)
                                
                                PricePack(price: 2000, change: $change, willSellDiamond: $willSellDiamond, topLeadingColor: Color.init(red: 193 / 255, green: 10 / 255, blue: 136 / 255), bottomTrailingColor: Color.init(red: 52 / 255, green: 126 / 255, blue: 229 / 255), position1: .topLeading, position2: .bottomTrailing)
                                    .tag(4)
                                    .frame(height: 310)
                                
                                CustomPricePack(price: $price, change: change, willSellDiamond: willSellDiamond, topLeadingColor: Color.init(hex: self.savedTopHex), bottomTrailingColor: Color.init(hex: self.savedBottomHex), position1: .topLeading, position2: .bottomTrailing, hexCodeTop: $hexCodeTop, hexCodeBottom: $hexCodeBottom)
                                    .tag(5)
                                    .frame(height: 310)
                                
                            }
                            .frame(height: 310)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .padding()
                            .onChange(of: self.cardSelector) { select in
                                if select == 0 {
                                    self.inputPrice = "100"
                                    self.hexCodeTop = "#EDEFF4"
                                    self.hexCodeBottom = "#77787A"
                                }
                                else if select == 1 {
                                    self.inputPrice = "200"
                                    self.hexCodeTop = "#E7B4E3"
                                    self.hexCodeBottom = "#D274BC"
                                }
                                else if select == 2 {
                                    self.inputPrice = "500"
                                    self.hexCodeTop = "#EB8A50"
                                    self.hexCodeBottom = "#A039DD"
                                }
                                
                                else if select == 3 {
                                    self.inputPrice = "1000"
                                    self.hexCodeTop = "#22E697"
                                    self.hexCodeBottom = "#652275"
                                }
                                else if select == 4 {
                                    self.inputPrice = "2000"
                                    self.hexCodeTop = "#C10A88"
                                    self.hexCodeBottom = "#347EE5"
                                }
                                else if select == 5 {
                                    if self.savedBottomHex != "" && self.savedTopHex != "" {
                                        self.hexCodeTop = savedTopHex
                                        self.hexCodeBottom = savedBottomHex
                                    }
                                    else {
                                        self.hexCodeTop = "#B78628"
                                        self.hexCodeBottom = "#C69320"
                                    }
                                }
                                
                            }
                        
                        
                        
                        HStack{
                            
                            if self.vipCardStore.cardNo != "" {
                                Button {
                                    if self.angelStore.devils.contains(where: {$0.userID == Auth.auth().currentUser!.uid}) {
                                        self.alertTitle = "Uyarı"
                                        self.alertBody = "Ban hizmetlerinde şeytan olduğunuz için kullanamazsınız!"
                                        self.showAlert.toggle()
                                    }
                                    else {
                                        self.paymentCardSelector = 0
                                    }
                                    self.isVIPCard = true
                                } label: {
                                    if self.paymentCardSelector == 0 {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.white)
                                            
                                            Text("VIP Card")
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                                .bold()
                                        }
                                    }
                                    else {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.black.opacity(0.2))
                                            
                                            Text("VIP Card")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                self.paymentCardSelector = 1
                                self.lockPriceInput = false
                                self.cardSelector = 0
                                self.inputPrice = "100"
                                let step1 = Double(inputPrice)! / self.change
                                let result = step1 * Double(willSellDiamond)
                                self.diamond = "\(Int(result))"
                                self.price = Int(inputPrice)!
                                self.isVIPCard = false
                            } label: {
                                if self.paymentCardSelector == 1 {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white)
                                        
                                        Text("Bank Card")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .bold()
                                    }
                                }
                                else {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.black.opacity(0.2))
                                        
                                        Text("Bank Card")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                }
                            }
                            
                        }
                        .frame(height: 40)
                        .padding(.horizontal)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                TextField("Upload ID", text: $platformID)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .colorScheme(.dark)
                                
                                Image(userStore.selectedPlatform)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        if self.paymentCardSelector == 0 && self.vipCardStore.cardNo != "" {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                HStack{
                                    if self.vipCardStore.cardType == "VIP GOLD" {
                                        Image("goldCard")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 68)
                                    }
                                    else if self.vipCardStore.cardType == "VIP BLACK" {
                                        Image("blackCard")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 68)
                                    }
                                    else {
                                        Image("grayCard")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 68)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 20){
                                        
                                        Text("@"+userStore.nickname)
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                            .bold()
                                        
                                        HStack(spacing: 2){
                                            Text(vipCardStore.cardNo[0 ..< 4])
                                                .font(.system(size: 14))
                                                .fontWeight(.light)
                                            
                                            Text("****")
                                                .font(.system(size: 14))
                                                .fontWeight(.light)
                                            
                                            Text("****")
                                                .font(.system(size: 14))
                                                .fontWeight(.light)
                                            
                                            Text(vipCardStore.cardNo[12 ..< 16])
                                                .font(.system(size: 14))
                                                .fontWeight(.light)
                                            
                                            
                                        }
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                    VStack(alignment: .center, spacing: 20){
                                        
                                        Text("\(vipCardStore.totalPrice) ₺")
                                            .font(.system(size: 14))
                                            .fontWeight(.light)
                                    }
                                }
                                .padding(10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 90)
                        }
                        else if self.paymentCardSelector == 1 {
                            
                            Group{
                                if self.userStore.referanceCode == "" {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.2))
                                        
                                        HStack{
                                            TextField("Reference Code (Optional)", text: $referanceCode)
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                                .colorScheme(.dark)
                                                .onChange(of: referanceCode) { value in
                                                    findRefCode(refCode: value)
                                                }
                                            
                                            if self.refCodeOwnerID != "" {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 20))
                                            }
                                            else {
                                                Button {
                                                    self.alertTitle = "Referans Kodu Hakkında"
                                                    self.alertBody = "Referans kodunu tek bir kez kullanabilirsiniz. Desteklediğiniz yayıncı size referans kodu verdiği taktirde kullabilirsiniz. Hep siz hem desteklediğiniz yayıncı kazanır."
                                                    self.showAlert.toggle()
                                                    
                                                } label: {
                                                    Image(systemName: "questionmark.circle")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 20))
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal)
                                }
                                
                                
                                
                                ForEach(self.selectedBankStore.selectedCard){ item in
                                    
                                    SelectedBankCard_Writer(bankName: item.bankName, cardCVC: item.cardCVC, cardNo: item.cardNo, experiationMonth: item.expirationMonth, experiationYear: item.expirationYear, holderName: item.holderName, takenName: item.takenName, bankCode: item.bankCode, cardType: item.cardType)
                                        .onAppear{
                                            self.cc_owner = item.holderName
                                            self.bankCode = item.bankCode
                                            self.expiryMonth = "\(item.expirationMonth)"
                                            self.expiryYear = "\(item.expirationYear)"
                                            self.ccvSecurty = "\(item.cardCVC)"
                                            self.selectedBankCode = item.cardNo
                                        }
                                }
                                
                                
                                if self.selectedBankStore.selectedCard.isEmpty {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.black.opacity(0.22))
                                        
                                        HStack{
                                            Text("Choose Bank Card")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                                .bold()
                                        }
                                    }
                                    .frame(height: 90)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        self.toListBankCard.toggle()
                                    }
                                    .popover(isPresented: $toListBankCard) {
                                        ListBankCard(lastCardCode: selectedBankCode)
                                    }
                                }
                            }
                            
                            if self.selectedBankStore.holderName != "\(self.userStore.firstName) \(self.userStore.lastName)" {
                                Text("With the name on your debit card, the name must be old. Otherwise, do it.")
                                    .foregroundColor(.red)
                                    .font(.system(size: 18))
                                    .bold()
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                            }
                            
                            
                            if self.paymentCardSelector == 1 {
                                VStack{
                                    Button {
                                        self.showPolicy.toggle()
                                    } label: {
                                        Text("By placing an order, you accept the 'Distance Sales Agreement' and preliminary information. As per the Security Agreement, your card information is not stored. A single withdrawal is made securely from your card.")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 20)
                                    }

                                }.padding()
                            }
                            
                            
                        }
                        
                        
                        if Int(self.inputPrice) ?? 0 >= 100 && self.inputPrice != "" && self.paymentCardSelector == 1{

                            HStack{
                                
                                Text("\(self.inputPrice)₺")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))

                                Spacer(minLength: 5)

                                Image("visa")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)

                                Image("AExpress")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)

                                Image("mastercard")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)

                                Image("troy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                    .cornerRadius(3)

                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                            .padding(.bottom, 10)
                        }
                        else if self.paymentCardSelector == 0{
                            
                            Text("Your credit will decrease from your card.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.vertical)
                        }
                        
                        HStack{
                            Button {
                                self.present.wrappedValue.dismiss()

                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)

                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.light)
                                }
                            }
                            
                            Button {
                                if paymentCardSelector == 0 {
                                    if vipCardStore.totalPrice < Int(inputPrice)! {
                                        self.alertTitle = "Insufficient balance!"
                                        self.alertBody = "Please add money to your VIP Card!"
                                        self.showAlert.toggle()
                                    }
                                    else if self.platformID == "" {
                                        self.alertTitle = "Insufficient Platform ID"
                                        self.alertBody = "Type the will upload Platform ID"
                                        self.showAlert.toggle()
                                    }
                                    else {
                                        let ref = Firestore.firestore()
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document(userStore.vipType).setData([
                                            "totalPrice" : vipCardStore.totalPrice - Int(inputPrice)!
                                        ], merge: true)
                                        sendOrder(transferType: "VIP Card")
                                        
                                    }
                                }
                                else {
                                    if self.selectedBankStore.cardNo == "" {
                                        self.alertTitle = "No bank card!"
                                        self.alertBody = "You need add the bank card information to continue"
                                        self.showAlert.toggle()
                                    }
                                    else if self.platformID == "" {
                                        self.alertTitle = "Sorry"
                                        self.alertBody = "You should fill the upload Id to continue!"
                                        self.showAlert.toggle()
                                    }
                                    else if Int(self.inputPrice)! < 100 {
                                        self.alertTitle = "Change the order price!"
                                        self.alertBody = "You can order at least 100 Turkish lira!"
                                        self.showAlert.toggle()
                                    }
                                    else if "\(self.userStore.firstName.uppercased()) \(self.userStore.lastName.uppercased())" != self.selectedBankStore.holderName {
                                        self.alertTitle = "Sorry"
                                        self.alertBody = "Your fullname and added bank card owner fullname do not match!"
                                        self.showAlert.toggle()
                                    }
                                    else {
                                        pay()
                                    }
                                }

                            } label: {
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("Order Now")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .fontWeight(.light)
                                }
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        
                    }
                }
                
                VStack{
                    
                    Spacer()
                    
                    
                    HStack{
                        Spacer()
                        
                        Button {
                            UIApplication.shared.endEditing()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }
                            .frame(width: 40, height: 40)
                        }

                    }
                }
                .padding(.all)
            }
        }
    }
    
    var signatureBody : some View {
        VStack(spacing: 20){
            
            
            HStack{
                
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
                    .frame(width: 45, height: 45)
                }

                Text("Verify Signature")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal, .top])
            
            Spacer(minLength: 0)
            
            ZStack{
                
                VStack{
                    WebImage(url: URL(string: self.userStore.signatureURL))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(height: 200)
                        .opacity(0.5)
                }
                .cornerRadius(8)
                
                PencilCanvas(canvasView: $canvasView)
                    .cornerRadius(8)
                    .colorScheme(.light)
                    .opacity(0.6)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray)
                    .frame(height: 5)
                    .offset(y: 80)
            }
            .frame(maxHeight: 200)
            .padding(.horizontal)
            
            Text("By adding your signature, you agree that the transaction belongs to you. Otherwise, you cannot perform the operation.")
                .font(.system(size: 15))
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
            
            Button {
                pay()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white)
                    
                    Text("Tamamla")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    
                    
                }
                .frame(height: 45)
            }
            .padding(.all)
        }
    }
    
    var paymentBody: some View {
        VStack{
            WebView(text: $responseHTML)
        }
    }
    
    var paymentResult : some View {
        VStack(spacing: 30){
            
            Spacer()
            
            WebImage(url: URL(string: self.userStore.pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 150, height: 150)
            
            Text("ID : \(self.platformID)")
                .foregroundColor(.white)
                .font(.system(size: 20))
            
            ZStack{
                Image("paymentCircle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                
                if self.isSuccess == true {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)

                }
                else {
                    
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                }
            }
            .frame(height: 120)
            
            Text("\(self.price)₺")
                .foregroundColor(.white)
                .font(.system(size: 40))
                .bold()
            
            HStack{
                Text("\(self.diamond)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .fontWeight(.regular)
                
                Image("dia")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            
            Spacer()
            
            if self.isSuccess == true{
                Text("Your transaction has been successfully completed")
                    .foregroundColor(Color.white.opacity(0.7))
                    .font(.system(size: 17))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.bottom, 30)
            }
            else {
                Text("Maalesef işleminizi tamamlayamadık! lütfen daha sonra tekrar deneyin")
                    .foregroundColor(Color.white.opacity(0.7))
                    .font(.system(size: 17))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.bottom, 30)
            }
        }
        .onAppear{
            if isSuccess {
                sendOrder(transferType: "Online Payment")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.present.wrappedValue.dismiss()
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.present.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func pay(){
        
        let randomNumber = Int.random(in: 9999..<999999)
        
        let merchant_salt = onlinePaymentSystem.merchant_salt
        let merchant_key = onlinePaymentSystem.merchant_key
        
        //Card Info
        let cc_owner = "\(self.selectedBankStore.holderName)"
        let card_number = "\(self.selectedBankStore.cardNo)"
        let expiry_month = "\(self.selectedBankStore.expirationMonth)"
        let expiry_year = "\(self.selectedBankStore.expirationYear)"
        let cvv = "\(self.selectedBankStore.cardCVC)"
        
        //Merchant and UserInfo
        let merchant_id = onlinePaymentSystem.merchant_id
        let user_ip = "192.168.1.48"
        let merchant_oid = "odemeislemi\(randomNumber)complate"
        let email = "\(self.userStore.email)"
        let payment_amount = "\(self.inputPrice).00"
        let payment_type = "card"
        let installment_count = 0
        let merchant_ok_url = onlinePaymentSystem.merchant_ok_url
        let merchant_fail_url = onlinePaymentSystem.merchant_fail_url
        let user_name = "\(self.userStore.firstName) \(self.userStore.lastName)"
        let user_phone = "\(self.userStore.phoneNumber)"
        let user_address = "\(self.userStore.adress)"
        let basket = [["\(self.diamond)ELMAS", "\(self.inputPrice).00", "1"]]
        let debug_on = 0
        let currency = "TL"
        let test_mode = 0
        let non_3d = 0
        let client_lang = "tr"
        let non3d_test_failed = 0
        let request_exp_date = Int(NSDate().timeIntervalSince1970) + 120
        print("REsss \(request_exp_date)")
        let hash_str = "\(merchant_id)\(user_ip)\(merchant_oid)\(email)\(payment_amount)\(payment_type)\(installment_count)\(request_exp_date)\(currency)\(test_mode)\(non_3d)"
        let token = "\(hash_str)\(merchant_salt)".hmac(algorithm: HMACAlgorithm.SHA256, key: merchant_key)
        
        if token.contains("+") {
            pay()
        }
        else {
            let postURL = URL(string: onlinePaymentSystem.post_url)!
            let paramaters = "&cc_owner=\(cc_owner)&card_number=\(card_number)&expiry_month=\(expiry_month)&expiry_year=\(expiry_year)&cvv=\(cvv)&merchant_id=\(merchant_id)&user_ip=\(user_ip)&merchant_oid=\(merchant_oid)&email=\(email)&payment_type=\(payment_type)&payment_amount=\(payment_amount)&request_exp_date=\(request_exp_date)&currency=\(currency)&test_mode=\(test_mode)&non_3d=\(non_3d)&merchant_ok_url=\(merchant_ok_url)&merchant_fail_url=\(merchant_fail_url)&user_name=\(user_name)&user_address=\(user_address)&user_phone=\(user_phone)&user_basket=\(basket)&debug_on=\(debug_on)&client_lang=\(client_lang)&paytr_token=\(token)&non3d_test_failed=\(non3d_test_failed)&installment_count=\(installment_count)&card_type=\("bonus")"
            
            var request = URLRequest(url: postURL)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = paramaters.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { dat, res, err in
                let data = dat?.base64EncodedString()
                let base64Encoded = data
                let decodedData = Data(base64Encoded: base64Encoded!)
                let decodedString = String(data: decodedData!, encoding: .utf8)!
                
                
                self.responseHTML = decodedString
                
                let ref = Firestore.firestore()
                ref.collection("OnlineOrder").document(merchant_oid).setData(["result" : 0], merge: true)
                
                self.merchantoid = merchant_oid
                
                print("REsss \(merchant_oid)")
                
                self.listener.listen(merchant_oid: merchant_oid)
                
                self.merchantoid = merchant_oid
                self.bodySelection = 2
                
            }.resume()
        }
    }
    
    func findRefCode(refCode: String){
        let ref = Firestore.firestore()
        if refCode != "" {
            ref.collection("Reference").document(refCode).addSnapshotListener { doc, err in
                if err == nil {
                    if let refCodeOwner = doc?.get("contactUserId") as? String {
                        self.refCodeOwnerID = refCodeOwner
                        print("res data \(refCodeOwner)")
                    }
                }
                else {
                    print(err!.localizedDescription)
                }
            }
        }
    }
    
    func sendOrder(transferType : String){
        let orderID = UUID().uuidString
        
        let timeStamp = Date().formatted(date: .abbreviated, time: .complete)
        
        let date = Date()
        let monthFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        monthFormatter.dateFormat = "MMMM"
        yearFormatter.locale = Locale(identifier: "tr_TRPOSIX")
        yearFormatter.dateFormat = "yyyy"
        let month = monthFormatter.string(from: date)
        let year = yearFormatter.string(from: date)
        
        let data = [
            "userID" : Auth.auth().currentUser!.uid,
            "platformID" : platformID,
            "platform" : userStore.selectedPlatform,
            "price" : price,
            "timeStamp" : Int(timeStamp),
            "transferType" : transferType,
            "signatureURL" : "",
            "hexCodeTop" : hexCodeTop,
            "hexCodeBottom" : hexCodeBottom,
            "refCode" : referanceCode,
            "product" : Int(diamond)!,
            "streamerGivenGift" : 0,
            "month" : month,
            "year" : year,
            "deallerID" : bayiiId,
            "result" : 0
        ] as [String : Any]
        
        let ref = Firestore.firestore()
        ref.collection("Orders").document(orderID).setData(data, merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "referanceCode" : referanceCode,
            "totalSoldDiamond" : self.userStore.totalSoldDiamond + Int(diamond)!
        ], merge: true)
        
        if self.signatureImage != UIImage() {
            saveSignature(orderID: orderID)
        }
        
        haptic(style: .rigid)
        playSound(sound: "coin", type: "mp3")
        sendPushNotify(title: "Bekleyen Yüklemen Var!", body: "ID: \(self.bigoId) - \(self.price)₺ = \(self.diamond)💎", userToken: self.bayiiToken, sound: "pay.mp3")
        
        if transferType != "Online Payment" {
            self.bodySelection = 3
            self.isSuccess = true
        }
    }
    
    func saveSignature(orderID: String) {
        let img = canvasView.drawing.image(from: imgRect, scale: 1.0)
        self.signatureImage = img
        
        guard let signatureData: Data = signatureImage.jpegData(compressionQuality: 0.50) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let currentUser = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(withPath: "Signatures/\(currentUser)/OrderSecure\(UUID().uuidString)")
        
        storageRef.putData(signatureData, metadata: metaDataConfig){ (metaData, error) in
            storageRef.downloadURL(completion: { (signatureURL: URL!, error: Error?) in
                let ref = Firestore.firestore()
                ref.collection("Orders").document(orderID).setData([
                    "signatureURL" : signatureURL.absoluteString
                ], merge: true)
            })
        }
    }
}


//                        if userStore.vipType == "VIPSILVER" {
//                            VIPPricePack(diamond: $diamond, change: change, willSellDiamond: willSellDiamond, topLeadingColor: Color.init(red: 212 / 255, green: 212 / 255, blue: 212 / 255), bottomTrailingColor: Color.init(red: 186 / 255, green: 186 / 255, blue: 186 / 255))
//                                .padding(.horizontal)
//                                .padding(.vertical, 21)
//                        }
//                        else if userStore.vipType == "VIPBLACK" {
//                            VIPPricePack(diamond: $diamond, change: change, willSellDiamond: willSellDiamond, topLeadingColor: Color.init(red: 59 / 255, green: 59 / 255, blue: 59 / 255), bottomTrailingColor: Color.init(red: 59 / 255, green: 59 / 255, blue: 59 / 255))
//                                .padding(.horizontal)
//                                .padding(.vertical, 21)
//                        }
//                        else if userStore.vipType == "VIPGOLD" {
//                            VIPPricePack(diamond: $diamond, change: change, willSellDiamond: willSellDiamond, topLeadingColor: Color.init(red: 238 / 255, green: 222 / 255, blue: 180 / 255), bottomTrailingColor: Color.init(red: 221 / 255, green: 192 / 255, blue: 139 / 255))
//                                .padding(.horizontal)
//                                .padding(.vertical, 21)
//                        }
