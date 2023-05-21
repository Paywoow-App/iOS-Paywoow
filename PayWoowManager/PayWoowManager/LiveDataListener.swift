//
//  LiveDataListener.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/21/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct LiveDataListener: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
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
                    
                    Text("Canlı Veri Akışı")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal, .top])
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LiveDataPayTR()
                    
                    LiveDataNetGSM()
                }
            }
        }
    }
}

struct LiveDataPayTR: View {
    @State private var salePCS : Int = 1
    @State private var totalSold : Int = 0
    @State private var commission : Double = 0
    @State private var netPrice : Int = 0
    @State private var commissionPrice : Int = 0
    
    @State private var showDetails : Bool = false
    var body: some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                Image("paytr")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 66)
                    .clipped()
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("PayTR")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("Sanal Pos Servisi")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showDetails.toggle()
                } label: {
                    if showDetails {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                
            }
            
            if showDetails {
                HStack{
                    Text("Satış Adeti :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(salePCS) adet")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Toplam Satış :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(totalSold) ₺")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Net Satış :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(netPrice) ₺")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Gider :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(commissionPrice) ₺")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Komisyon Oranı :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("%\(String(format: "%.2f", commission))")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    
                }
            }
            
        }
        .padding(.all)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear{
            getData()
        }
    }
    
    func netPriceCalculater(){
        let step1 = Double(totalSold) / 100
        let step2 = step1 * commission
        self.commissionPrice = Int(step2)
        let step3 = totalSold - Int(step2)
        self.netPrice = step3
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Services").document("PayTR").addSnapshotListener { doc, err in
            if err == nil {
                if let totalSold = doc?.get("totalSold") as? Int {
                    if let salePCS = doc?.get("salePCS") as? Int {
                        if let commission = doc?.get("commission") as? Double {
                            self.totalSold = totalSold
                            self.salePCS = salePCS
                            self.commission = commission
                            netPriceCalculater()
                        }
                    }
                }
            }
        }
    }
}

struct LiveDataNetGSM: View {
    @State private var usedCodeCount : Int = 223
    @State private var boughtPrice : Int = 0
    @State private var pcsPrice : Double = 0.06198
    @State private var readyUseCount : Int = 0
    @State private var credit : String = ""
    @State private var showDetails : Bool = true
    var body : some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                Image("netgsm2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 66)
                    .clipped()
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("NetGSM")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text("OTP SMS Servisi")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showDetails.toggle()
                } label: {
                    if showDetails {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                
            }
            
            if showDetails {
                HStack{
                    Text("Kullanım Adeti :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(usedCodeCount) Adet")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Gider : ")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(boughtPrice)₺")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                HStack{
                    Text("Kalan OTP SMS :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(readyUseCount) adet")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                HStack{
                    Text("İşlem Başı Ücret :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(String(format: "%.2f", pcsPrice)) krş")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Bakiye :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(String(credit.dropLast().dropLast()))₺")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
        }
        .padding(.all)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear{
            calculate()
            creditRequest(usercode: "08503087668", password: "K5-379ER")
            lastOTPCount(usercode: "08503087668", password: "K5-379ER")
        }
    }
    
    func calculate(){
        let step1 = pcsPrice * Double(usedCodeCount)
        self.boughtPrice = Int(step1)
    }
    
    func creditRequest(usercode: String, password: String){
        guard let url = URL(string: "https://api.netgsm.com.tr/balance/list/xml") else {return}
        let xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><stip>2</stip></header></mainbody>"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = xml.data(using: .utf8)
        request.setValue("text/xml", forHTTPHeaderField:  "Content-Type")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { dat, res, err in
            print(String(data: dat!, encoding: .utf8)!)
            
            if err == nil, let data = dat, let response = res as? HTTPURLResponse {
//                print("statusCode: \(response.statusCode)")
//                print(String(data: data, encoding: .utf8) ?? "")
                self.credit = "\(String(data: data, encoding: .utf8)!)₺"
            } else {
                print("Status code 404")
            }
            
        }.resume()
    }
    
    
    func lastOTPCount(usercode: String, password: String){
        guard let url = URL(string: "https://api.netgsm.com.tr/balance/list/xml") else {return}
        let xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><stip>1</stip></header></mainbody>"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = xml.data(using: .utf8)
        request.setValue("text/xml", forHTTPHeaderField:  "Content-Type")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { dat, res, err in
            print(String(data: dat!, encoding: .utf8)!)
            
            if err == nil, let data = dat, let response = res as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                
                let string = "\(String(data: data, encoding: .utf8))"
                let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
                for item in stringArray {
                    if let number = Int(item) {
                        print("number: \(number)")
                        self.readyUseCount = number
                    }
                }
            } else {
                print("Status code 404")
            }
            
        }.resume()
    }
}
