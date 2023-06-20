//
//  AddBankCard.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 11/5/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import LocalAuthentication
import FirebaseAuth
import CreditCardReader


extension View {
    func splitAndJoin(_ string: String, by chunkSize: Int, separator: String) -> String {
        // String'i belirli boyutta parçalara ayırıyoruz
        let chunks = stride(from: 0, to: string.count, by: chunkSize).map {
            String(string[string.index(string.startIndex, offsetBy: $0)..<string.index(string.startIndex, offsetBy: min($0 + chunkSize, string.count))])
        }
        // Parçaları belirli bir ayırıcı ile birleştiriyoruz
        return chunks.joined(separator: separator)
    }
}

struct AddBankCard: View {
    
  
    
    @State private var newCardNo: String = ""

    @StateObject var selectedCard = SelectedBankStore()
    @StateObject var general = GeneralStore()
    @StateObject var onlinePaymentSystem = OnlinePaymentSystem()
    @StateObject var listener = OrderResultListener()
    @StateObject var bankDetect = BankCardDetectApi()
    @StateObject var userStore = UserInfoStore()
    @Environment(\.presentationMode) var present
    @AppStorage("saveLastCardNo") var saveLastCardNo : String = ""
    @AppStorage("bankName") var detectedBank : String = ""
    @AppStorage("cardType") var cardType : String = ""
    @State private var selection = 0
    @State private var state = UIApplication.shared.applicationState
    @State var takenName : String = ""
    @State var bankName : String = ""
    @State var cardCVC : String = ""
    @State var cardNo : String = ""
    @State var expirationMonth : String = "Month"
    @State var expirationYear : String = "Year"
    @State var holderName : String = ""
    @State var bankCode : String = ""
    @State private var showBankCodeInfo = false
    @State private var openScanner = false
    @State private  var numberArray = [1,2,3,4,5,6,7,8,9,10,11,12]
    @State private var cardNumber1 = ""
    @State private var cardNumber2 = ""
    @State private var cardNumber3 = ""
    @State private var cardNumber4 = ""
    
    @State private var showAlert : Bool = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var editTime : Bool = false
    @State private var bodySelection : Int = 0
    @State private var htmlCode : String = ""
    @State private var isSuccess = false
    @State private var merchantoid = ""
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if self.bodySelection == 0 {
                makerBody
            }
            else if self.bodySelection == 1 {
                paymentBody
            }
            
