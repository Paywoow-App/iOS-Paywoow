//
//  RemittenceMaker.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/31/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct RemittenceBankIbanModel: Identifiable {
    var id = UUID()
    var bankName : String
    var coverImage : String
    var copiedCount : Int
    var iban : String
    var paytrTitle : String
}

struct RemittenceMaker: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var onlinePaymentSystem = OnlinePaymentSystem()
    @State private var responseCall = [RemittenceResponseModel]()
    @State private var list : [RemittenceBankIbanModel] = []
    @State private var ref = Firestore.firestore()
    @State private var selectedBank : String = ""
    @State private var selectedIban : String = ""
    @State private var bodySelection : Int = 0


    //Payment
    @State private var bankTitle: String = ""
    @State private var tcLast6Number : String = ""
    @State private var remittenceSelection : String = "havale"
    @State private var price : String = "100"
    @State private var fullName : String = ""
    @State private var htmlCode : String = ""

    //Alert
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if bodySelection == 0 {
                bankListBody
            }
            else if bodySelection == 1 {
                detailsBody
            }
            else if bodySelection == 2 {
                payment
            }
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
        .onChange(of: responseCall, perform: { val in
            for doc in responseCall {
                self.htmlCode = """
<html></body><script src="https://www.paytr.com/js/iframeResizer.min.js"></script><iframe src="https://www.paytr.com/odeme/api/\(doc.token)" id="paytriframe" frameborder="0" scrolling="no" style="width:100%"></iframe><script>iFrameResize({},'#paytriframe');</script></body></html>
"""
            }
        })
        .onAppear{
            
            ref.collection("BankIBANs").addSnapshotListener { snap, err in
                if err == nil {
                    self.list.removeAll()
                    for doc in snap!.documents{
                        if let bankName = doc.get("bankName") as? String {
                            if let coverImage = doc.get("coverImage") as? String {
                                if let copiedCount = doc.get("copiedCount") as? Int {
                                    if let iban = doc.get("iban") as? String {
                                        if let paytrTitle = doc.get("paytrTitle") as? String {
                                            let data = RemittenceBankIbanModel(bankName: bankName, coverImage: coverImage, copiedCount: copiedCount, iban: iban, paytrTitle: paytrTitle)
                                            self.list.append(data)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: userStore.firstName) { newValue in
            self.fullName = "\(userStore.firstName) \(userStore.lastName)"
            var last6 = userStore.tcNo
            if last6.count == 11 {
                last6.remove(at: last6.startIndex)
                last6.remove(at: last6.startIndex)
                last6.remove(at: last6.startIndex)
                last6.remove(at: last6.startIndex)
                last6.remove(at: last6.startIndex)
                self.tcLast6Number = last6
            }
            
            
        }
    }
    
    var bankListBody: some View {
        VStack{
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
                    .frame(width: 45, height: 45)
                }
                
                Text("Bakiye Yükle")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(list){ item in
                    VStack{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            if self.selectedBank == item.bankName {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.init(hex: "#00D8FF"))
                                    .padding(1)
                            }
                            
                            HStack(spacing: 10){
                                WebImage(url: URL(string: item.coverImage))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 10){
                                    Text(item.bankName)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Text(item.iban)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                }
                                
                                Spacer(minLength: 0)
                                
                                Button {
                                    UIPasteboard.general.string = "\(item.iban)"
                                    self.alertTitle = "IBAN Kopyalandı!"
                                    self.alertBody = "\(item.bankName) üzerinden Havale / EFT yaptıktan sonra buradan 'Devam Et' diyerek ödeme bildiriminde bulunabilirsiniz."
                                    self.showAlert.toggle()
                                    self.selectedBank = item.bankName
                                    self.bankTitle = item.paytrTitle
                                    self.selectedIban = item.iban
                                } label: {
                                    if self.selectedBank == item.bankName {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                    else {
                                        Image(systemName: "doc.on.doc")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                }
                            }
                            .padding(10)
                        }
                        .frame(height: 80)
                        .padding(.horizontal)
                        .onTapGesture {
                            UIPasteboard.general.string = "\(item.iban)"
                            self.alertTitle = "IBAN Kopyalandı!"
                            self.alertBody = "\(item.bankName) üzerinden Havale / EFT yaptıktan sonra buradan 'Devam Et' diyerek ödeme bildiriminde bulunabilirsiniz."
                            self.showAlert.toggle()
                            self.selectedBank = item.bankName
                            self.bankTitle = item.paytrTitle
                            self.selectedIban = item.iban
                        }
                    }
                }
            }
            
            if selectedBank != "" {
                HStack{
                    Button {
                        self.selectedBank = ""
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white)
                            
                            Text("İptal")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Button {
                        bodySelection = 1
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                            
                            Text("Devam Et")
                                .foregroundColor(.black)
                                .font(.system(size: 15))
                        }
                    }
                    
                }
                .frame(height: 45)
                .padding([.horizontal, .bottom])
            }
        }
    }
    
    var detailsBody: some View {
        VStack{
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
                    .frame(width: 45, height: 45)
                }
                
                Text("Ödeme Bilgilerin")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                        
                        Text("Bankanızdan veya bankanızın mobil uygulaması üzerinden para gönderme işlemini tamamladıktan sonra, buradan ödemenizi bildirmelisiniz. Bilgilerinizin doğruluğundan emin olunuz.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            TextField("Ad ve Soyadınız", text: $fullName)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack(spacing: 0){
                                
                                Text("*****")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .keyboardType(.numbersAndPunctuation)
                                
                                
                                TextField("TC Kimlik Son 6 Hanesi", text: $tcLast6Number)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .disabled(true)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            self.tcLast6Number = String(userStore.tcNo.suffix(6))
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                        
                            HStack{
                                TextField("Gönderilen Tutar", text: $price)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .keyboardType(.numbersAndPunctuation)
                                
                                Text("Türk Lirası")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        Text("İşlem tutarı seçiniz")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .padding(.leading)
                    
                    HStack{
                        Button {
                            self.remittenceSelection = "havale"
                        } label: {
                            if self.remittenceSelection == "havale" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("Havale")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    Text("Havale")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                        
                        Button {
                            self.remittenceSelection = "eft"
                        } label: {
                            if self.remittenceSelection == "eft" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                    
                                    Text("EFT")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.black.opacity(0.2))
                                    
                                    Text("EFT")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }

                    }
                    .frame(height: 45)
                    .padding(.horizontal)
                    
                }
            }
            
            Button {
                if self.fullName == "" {
                    self.alertTitle = "Eksik Alan"
                    self.alertBody = "Ad soyad bilgisini doldurmadınız"
                    self.showAlert.toggle()
                }
                else if self.tcLast6Number.count != 6 {
                    self.alertTitle = "TC Son 6 Hanesi Girinizdollarsign"
                    self.alertBody = "Kişisel bilgilerinizden T.C kimlik alanı doldurmanız gerekiyor."
                    self.showAlert.toggle()
                }
                else if self.price == "" {
                    self.alertTitle = "Eksik Alan"
                    self.alertBody = "Para transferi sağladığınız tutarı giriniz."
                    self.showAlert.toggle()
                }
                else {
                    self.bodySelection = 2
                    self.sendRequest()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                    
                    Text("Ödemeyi Bildir")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
            }
            .frame(height: 45)
            .padding(.all)

            
        }
    }
        
    var payment: some View {
        VStack{
            WebView(text: $htmlCode)
            
            Button {
                self.present.wrappedValue.dismiss()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white)
                    
                    Text("Kapat")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                .frame(height: 45)
                .padding([.horizontal, .bottom])
            }

        }
    }
    
    func sendRequest(){
        
        let random = Int.random(in: 10000 ... 99999)
        print("random \(random)")
        let merchant_id = onlinePaymentSystem.merchant_id
        let merchant_key = onlinePaymentSystem.merchant_key
        let merchant_salt = onlinePaymentSystem.merchant_salt
        
        let user_ip = "176.88.30.171"
        let merchant_oid = "HavaleIslemiTest\(random)"
        let email = "\(userStore.email)"
        let payment_amount = 100
        let payment_type = "eft"
        let test_mode = 1
        let user_name = "\(userStore.firstName) \(userStore.lastName)"
        let user_phone = "0\(userStore.phoneNumber)"
        let tc_no_last5 = "\(tcLast6Number)"
        let bank = "\(bankTitle)"
        let debug_on = 0
        let timeout_limit = 100
        
        print("testhavale merchant_id: \(merchant_id)")
        print("testhavale merchant_key: \(merchant_key)")
        print("testhavale merchant_salt: \(merchant_salt)")
        print("testhavale user_ip: \(user_ip)")
        print("testhavale merchant_oid: \(merchant_oid)")
        print("testhavale email: \(email)")
        print("testhavale payment_amount: \(payment_amount)")
        print("testhavale payment_type: \(payment_type)")
        print("testhavale test_mode: \(test_mode)")
        print("testhavale user_name: \(user_name)")
        print("testhavale user_phone: \(user_phone)")
        print("testhavale tc_no_last5: \(tc_no_last5)")
        print("testhavale bank: \(bank)")
        print("testhavale debug_on: \(debug_on)")
        print("testhavale timeout_limit: \(timeout_limit)")
        
        let hash_str = "\(merchant_id)\(user_ip)\(merchant_oid)\(email)\(payment_amount)\(payment_type)\(test_mode)"
        let paytr_token = "\(hash_str)\(merchant_salt)".hmac(algorithm: .SHA256, key: merchant_key)
        
        print("testhavale paytrToken = \(paytr_token)")
        print("testhavale hashstr = \(hash_str)")
        
        
        guard let url = URL(string: "https://www.paytr.com/odeme/api/get-token") else { return }
        
        let paramaters = "&merchant_id=\(merchant_id)&user_ip=\(user_ip)&merchant_oid=\(merchant_oid)&email=\(email)&payment_amount=\(payment_amount)&payment_type=\(payment_type)&paytr_token=\(paytr_token)&user_name=\(user_name)&user_phone=\(user_phone)&tc_no_last5=\(tc_no_last5)&bank=\(bank)&debug_on=\(debug_on)&timeout_limit=\(timeout_limit)&test_mode=\(test_mode)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramaters.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:  "Content-Type")
        
        URLSession.shared.dataTask(with: request) { dat, res, err in
            let data = dat?.base64EncodedString()
            let base64Encoded = data
            let decodedData = Data(base64Encoded: base64Encoded!)
            let decodedString = String(data: decodedData!, encoding: .utf8)!
            let jsonDecode =  try? JSONDecoder().decode(RemittenceResponseModel.self, from: decodedData!)
            print("I MA SOFWTASDASW\ndat \(dat)\ndata \(data)\nbase64Encoded \(base64Encoded)\ndecodedString \(decodedString)\njsonDecode \(jsonDecode)")
            
            self.responseCall.append(jsonDecode!)
            
            ref.collection("OnlineOrder").document(merchant_oid).setData(["result" : 0])
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["remittenceLimit" : true], merge: true)
            let timeStamp = Date().timeIntervalSince1970
            let remittenceHistoryData = [
                "bank" : selectedBank,
                "iban" : selectedIban,
                "timeStamp" : Int(timeStamp),
                "price" : Int(price),
                "result" : 0,
                "isUploadedPrice" : false,
                "isDeclinedPrice" : false
            ] as [String : Any]
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("RemittenceHistory").document(merchant_oid).setData(remittenceHistoryData)
        }.resume()
    }
    
}

struct RemittenceResponseModel: Codable, Hashable {
    var status: String
    var token: String
}
