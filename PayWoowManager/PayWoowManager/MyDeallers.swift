//
//  MyDeallers.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/31/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyDeallersModel: Identifiable {
    var id = UUID()
    var platformName : String
    var platformImage : String
    var platformDocID : String
    var productTotal : Int
    var dollar : Double
    var maxLimit : Int
    var boughtPrice : Int
    var sellPrice : Int
    var balance : Int
    var productType : String
    var isActive : Bool
}

struct MyDeallers: View {
    @AppStorage("storeNick") var storeNick : String = ""
    //Stories
    @StateObject var general = GeneralStore()
    @StateObject var store = AppsStore()
    @StateObject var bayiStore = DeallerStore()
    @Environment(\.presentationMode) var present
    @State var selectedDeallerID : String
    @State private var toDeallerMaker : Bool = false
    
    var body: some View {
        ZStack{
            
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            mainBody
        }
    }
    
    var mainBody: some View {
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
                            .font(.system(size: 18))
                    }
                    .frame(width: 45, height: 45)
                }
                
                Text("Bayiliklerim")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)
                
                Button {
                    self.toDeallerMaker.toggle()
                } label: {
                    Text("Ekle")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(store.appsList) { item in
                    MyDeallerContent(selectedDocID: $selectedDeallerID, platformName: item.platformName, platformImage: item.platformImage, platformDocID: item.platformDocID, productTotal: item.productTotal, dollar: item.dollar, maxLimit: item.maxLimit, boughtPrice: item.boughtPrice, sellPrice: item.sellPrice, balance: item.balance, productType: item.productType, isActive: item.isActive)
                }
            }
        }
        .fullScreenCover(isPresented: $toDeallerMaker) {
            if #available(iOS 16.0, *) {
                DeallerMaker()
            }
        }
    }
}

class AppsStore: ObservableObject {
    @Published var appsList : [MyDeallersModel] = []
    @AppStorage("storeNick") var storeNick : String = ""
    let ref = Firestore.firestore()
    init(){
            ref.collection("Bayii").document(storeNick).collection("Apps").addSnapshotListener { snap, err in
                if err == nil {
                    self.appsList.removeAll()
                    for doc in snap!.documents {
                        if let platformName = doc.get("platformName") as? String {
                            if let platformImage = doc.get("platformImage") as? String {
                                if let productTotal = doc.get("productTotal") as? Int {
                                    if let dollar = doc.get("dollar") as? Double {
                                        if let maxLimit = doc.get("maxLimit") as? Int {
                                            if let boughtPrice = doc.get("boughtPrice") as? Int {
                                                if let sellPrice = doc.get("sellPrice") as? Int {
                                                    if let balance = doc.get("balance") as? Int {
                                                        if let productType = doc.get("productType") as? String {
                                                            if let isActive = doc.get("isActive") as? Bool {
                                                                let data = MyDeallersModel(platformName: platformName, platformImage: platformImage, platformDocID: doc.documentID, productTotal: productTotal, dollar: dollar, maxLimit: maxLimit, boughtPrice: boughtPrice, sellPrice: sellPrice, balance: balance, productType: productType, isActive: isActive)
                                                                self.appsList.append(data)
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

struct MyDeallerContent: View {
    @AppStorage("storeNick") var storeNick : String = ""
    @Environment(\.presentationMode) var present
    @Binding var selectedDocID : String
    @State var platformName : String
    @State var platformImage : String
    @State var platformDocID : String
    @State var productTotal : Int
    @State var dollar : Double
    @State var maxLimit : Int
    @State var boughtPrice : Int
    @State var sellPrice : Int
    @State var balance : Int
    @State var productType : String
    @State var isActive : Bool
    
    @State private var showDetails : Bool = false
    var body : some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                WebImage(url: URL(string: platformImage))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
                
                VStack(alignment: .leading){
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    if self.selectedDocID == platformDocID {
                        Text("Aktif")
                            .foregroundColor(.green)
                            .font(.system(size: 15))
                    }
                }
                
                Spacer(minLength: 0)
                
                Circle()
                    .fill(isActive ? .green : .red)
                    .frame(width: 20, height: 20)
            }
            .onTapGesture {
                showDetails.toggle()
            }
            
            if showDetails {
                HStack{
                    Text("Kasa :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("₺ \(balance)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Ürün Türü")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(productType)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Toplam Ürün :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(productTotal)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Satış Kuru :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("$ \(String(format: "%.2f", dollar))")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Ürün Alış :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(boughtPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Ürün Satış :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(sellPrice)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Online :")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    if isActive {
                        Text("Evet")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    else {
                        Text("Hayır")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
                
                if self.selectedDocID != platformDocID {
                    Button {
                        let ref = Firestore.firestore()
                        ref.collection("Bayii").document(storeNick).setData(["selectedApp" : platformDocID],merge: true)
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Text("Geçiş Yap")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    .frame(height: 45)
                }
            }
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
