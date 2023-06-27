//
//  SalaryBankCreater.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 12/4/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SalaryBankCreater: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @State private var bankList : [RemittenceBankIbanModel] = []
    @State private var selectedBank : String = ""
    @State private var fullName : String = ""
    @State private var iban : String = ""
    @State private var newIbanNo: String = ""

    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 15){
                HStack(spacing: 12){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Maaş Banka Bilgileriniz")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding(.all)
                
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(bankList) { item in
                                Button {
                                    self.selectedBank = item.bankName
                                } label: {
                                    if self.selectedBank == item.bankName {
                                        VStack{
                                            AsyncImage(url: URL(string: item.coverImage)) { img in
                                                img
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 58, height: 58)
                                                    .clipped()
                                                    .cornerRadius(5)
                                            } placeholder: {
                                                ZStack{
                                                    Rectangle()
                                                        .fill(Color.black.opacity(0.5))
                                                        .frame(width: 58, height: 58)
                                                        .cornerRadius(5)
                                                    
                                                    ProgressView()
                                                        .colorScheme(.dark)
                                                        .scaleEffect(1.5)
                                                    
                                                }    .frame(width: 58, height: 58)
                                            }
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.white)
                                                .frame(width: 30, height: 2)
                                        }

                                    }
                                    else {
                                        AsyncImage(url: URL(string: item.coverImage)) { img in
                                            img
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 58, height: 58)
                                                .clipped()
                                                .cornerRadius(5)
                                                .opacity(0.5)
                                        } placeholder: {
                                            ZStack{
                                                Rectangle()
                                                    .fill(Color.black.opacity(0.5))
                                                    .frame(width: 58, height: 58)
                                                    .cornerRadius(5)
                                                
                                                ProgressView()
                                                    .colorScheme(.dark)
                                                    .scaleEffect(1.5)
                                                
                                            }    .frame(width: 58, height: 58)
                                        }
                                    }
                                }

                            }
                        }
                    }
                    .frame(height: 75)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                        
                        TextField("Hesap Sahibinin Tam Adı", text: $fullName)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                            .colorScheme(.dark)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))

                        HStack{
                            TextField("Yatırılacak IBAN", text: $iban.limit(24))
                                .foregroundColor(.clear)
                                .font(.system(size: 15))
                                .colorScheme(.dark)
                                .keyboardType(.numbersAndPunctuation)
                                .onChange(of: iban) { iban in
                                    self.newIbanNo = splitAndJoin(iban, by: 4, separator: " ")
                                }
                                .overlay {
                                    HStack(spacing: 10) {
                                        Text(newIbanNo)
                                        Spacer()
                                    }
                                }
                            
                            Button {
                                self.iban = UIPasteboard.general.string ?? ""
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }

                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    
                    Text("Bu banka bilgilerinizin güncelliği ve doğrulu önemlidir. Maaşınız bundan sonra buradan sizlere gönderilecektir.")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                
                Spacer(minLength: 0)
                    
                    HStack(spacing: 15){
                        Button {
                            self.present.wrappedValue.dismiss()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                
                                Text("İptal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                        
                        
                        Button {
                            if self.selectedBank == "" {
                                self.alertTitle = "Geçersiz Bilgi"
                                self.alertBody = "Bankanızı Seçiniz!"
                                self.showAlert.toggle()
                            }
                            else if self.fullName == "" {
                                self.alertTitle = "Geçersiz Bilgi"
                                self.alertBody = "Hesap sahibinin edını eirdiğinizden emin olun!"
                                self.showAlert.toggle()
                            }
                            else if iban.count != 24 {
                                self.alertTitle = "Geçersiz Bilgi"
                                self.alertBody = "IBAN Bilgisi 24 karakertden oluşmalıdır"
                                self.showAlert.toggle()
                            }
                            else {
                                saveData()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Kaydet")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .frame(height: 50)
                    .padding(.all)
                    .ignoresSafeArea(.keyboard)
                    
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear{
            getCurrentBankAccount()
            
            let ref = Firestore.firestore()
            ref.collection("BankIBANs").addSnapshotListener { snap, err in
                if err == nil {
                    self.bankList.removeAll()
                    for doc in snap!.documents{
                        if let bankName = doc.get("bankName") as? String {
                            if let coverImage = doc.get("coverImage") as? String {
                                if let copiedCount = doc.get("copiedCount") as? Int {
                                    if let iban = doc.get("iban") as? String {
                                        if let paytrTitle = doc.get("paytrTitle") as? String {
                                            let data = RemittenceBankIbanModel(bankName: bankName, coverImage: coverImage, copiedCount: copiedCount, iban: iban, paytrTitle: paytrTitle)
                                            self.bankList.append(data)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SalaryBankDetails").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
                if err == nil {
                    if let bankName = doc?.get("bankName") as? String {
                        if let fullName = doc?.get("fullName") as? String {
                            if let iban = doc?.get("iban") as? String {
                                self.selectedBank = bankName
                                self.fullName = fullName
                                self.iban = iban
                            }
                        }
                    }
                }
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")))
        }
    }
    //TODO: Collection problems
    func saveData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("BankInformations").document(Auth.auth().currentUser!.uid).setData([
            "bankName" : selectedBank,
            "iban" : iban,
            "fullName" : fullName,
            "listener" : userStore
        ], merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["isComplatedTax" : true], merge: true)
        
        self.present.wrappedValue.dismiss()
    }
    
    func getCurrentBankAccount(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("SalaryBankDetails").document(Auth.auth().currentUser!.uid).addSnapshotListener { doc, err in
            if err == nil {
                if let fullname = doc?.get("fullname") as? String {
                    if let iban = doc?.get("iban") as? String {
                        if let bankName = doc?.get("bankName") as? String {
                            self.fullName = fullname
                            self.selectedBank = bankName
                            self.iban = iban
                        }
                    }
                }
            }
        }
    }
}
