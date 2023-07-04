//
//  TaxFreeApplication.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/12/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TaxFreeApplication: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var listener = OrderResultListener()
    @StateObject var userStore = UserInfoStore()
    @StateObject var bankCardStore = BankCardStore()
    @StateObject var selectedBankStore = SelectedBankStore()
    @StateObject var onlinePaymentSystem = OnlinePaymentSystem()
    
    @Binding var successAlert : Bool
    @State var showBackButton : Bool = true
    
    @State private var tcNo : String = ""
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var email : String = ""
    @State private var phoneNumber : String = ""
    @State private var addres : String = ""
    
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    @State private var progres : Int = 0
    
    // bank card
    @State private var cc_owner : String = ""
    @State private var bankCode : String = ""
    @State private var expiryMonth : String = ""
    @State private var expiryYear : String = ""
    @State private var ccvSecurty : String = ""
    @State private var selectedBankCode : String = ""
    
    @State private var toListBankCard : Bool = false
    @State private var toMaker : Bool = false
    
    //Payment
    @State private var htmlCode : String = ""
    @State private var showWebView: Bool = false
    @State private var showResult : Bool = false
    @State private var merchantoid : String = ""
    @State private var transactionComplated : Bool = false
    @State private var state = UIApplication.shared.applicationState
    
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                if !self.showWebView {
                    HStack(spacing: 12){
                        if showBackButton {
                            Button {
                                self.present.wrappedValue.dismiss()
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
                        }
                        else {
                            Image("logoWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45, alignment: Alignment.center)
                        }
                        
                        Text("Vergi Muafiyet Belgesi")
                            .foregroundColor(.white)
                            .font(.title2)
                        
                        Spacer(minLength: 0)

                    }
                    .padding([.horizontal, .top])
                }
                    // BURAĞISSS
                if self.userStore.taxapplicationId == "" {
                    if userStore.accountLevel == 0 && self.userStore.myAgencyId.isEmpty {
                        applicationBody
                            .disabled(true)
                            .opacity(0.4)
                            .onAppear {
                                self.showAlert.toggle()
                            }
                            .alert(Text("Dikkat"), isPresented: $showAlert) {
                                Button("Tamam") {
                                    present.wrappedValue.dismiss()
                                }
                            } message: {
                                Text("Bu özelliği kullanabilmek için herhangi bir ajansa bağlı olabilmeniz gerekmektedir.")
                            }

                            
                            
                    } else {
                        applicationBody
                    }
                    
                }
                else {
                    if progres == 0 {
                        WaitingBody
                    }
                    else if progres == 1{
                        if showWebView {
                            onlinePaymentScreen
                        }
                        else {
                            if self.showResult {
                                resultBody
                            }
                            else {
                                paymentBody
                            }
                        }
                    }
                    else if self.progres == 2{
                        willSendMailBody
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .fullScreenCover(isPresented: $toMaker, content: {
            SalaryBankCreater()
        })
        .onChange(of: userStore.email) { newValue in
            self.firstName = userStore.firstName
            self.lastName = userStore.lastName
            self.phoneNumber = userStore.phoneNumber
            self.email = userStore.email
            self.addres = userStore.adress+" \(userStore.city)/\(userStore.town)"
            self.tcNo = userStore.tcNo
        }
        .onChange(of: userStore.taxapplicationId) { val in
            getData(id: val)
        }
        .onChange(of: self.listener.result) { val in
            if val == 1 {
                self.showWebView = false
                showResult.toggle()
                
            }
            else if val == 2 {
                self.showWebView = false
                showResult.toggle()
                
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
    
    var applicationBody: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Image("taxFreeImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 95, height: 71)
                    
                    Text("Sosyal medya içerik üreticileri için oluşturacağımız vergi muafiyeti belgesi alarak, elde ettiğiniz kazanç için vergiden muafiyet imkanından yararlanabileceksiniz.")
                        .foregroundColor(.white)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("TC Kimlik No", text: $tcNo)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Adınız", text: $firstName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Soyad", text: $lastName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                    }
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("Telefon Numarası", text: $phoneNumber)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    TextField("İkamet Adresi", text: $addres)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .frame(height: 45)
                .padding(.horizontal)
                
                Text("Başvurunuz onaylandıktan sonra tutar tahsil edilecektir. Başvurunuzu göndererek Kişisel Verilerin Korunması Kanununu (KVKK) kabul etmiş olursunuz.")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal, .top])
            
                
                HStack{
                    Text("150₺")
                        .foregroundColor(.white)
                        .font(.system(size: 26))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        if self.tcNo.count != 11 {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "TC kimlık numaranızı eksik veya hatalı girdiniz"
                            self.showAlert.toggle()
                        }
                        else if self.firstName == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Adınızı lütfen kontrol ediniz"
                            self.showAlert.toggle()
                        }
                        else if self.lastName == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Soyadınızı lütfen kontrol ediniz"
                            self.showAlert.toggle()
                        }
                        else if self.email == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Emailinizi girmediniz. Emailinizi girmeden devam edemeyiz"
                            self.showAlert.toggle()
                        }
                        else if !self.email.contains(".com") {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Geçersiz mail adresi girdiniz. Lütfen mail adresinizi kontrol ediniz"
                            self.showAlert.toggle()
                        }
                        else if self.phoneNumber == "" {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Telefon numaranızı girmediniz. Başında sıfır olmadan girmelisiniz"
                            self.showAlert.toggle()
                        }
                        else if self.phoneNumber.count != 10 {
                            self.alertTitle = "Uyarı"
                            self.alertBody = "Lütfen başında 0 olmadan telefon numaranızı giriniz"
                            self.showAlert.toggle()
                        }
                        else {
                            sendData()
                        }
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Başvur")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.45, height: 45)
                    }

                }
                .padding(.all)
            }
        }
    }
    
    var paymentBody: some View {
        VStack(alignment: .leading, spacing: 20){
            
            VStack{
                Image("taxPaymentImage")
                    .resizable()
                    .scaledToFit()
                
                Text("Neredeyse tamam! Şimdi hemen banka kartını seç ve ödemeniz tamamla. Sana yardımcı olmak için sabırsızlanıyoruz!")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
            
            Text("Ödeme Yapılacak Kart")
                .foregroundColor(.white)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding(.horizontal)
            
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
                    .padding(.horizontal)
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
                .sheet(isPresented: $toListBankCard) {
                    ListBankCard(lastCardCode: selectedBankCode)
                }
            }
            
            Spacer(minLength: 0)
            
            HStack{
                
                Text("150₺")
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
            .frame(height: 50)
            .padding(.horizontal)
            
            
            Button {
                if self.selectedBankCode != "" {
                    pay()
                }
                else {
                    self.alertTitle = "Banka Bilgisi Eksikliği!"
                    self.alertBody = "Sanırım bir banka kartı seçmediniz. Ödemenizin gerçekleşmesi için bir kredi veya banka kartı kullanmalısınız!"
                    self.showAlert.toggle()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                    
                    Text("Ödemeyi Tamamla")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
                .frame(height: 45)
                .padding(.all)
            }

        }
    }
    
    var WaitingBody: some View {
        VStack(spacing: 20){
            
            Spacer()
            
            Image("taxResultImage")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
            
            Text("Tebrikler!")
                .foregroundColor(.white)
                .font(.system(size: 18))
                .fontWeight(.bold)
            
            Text("Talebiniz bize ulaştı!\nEn yakın sürede size dönüş yapacağız. Sizi 0 850 308 7668 numarası üzerinden arayacağız. Ödeme ekranınız temsilcimiz sizden onay aldığı taktirde açılacaktır. Beklemede kalın!")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .lineSpacing(15)
                .padding(.horizontal)
            
            Spacer()
            
        }
    }
    
    var onlinePaymentScreen: some View {
        WebView(text: $htmlCode)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.all)
    }
    
    var resultBody: some View {
        VStack(alignment: .center, spacing: 20){
            
            Spacer(minLength: 0)
            
            if self.listener.result == 1 {
                Image("taxFreePaymentSucces")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                
                Text("Tebikler\nÖdeme Gerçekleşti!")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineSpacing(12)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                            let ref = Firestore.firestore()
                            ref.collection("TaxFreeApplications").document(userStore.taxapplicationId).setData(["progres" : 2], merge: true)
                            playSound(sound: "coin", type: "mp3")
                            haptic(style: .rigid)
                        }
                    }
            }
            else {
                Image("taxFreePaymentFail")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)
                
                Text("Maalesef\nÖdeme Reddedildi!")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineSpacing(12)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                            let ref = Firestore.firestore()
                            ref.collection("TaxFreeApplications").document(userStore.taxapplicationId).setData(["progres" : 1], merge: true)
                        }
                    }
            }
            
            Spacer(minLength: 0)
        }
    }
    
    var willSendMailBody: some View {
        VStack(spacing: 20){
            
            Spacer(minLength: 0)
            
            Image("mailWillSend")
                .resizable()
                .scaledToFit()
                .padding(.all)
            
            Text("Mailinizi kontrol edin!")
                .foregroundColor(.white)
                .font(.system(size: 18))
                .fontWeight(.medium)
            
            Text("Çok yakında sizlere bir mail göndereceğiz. Bu mailin içeriğinde sizler için hazırlanan Vergi Muafiyet Dilekçesi de olacaktır. Türkiye Vergi Dairesi Başkanlığına Gönderdiğimiz belge de çok yakında onaylanacaktır.")
                .foregroundColor(.white)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            Button {
                toMaker.toggle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                    
                    Text("Banka Hesabı Ekle")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                }
                .frame(height: 45)
                .padding(.horizontal, 30)
            }

            
            Spacer(minLength: 0)
        }
    }
    
    func sendData(){
        let ref = Firestore.firestore()
        
        let timeStamp = Date().timeIntervalSince1970
        
        let data = [
            "tcNo" : tcNo,
            "firstName" : firstName,
            "lastName" : lastName,
            "email" : email,
            "phoneNumber" : phoneNumber,
            "timeStamp" : Int(timeStamp),
            "userID" : Auth.auth().currentUser!.uid,
            "profileImage" : userStore.pfImage,
            "progres" : 0
        ] as [String : Any]
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["taxApplicationId" : "\(Int(timeStamp))"], merge: true)
        
        ref.collection("TaxFreeApplications").document("\(Int(timeStamp))").setData(data, merge: true)
        
        self.successAlert = true
    }
    
    func getData(id: String){
        let ref = Firestore.firestore()
        ref.collection("TaxFreeApplications").document(id).addSnapshotListener { doc, err in
            if err == nil {
                if let progres = doc?.get("progres") as? Int {
                    self.progres = progres
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
        let merchant_oid = "TaxFreeApplications\(randomNumber)complate"
        let email = "\(self.userStore.email)"
        let payment_amount = "150.00"
        let payment_type = "card"
        let installment_count = 0
        let merchant_ok_url = onlinePaymentSystem.merchant_ok_url
        let merchant_fail_url = onlinePaymentSystem.merchant_fail_url
        let user_name = "\(self.userStore.firstName) \(self.userStore.lastName)"
            let user_phone = "\(self.userStore.phoneNumber)"
        let user_address = "\(self.userStore.adress)"
        let basket = [["Başvuru İşlemi", "150.00", "1"]]
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
                self.showWebView.toggle()
                
                let ref = Firestore.firestore()
                ref.collection("OnlineOrder").document(merchant_oid).setData(["result" : 0], merge: true)
                
                self.merchantoid = merchant_oid
                
                print("REsss \(merchant_oid)")
                
                self.listener.listen(merchant_oid: merchant_oid)
                
                self.merchantoid = merchant_oid
                
            }.resume()
        }
    }

}