            if self.showBankCodeInfo == true {
                ZStack{
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).onTapGesture {
                        self.showBankCodeInfo.toggle()
                    }
                    
                    Image("bankCodeInfo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                }
            }
        }
        .fullScreenCover(isPresented: $openScanner) {
            CreditCardReaderView(
                defaultNavigationBar: .init(
                    titleText: "Scan your card",
                    closeText: "Cancel"),
                defaultUIControls: .init(
                    instructionsText: "Align cart on camera frame",
                    isRetryEnabled: false)
            ) { card, _ in
                self.cardNo = card.cardNumber
                self.expirationMonth = card.expirationMonthString ?? ""
                self.expirationYear = card.expirationYearString ?? ""
            }
        }
        .onDisappear{
            self.detectedBank = ""
            self.cardType = ""
        }
        .onAppear{
            print("bank name \(bankName)")
            if self.bankName != "" {
                self.detectedBank = bankName
                print("bank img \(detectedBank)")
                self.editTime = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .onChange(of: listener.result) { val in
            if val == 1 {
                setData()
            }
            else if val == 2 {
                self.bodySelection = 0
                self.alertTitle = "İşleminiz Reddedildi!"
                self.alertBody = "Kart bilgilerinizi kontrol ederek tekrar deneyiniz"
                self.showAlert.toggle()
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
    
    var makerBody: some View {
        VStack{
            
            HStack{
                
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45, alignment: Alignment.center)
                
                Text("Add New Bank Card")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading , 5)
                
                Spacer(minLength: 0)
                
                

            }
            .padding([.horizontal, .top])
            
            ScrollView(showsIndicators: false){
                if self.selection == 0 {
                    ZStack{
                        Image("cardBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack{
                            HStack{
                                
                                Image(detectedBank) // Bank Image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(8)
                                    .padding()
                                
                                Text(self.bankName.uppercased())
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .bold()
                                
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width * 0.9)
                            
                            Spacer(minLength: 0)
                            
                            HStack(spacing: 5) {
                                if self.cardNo.count >= 4 {
                                    Text(cardNo[0 ..< 4])
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .padding([.leading, .top, .bottom])
                                        .onChange(of: cardNo) { val in
                                            if self.cardNo.count < 6 {
                                                self.bankName = ""
                                                self.cardType = ""
                                                self.detectedBank = ""
                                            } else {
                                                bankDetect.detectCard(SixCode: self.cardNo)
                                                self.bankName = self.detectedBank
                                            }
                                        }
                                }
                                
                                if self.cardNo.count >= 8 {
                                    Text(cardNo[4 ..< 8])
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .padding([.top, .bottom])
                                }
                                
                                if self.cardNo.count >= 12 {
                                    Text(cardNo[8 ..< 12])
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .padding([.top, .bottom])
                                }
                                
                                if self.cardNo.count >= 16 {
                                    Text(cardNo[12 ..< 16])
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                        .padding([.top, .bottom])
                                        
                                    
                                }
                                
                                Spacer()
                                
                            }
                            
                            Spacer(minLength: 0)
                            
                            if self.expirationYear != "Month" && self.expirationYear != "Year" {
                                Text("\(self.expirationMonth)/\(self.expirationYear)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .fontWeight(.medium)
                            }
                            
                            Spacer(minLength: 0)
                            
                            HStack(alignment: .bottom){
                                Text(self.holderName.uppercased())
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                
                                Spacer(minLength: 0 )
                                
                                
                                Image(cardType)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 30)
                                    .clipped()
                                    .cornerRadius(8)
                                    .padding()
                                
                                
                            }.frame(width: UIScreen.main.bounds.width * 0.9)
                            
                                            
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.vertical, 10)
                    
                }
                else {
                    ZStack{
                        Image("cardBackView")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack{
                            HStack{
                                Spacer()
                                
                                Text(self.cardCVC)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .italic()
                                    .fontWeight(.thin)
                                    .padding(.trailing, 30)

                                
                            }.padding(.top, 15)
                                .frame(width: UIScreen.main.bounds.width * 0.77)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.vertical, 10)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.11))
                    
                    TextField("Card Taken Name", text: $takenName)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .preferredColorScheme(.dark)
                        .onTapGesture{
                            self.selection = 0
                        }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.11))
                    
                    TextField("Holder Name", text: $holderName)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.horizontal)
                        .onTapGesture{
                            self.selection = 0
                        }
                        .onChange(of: holderName) { val in
                            if val == " " {
                                self.cardCVC.removeLast()
                            }
                        }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.11))
                        
                        if self.editTime {
                            HStack{
                                Text(cardNo)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(.horizontal)
                                Spacer(minLength: 0)
                            }
                        }
                        else {
                            HStack{
                                //MARK: Card Number Textfields
                                TextField("4543 **** **** 0001", text: $cardNo.limit(16))
                                    .foregroundColor(.clear)
                                    .font(.system(size: 20))
                                    .padding(.trailing)
                                    .keyboardType(.numbersAndPunctuation)
                                    .padding(.trailing)
                                    .onTapGesture{
                                        self.selection = 0
                                    }
                                    .onChange(of: cardNo) { card in
                                                                            
                                        self.newCardNo = splitAndJoin(card, by: 4, separator: " ")
                                    }
                                    .overlay {
                                        HStack(spacing: 10) {
                                            Text(newCardNo)
                                            Spacer()
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.6, height: 40)
                                        .padding(.leading)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 40)
                                
                                Button {
                                    openScanner.toggle()
                                } label: {
                                    Image("scannerIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }
                                .padding(.trailing)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 40)
                        }
                    }

                }.frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                

                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.11))
                        
                        HStack{
                            Menu(expirationMonth){
                                
                                ForEach(numberArray, id: \.self){ item in
                                    Button {
                                        self.expirationMonth = "\(item)"
                                    } label: {
                                        Text("\(item)")
                                    }

                                }
                                

                            }
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.horizontal)
                            
                            Spacer(minLength: 0)
                            
                        }
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.11))
                        
                        HStack{
                            Menu(expirationYear){
                                Button {
                                    self.expirationYear = "22"
                                } label: {
                                    Text("2022")
                                }
                                
                                Button {
                                    self.expirationYear = "23"
                                } label: {
                                    Text("2023")
                                }
                                
                                Button {
                                    self.expirationYear = "24"
                                } label: {
                                    Text("2024")
                                }
                                
                                Button {
                                    self.expirationYear = "25"
                                } label: {
                                    Text("2025")
                                }
                                
                                Button {
                                    self.expirationYear = "26"
                                } label: {
                                    Text("2026")
                                }
                                
                                Button {
                                    self.expirationYear = "27"
                                } label: {
                                    Text("2027")
                                }
                                
                                Button {
                                    self.expirationYear = "28"
                                } label: {
                                    Text("2028")
                                }
                                
                                Button {
                                    self.expirationYear = "29"
                                } label: {
                                    Text("2029")
                                }
                                
                                Button {
                                    self.expirationYear = "30"
                                } label: {
                                    Text("2030")
                                }
                                
                                
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.horizontal)
                            
                            Spacer(minLength: 0)
                            
                        }
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.11))
                        
                        TextField("CVV", text: $cardCVC)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.horizontal)
                            .keyboardType(.numbersAndPunctuation)
                            .onTapGesture{
                                self.selection = 1
                            }
                            .onChange(of: cardCVC) { val in
                                if val == " " {
                                    self.cardCVC.removeLast()
                                }
                                
                                if val.count > 4 {
                                    self.cardCVC.dropLast(1)
                                    
                                }
                            }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                HStack{
                    Text("By adding your credit or debit card, you agree to the User agreement and Privacy Policy. Safety is our first priority.")
                        .foregroundColor(.white)
                        .font(.footnote)
                    
                    Spacer()
                    
                }.frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.top, 20)
                
                HStack{
                    Text("This card information is kept under the guarantee of MasterPass.")
                        .foregroundColor(.white)
                        .font(.footnote)
                    
                    Spacer()
                    
                }.frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(.top, 20)
                    .padding(.bottom)
                
                HStack{
                    
                    Image("masterPass")
                        .resizable()
                        .scaledToFit()
                    
                    
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
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                
                
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.init(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
                            
                            Text("Cancel")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    
                    Button {
                        if self.takenName == "" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please fill the Card Taken Name"
                            self.showAlert.toggle()
                        }
                        else if self.holderName == "" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please fill the Holder Name"
                            self.showAlert.toggle()
                        }
                        else if cardNo == "" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please fill the Card Number (16 count)"
                            self.showAlert.toggle()
                        }
                        else if cardNo.count != 16 {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Card number be 16 (sixteen character)"
                            self.showAlert.toggle()
                        }
                        else if expirationMonth == "Month" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please select the expiry month"
                            self.showAlert.toggle()
                        }
                        else if expirationYear == "Year" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please select the expiry year"
                            self.showAlert.toggle()
                        }
                        else if cardCVC == "" {
                            self.alertTitle = "Sorry"
                            self.alertBody = "Please fill the your bank card's security code"
                            self.showAlert.toggle()
                        }
                        else {
                            authenticate()
                        }
                        
                        
                    } label: {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                            
                            Text("Save")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.9 , height: 50)
                    .padding(.bottom)
            }
        }
    }
    
    var paymentBody: some View {
        VStack{
            WebView(text: $htmlCode)
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error:NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Siparişini onaylayabilmem için buna ihtiyacım var"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    pay()
                }else {
                    self.alertTitle = "Devam Edemiyoruz"
                    self.alertBody = "FaceID veya TouchID işlemi tamamlanmadan devam edemeyiz."
                    self.showAlert.toggle()
                }
            })
        }
        else {
            self.alertTitle = "Devam Edemiyoruz"
            self.alertBody = "İşleminiz red edildi! Lütfen daha sonra tekrar deneyiniz"
            self.showAlert.toggle()
        }
    }
    
    func pay(){
        
        let randomNumber = Int.random(in: 9999..<999999)
        
        let merchant_salt = onlinePaymentSystem.merchant_salt
        let merchant_key = onlinePaymentSystem.merchant_key
        
        //Card Info
        let cc_owner = holderName
        let card_number = cardNo
        let expiry_month = expirationMonth
        let expiry_year = expirationYear
        let cvv = cardCVC
        
        //Merchant and UserInfo
        let merchant_id = onlinePaymentSystem.merchant_id
        let user_ip = "176.88.30.171"
        let merchant_oid = "bankkarteklemeislemi\(randomNumber)complate"
        let email = "\(self.userStore.email)"
        let payment_amount = "3.00"
        let payment_type = "card"
        let installment_count = 0
        let merchant_ok_url = onlinePaymentSystem.merchant_ok_url
        let merchant_fail_url = onlinePaymentSystem.merchant_fail_url
        let user_name = "\(self.userStore.firstName) \(self.userStore.lastName)"
            let user_phone = "\(self.userStore.phoneNumber)"
        let user_address = "\(self.userStore.adress)"
        let basket = [["\(cardNo) numarali banka kartı", "1.00", "1"]]
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
                self.htmlCode = decodedString
                let ref = Firestore.firestore()
                ref.collection("OnlineOrder").document(merchant_oid).setData(["result" : 0], merge: true)
                self.listener.listen(merchant_oid: merchant_oid)
                self.merchantoid = merchant_oid
                print("REsss \(merchant_oid)")
                self.listener.listen(merchant_oid: merchant_oid)
                self.merchantoid = merchant_oid
                self.bodySelection = 1
                
            }.resume()
        }
    }
    
    func setData(){
        let data = [
            "bankCode" : cardNo[0 ..< 6],
            "bankName" : self.bankName,
            "cardNo" : self.cardNo,
            "cardCVC" : self.cardCVC,
            "expirationMonth" : Int(self.expirationMonth)!,
            "expirationYear" : Int(self.expirationYear)!,
            "holderName" : self.holderName.uppercased(),
            "takenName" : self.takenName,
            "cardType" : cardType
        ] as! [String : Any]
        
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("BankInformations").document(self.cardNo).setData(data)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SelectedBank").document(self.cardNo).setData(data)
        
        if self.saveLastCardNo != "" {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SelectedBank").document(saveLastCardNo).delete()
        }
        self.present.wrappedValue.dismiss()
    }
}
