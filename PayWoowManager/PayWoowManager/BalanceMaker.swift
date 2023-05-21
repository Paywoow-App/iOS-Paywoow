//
//  BalanceMaker.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 11/1/22.
//

import SwiftUI
import FirebaseFirestore

struct BalanceMaker: View {
    @AppStorage("storeNick") var storeNick : String = "None"
    @AppStorage("storeSelectedApp") var storeSelectedApp : String = "None"
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @State private var ref = Firestore.firestore()
    @State private var dollar : Double = 0
    @State private var boughtPrice : Int = 0
    @State private var sellPrice : Int = 0
    @State private var balance : Int = 0
    @State private var productType : String = ""
    @State private var platformName : String = ""
    
    //Inputs
    @State private var inputPrice : String = "100000"
    @State private var inputDollar : String = ""
    @State private var inputBoughtPrice : String = ""
    @State private var inputSellPrice : String = ""
    
    //Calculates
    @State private var productResultViaProfit : Int = 0
    @State private var productResultWithOutProfit : Int = 0
    @State private var productResultDiamondProfit : Int = 0
    @State private var averageSalary : Int = 0

    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
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
                    
                    Text("Bakiye Güncelle")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                }
                .padding(.all)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12){
                        Text("Uyarı : Sadece sipariş geçtiğinizde bu işlemi kulanınız. Belli bir istatistik tutulduğu için mümkün olduğunca sanal ürününüz (Örneğin elmasınız) azaldığında kullanınınz. Siz sadece ne kadarlık sipariş geçtiğinizi girin. Geri kalan işlemleri biz devam ettireceğiz.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Text("₺")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                TextField("Sipariş Tutarı", text: $inputPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }.padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Text("$")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                TextField("Satış Kuru", text: $inputDollar)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                            }.padding(.horizontal)
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        Text("Sadece satış kuru değişti ise buradan değiştirin. Dolar kurunu değiştirmeniz taktirinde, bundan sonra ki bütün satışlar, girdiğiniz satış kuru üzerinden sağlanacaktır.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Alış", text: $inputBoughtPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                            }
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))
                                
                                TextField("Satış", text: $inputSellPrice)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                            }
                            
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        HStack{
                            Text("\(productType) miktarı (Kâr ile) :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                                
                            
                            Image(productType)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Text("\(productResultViaProfit)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            Text("\(productType) miktarı (Kârsız) :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                                
                            
                            Image(productType)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Text("\(productResultWithOutProfit)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            Text("\(productType) Kârı :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                                
                            
                            Image(productType)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            
                            Text("\(productResultDiamondProfit)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            Text("Tahmini Kazancın :")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)

                            
                            Text("₺ \(averageSalary)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                
                        }
                        .padding(.horizontal)
                        
                        Button {
                            updateBalance()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Bakiye Güncelle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                            .frame(height: 45)
                            .padding(.horizontal)
                        }

                    }
                }
            }
        }
        .onAppear{
            if self.storeNick.count > 4 {
                getData()
            }
        }
    }
    
    func updateBalance(){
        let ref = Firestore.firestore()
        let data = [
            "balance" : 0,
            "dollar" : Double(inputDollar)!,
            "boughtPrice" : Int(inputBoughtPrice)!,
            "sellPrice" : Int(inputSellPrice)!,
            "productTotal" : productResultViaProfit
        ] as [String : Any]
        ref.collection("Bayii").document(storeNick).collection("Apps").document(storeSelectedApp).setData(data, merge: true)
        self.present.wrappedValue.dismiss()
    }
    
    func calculateData(){
        let step1 = (Double(inputPrice) ?? 1) / (Double(inputDollar) ?? 1)
        let step2 = step1 * Double(inputBoughtPrice)!
        self.productResultViaProfit = Int(step2)
        let step3 = step1 * Double(inputSellPrice)!
        self.productResultWithOutProfit = Int(step3)
        let step4 = step2 - step3
        self.productResultDiamondProfit = Int(step4)
        let step5 = step4 / Double(inputBoughtPrice)!
        let step6 = step5 * Double(inputDollar)!
        self.averageSalary = Int(step6)
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Bayii").document(storeNick).collection("Apps").document(storeSelectedApp).addSnapshotListener { doc, err in
            if let dollar = doc?.get("dollar") as? Double {
                if let boughtPrice = doc?.get("boughtPrice") as? Int {
                    if let sellPrice = doc?.get("sellPrice") as? Int {
                        if let balance = doc?.get("balance") as? Int {
                            if let productType = doc?.get("productType") as? String {
                                if let platformName = doc?.get("platformName") as? String {
                                    self.dollar = dollar
                                    self.inputDollar = "\(dollar)"
                                    self.boughtPrice = boughtPrice
                                    self.inputBoughtPrice = "\(boughtPrice)"
                                    self.sellPrice = sellPrice
                                    self.inputSellPrice = "\(sellPrice)"
                                    self.balance = balance
                                    self.productType = productType
                                    self.platformName = platformName
                                    calculateData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
