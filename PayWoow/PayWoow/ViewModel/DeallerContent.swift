//
//  DeallerContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct BayiiContent: View {
    @State var bayiiId : String
    @State var selectedDealler : String
    
    @State private var deallerName : String = ""
    @State private var boughtPrice : Int = 0
    @State private var balance : Int = 0
    @State private var coverImage : String = ""
    @State private var dollar : Double = 0
    @State private var isActive : Bool = false
    @State private var maxLimit : Int = 0
    @State private var platformImage : String = ""
    @State private var platformName : String = ""
    @State private var productTotal : Int = 0
    @State private var productType : String = ""
    @State private var sellPrice : Int = 0
    
    
    //data 
    
    @AppStorage("orderWriterSize") var orderWriterSize : String = "0"
    @AppStorage("toOrderWriter") var toOrderWriter = false
    @AppStorage("orderWriterBayiId") var orderWriterBayiId = ""
    @AppStorage("defualtYigit") var defualtYigit : String = "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FDiamondBayii%2FMale.png?alt=media&token=d6bf445e-c908-4771-a53a-615ac2ab2292"
    
    @AppStorage("defualtFerina") var defualtFerina : String = "https://firebasestorage.googleapis.com/v0/b/paywoowapp-18e51.appspot.com/o/Deallers%2FFerinaValentino%2FFemale.png?alt=media&token=8e919fbc-d02d-4776-95b6-1519e896d8d7"
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert = false

    @State private var result = 0
    @StateObject var generalStore = GeneralStore()
    @Environment(\.openURL) var openURL
    @State private var barSize : Double = 0.0
    @State private var topPadding = false
    var body: some View{
        HStack{
            ZStack{
                WebImage(url: URL(string: coverImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                
                if self.generalStore.christmasHat == true {
                    LottieView(name: "christmasHat", loopMode: .loop)
                        .frame(width: 100, height: 100)
                        .offset(x: 10, y: -15)
                        .onTapGesture {
                            if self.bayiiId == "DiamondBayii" && self.generalStore.liveYigit == true && self.generalStore.liveLinkYigit != "" {
                                openURL(URL(string: self.generalStore.liveLinkYigit)!)
                            }
                            
                            if self.bayiiId == "FerinaValentino" && self.generalStore.liveFerina == true && self.generalStore.liveLinkFerina != "" {
                                openURL(URL(string: self.generalStore.liveLinkFerina)!)
                            }
                        }
                }
                
                if self.bayiiId == "DiamondBayii" && self.generalStore.liveYigit == true && self.generalStore.liveLinkYigit != ""{
                    LottieView(name: "live", loopMode: .loop)
                        .frame(width: 40, height: 30)
                        .offset(x: 0, y: 50)
                        .onTapGesture {
                            openURL(URL(string: self.generalStore.liveLinkYigit)!)
                        }
                }
                
                if self.bayiiId == "FerinaValentino" && self.generalStore.liveFerina == true && self.generalStore.liveLinkFerina != ""{
                    LottieView(name: "live", loopMode: .loop)
                        .frame(width: 40, height: 30)
                        .offset(x: 0, y: 50)
                        .onTapGesture {
                            openURL(URL(string: self.generalStore.liveLinkFerina)!)
                        }
                }
            }
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(deallerName)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                
                    Spacer(minLength: 0)
                    
                    if isActive {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                    }
                    else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                    }
                }
                
                HStack{
                    if self.bayiiId == "FerinaValentino" {
                        Text("ID : Valentinoboss")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .fontWeight(.light)
                    }
                    else {
                        Text("ID : D1amondBoss")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .fontWeight(.light)
                    }
                
                    Spacer(minLength: 0)
                    
                    
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.white)
                    
                    HStack{
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(hex: "#1CC4BE"))
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)){
                                    let step1 = Double(maxLimit / 100)
                                    let step2 = Double(step1) * Double(balance)
                                    let step3 = Double(step2) / 10000000000
                                    let step4 = step3 * 0.63 // do not forget
                                    self.barSize = step4
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * barSize)
                        
                        Spacer(minLength: 0)
                    }
                        
                }
                .frame(height: 7)
                
                HStack(spacing: 5){
                    ForEach(1 ... 5, id: \.self){ item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        if self.isActive {
                            self.orderWriterSize = "\(barSize)"
                            self.toOrderWriter.toggle()
                            self.orderWriterBayiId = "\(self.bayiiId)"
                        }
                        else {
                            self.alertTitle = "Please Try Again Later!"
                            self.alertBody = "Unfortunately, we are out of business hours at the moment."
                            self.showAlert.toggle()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.init(hex: "#1CC4BE"))
                            
                            Text("Order Now")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                        .frame(width: 120, height: 30)
                    }

                }
            }
            
        }
        
       
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.cancel(Text("Ok")))
        }
        .padding(.horizontal)
        .padding(.top, topPadding ? 10 : 0)
        .onAppear{
            if bayiiId == "FerinaValentino" {
                self.coverImage = defualtFerina
            }
            else {
                self.coverImage = defualtYigit
            }
            if self.bayiiId == "DiamondBayii" {
                self.topPadding = true
                getDealler()
            }
            else {
                self.topPadding = false
                getDealler()
            }
            
            
        }
    }
    
    func getDealler(){
        let ref = Firestore.firestore()
        if bayiiId == "FerinaValentino" {
            self.coverImage = defualtFerina
        }
        else {
            self.coverImage = defualtYigit
        }
        ref.collection("Bayii").document(bayiiId).collection("Apps").addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let platformName = doc.get("platformName") as? String {
                        if self.selectedDealler == platformName {
                            if let deallerName = doc.get("deallerName") as? String {
                                if let boughtPrice = doc.get("boughtPrice") as? Int {
                                    if let balance = doc.get("balance") as? Int {
                                        if let coverImage = doc.get("coverImage") as? String {
                                            if let dollar = doc.get("dollar") as? Double {
                                                if let isActive = doc.get("isActive") as? Bool {
                                                    if let maxLimit = doc.get("maxLimit") as? Int {
                                                        if let platformImage = doc.get("platformImage") as? String {
                                                            if let productTotal = doc.get("productTotal") as? Int {
                                                                if let productType = doc.get("productType") as? String {
                                                                    if let sellPrice = doc.get("sellPrice") as? Int {
                                                                        self.deallerName = deallerName
                                                                        self.boughtPrice = boughtPrice
                                                                        self.balance = balance
                                                                        self.coverImage = coverImage
                                                                        self.dollar = dollar
                                                                        self.isActive = isActive
                                                                        self.maxLimit = maxLimit
                                                                        self.platformImage = platformImage
                                                                        self.platformName = platformName
                                                                        self.productTotal = productTotal
                                                                        self.productType = productType
                                                                        self.sellPrice  = sellPrice
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
        }
    }
}

