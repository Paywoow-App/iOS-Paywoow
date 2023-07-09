//
//  PaymentSalary.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 1/6/22
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Lottie

struct PaymentSalary: View {
    @Environment(\.openURL) var openURL
    @State private var toTaxFreeApplications : Bool = false
    @State private var progres : Int = 0
    @StateObject var userStore = UserInfoStore()
    @StateObject var salaryStore = SalaryStore()
    @StateObject var general = GeneralStore()
    @StateObject var salaryDetails = StreamerSalaryInfoStore()
    
    @State private var selectedSalary : String = ""
    @State private var selectedYear : String = ""
    @State private var selectedProgress : Int = 0
    @State private var toEditBankAccount : Bool = false

    var body: some View {
        ZStack{
            
            VStack{
                
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("My Salary")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                        Button {
                            self.toEditBankAccount.toggle()
                        } label: {
                            Image(systemName: "rectangle.badge.plus")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                }.padding([.top, .horizontal])
                    salaryBody
                
                
            }
        }
        .fullScreenCover(isPresented: $toTaxFreeApplications) {
            TaxFreeApplication(successAlert: .constant(false))
        }
        .onChange(of: userStore.taxapplicationId) { val in
            if val != "" {
                getData()
            }
            
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            self.selectedYear = formatter.string(from: date)
        }
        .fullScreenCover(isPresented: $toEditBankAccount) {
            SalaryBankCreater()
        }
    }

    
    var salaryBody : some View {
        VStack{
//            HStack{
//                Button {
//                    selectedProgress = 0
//                } label: {
//                    if self.selectedProgress == 0{
//                        Text("Beklemede")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18))
//                            .fontWeight(.medium)
//                    }
//                    else {
//                        Text("Beklemede")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 18))
//                    }
//                }
//
//                Button {
//                    selectedProgress = 1
//                } label: {
//                    if self.selectedProgress == 1 {
//                        Text("Tamamlandı")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18))
//                            .fontWeight(.medium)
//                    }
//                    else {
//                        Text("Tamamlandı")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 18))
//                    }
//                }
//
//
//                Button {
//                    selectedProgress = 2
//                } label: {
//                    if self.selectedProgress == 2{
//                        Text("Reddedildi")
//                            .foregroundColor(.white)
//                            .font(.system(size: 18))
//                            .fontWeight(.medium)
//                    }
//                    else {
//                        Text("Reddedildi")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 18))
//                    }
//                }
//
//                Spacer(minLength: 0)
//
//            }
//            .padding(.horizontal)
                        
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    ForEach(salaryStore.list) { item in
                        if item.progress == 0 {
                            Text("Beklemede")
                                .padding(.leading)
                            rectangleWhiteRaw(overlayRectangleText: "Maaşınız 3-7 iş günü içerisinde hesabına yatılacaktır.", price: item.price, conditionText: "Beklemede", conditionTextColor: .black.opacity(0.6), conditionTextRectangle: .gray.opacity(0.3), day: item.day, month: item.month, year: item.year)
                        }
                    }
                }
                
                
                
                
//                ForEach(salaryStore.list){ item in
//                    if self.selectedProgress == item.progress{
//                        SalaryContent(userID: item.userID, bankName: item.bankName, IBAN: item.IBAN, timeStamp: item.timeStamp, month: item.month, year: item.year, day: item.day, progress: item.progress, price: item.price, currency: item.currency)
//                    }
//                }
            }
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("TaxFreeApplications").document(userStore.taxapplicationId).addSnapshotListener { doc, err in
            if err == nil {
                if let progres = doc?.get("progres") as? Int {
                    self.progres = progres
                }
            }
        }
    }
}

struct rectangleWhiteRaw: View {
    
    var overlayRectangleText: String
    var price: Int
    var conditionText: String
    var conditionTextColor: Color
    var conditionTextRectangle: Color
    var day: String
    var month: String
    var year: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .overlay {
                    HStack {
                        VStack(spacing: 10){
                            Text(overlayRectangleText)
                                .foregroundColor(.black)
                                .fontWeight(.regular)
                                .font(.caption2)
                                .multilineTextAlignment(.leading)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(conditionTextRectangle)
                                .overlay {
                                    Text(conditionText)
                                        .foregroundColor(conditionTextColor)
                                        .font(.caption)
                                        .fontWeight(.regular)
                                }
                                .frame(height: 20)
                                .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                        
                        VStack(spacing: 5) {
                            Text("\(day).\(month).\(year)")
                                .font(.caption)
                                .foregroundColor(.black)
                                .fontWeight(.light)
                            
                            Text("\(price)$")
                                .foregroundColor(.black)
                                .fontWeight(.black)
                                .font(.title3)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.3)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 90, alignment: .center)
        }
        .padding(.horizontal)
    }
    
}

struct SalaryContent : View {
    @State var userID : String
    @State var bankName : String
    @State var IBAN : String
    @State var timeStamp : Int
    @State var month : String
    @State var year : String
    @State var day : String
    @State var progress : Int //0.1.2
    @State var price : Int
    @State var currency : String
    
    @State private var showAll : Bool = false
    @State private var timeDate : String = ""
    
    var body : some View {
        VStack(spacing: 15){
            HStack{
                Text("\(month) Ayı Maaşı")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Text("\(currency) \(price)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
            }
            
            
            if showAll {
                HStack{
                    Text("Banka :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(bankName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("IBAN :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(IBAN)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Gönderim Tarihi :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(timeDate)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                if self.progress == 0 {
                    Text("Size ait olduğunu teyit ettiğiniz bu hesap bilgilerinizi ulaşarak, maaşınızın size ulaştığını teyit ediniz")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("StreammerSalaries").document("\(timeStamp)").setData(["progress" : 2], merge: true)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Bana Ulaşmadı")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("StreammerSalaries").document("\(timeStamp)").setData(["progress" : 1], merge: true)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Ödemeyi Aldım")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }

                    }
                    .frame(height: 40)
                    
                }
                else if self.progress == 1 {
                    Text("Belitirlen hesabınıza \(currency) \(price) değerindeki maaşınız aktarılmıştır!")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                }
                else if self.progress == 2 {
                    Text("Tarafımıza iletildi! Kontrol edildikten sonra sizinle bilgi paylaşacağız")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                }
                
            }
        }
        .padding(.all, 15)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onTapGesture {
            self.showAll.toggle()
        }
        .onAppear{
            let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            formatter.dateFormat = "dd MMMM yyyy"
            self.timeDate = formatter.string(from: date)
        }
    }
}
