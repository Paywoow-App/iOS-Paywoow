//
//  Investories.swift
//  PayWoowManager
//
//  Created by 2017 on 3/18/23.
//

import SwiftUI
import FirebaseFirestore

struct Investories: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = InvestStore()
    @State private var toAdd : Bool = false
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Yatırımcı Kontrol")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                    
                    Button {
                        self.toAdd.toggle()
                    } label: {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                    }
                    .popover(isPresented: $toAdd) {
                        InvestCreater()
                    }

                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.list){ item in
                        InvestContent(blockLimit: item.blockLimit, createdDate: item.createdDate, currency: item.currency, currencySymbol: item.currencySymbol, isActive: item.isActive, percent: item.percent, selectedPlatforms: item.selectedPlatforms, totalPrice: item.totalPrice, totalSold: item.totalSold, userID: item.userID)
                    }
                }
            }
        }
    }
}

struct InvestContent : View {
    @State var blockLimit : Int
    @State var createdDate : Int
    @State var currency : String
    @State var currencySymbol : String
    @State var isActive : Bool
    @State var percent : Int
    @State var selectedPlatforms : [String]
    @State var totalPrice : Int
    @State var totalSold : Int
    @State var userID : String
    
    @State private var pfImage : String = ""
    @State private var fullname : String = ""
    @State private var nickname : String = ""
    @State private var dateTime : String = ""
    @State var platformID: String = ""
    @State private var showDetails : Bool = false
    var body: some View {
        ZStack{
            if !platformID.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                                   .fill(Color.black.opacity(0.2))
                    VStack(spacing: 15){
                        HStack(spacing: 15){
                            AsyncImage(url: URL(string: pfImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60)
                            } placeholder: {
                                Image("defRefPF")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading, spacing: 10){
                                Text(fullname)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                HStack(spacing: 5) {
                                    Text(nickname)
                                        .foregroundColor(.white)
                                        .fontWeight(.light)
                                        .font(.system(size: 15))
                                    
                                    Text("(ID: \(platformID))")
                                        .foregroundColor(.white)
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 13))
                                }
                            }
                            .onAppear {
                                print("GAYY : \(userID)")
                            }
                            
                            Spacer(minLength: 0)
                            
        //                    Toggle("", isOn: $isActive)
        //                        .labelsHidden()
        //                        .onChange(of: isActive) { val in
        //                            let ref = Firestore.firestore()
        //                            ref.collection("Investories").document(userID).setData([
        //                                "isActive" : val
        //                            ], merge: true)
        //                        }
                        }
                        
                        if showDetails {
                            HStack{
                                Text("Yatırım Miktarı")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("TL \(totalPrice)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            HStack{
                                Text("Oluşturulma Tarihi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text(dateTime)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            
                            HStack{
                                Text("Kur")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(currencySymbol)\(currency)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            
                            HStack{
                                Text("Yüzde")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("% \(totalPrice)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            
                            HStack{
                                Text("Satış Miktarı")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("TL \(totalSold)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            
                            HStack{
                                Text("Bloke Süresi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(blockLimit) Ay")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            HStack{
                                Text("Kalan Bloke Süresi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text("TL \(totalPrice)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            
                            HStack{
                                Text("Uygulama")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                                
                                Text(selectedPlatforms.first!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .padding(.all, 15)
                    .onTapGesture {
                        self.showDetails.toggle()
                }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
        .onAppear{
            getData()
            
            let date = Date(timeIntervalSince1970: TimeInterval(createdDate))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.dateTime = formatter.string(from: date)
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let nickname = doc?.get("nickname") as? String {
                                if let platformid = doc?.get("platformID") as? String {
                                    self.platformID = platformid
                                    self.fullname = "\(firstName) \(lastName)"
                                    self.pfImage = pfImage
                                    self.nickname = nickname
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct InvestModel : Identifiable {
    var id = UUID()
    var blockLimit : Int
    var createdDate : Int
    var currency : String
    var currencySymbol : String
    var isActive : Bool
    var percent : Int
    var selectedPlatforms : [String]
    var totalPrice : Int
    var totalSold : Int
    var userID : String
}

class InvestStore : ObservableObject {
    @Published var list : [InvestModel] = []
    
    init(){
        let ref = Firestore.firestore()
        ref.collection("Investories").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let blockLimit = doc.get("blockLimit") as? Int {
                        if let createdDate = doc.get("createdDate") as? Int {
                            if let currency = doc.get("currency") as? String {
                                if let currencySymbol = doc.get("currencySymbol") as? String {
                                    if let isActive = doc.get("isActive") as? Bool {
                                        if let percent = doc.get("percent") as? Int {
                                            if let selectedPlatforms = doc.get("selectedPlatforms") as? [String] {
                                                if let totalPrice = doc.get("totalPrice") as? Int {
                                                    if let totalSold = doc.get("totalSold") as? Int {
                                                        let data = InvestModel(blockLimit: blockLimit, createdDate: createdDate, currency: currency, currencySymbol: currencySymbol, isActive: isActive, percent: percent, selectedPlatforms: selectedPlatforms, totalPrice: totalPrice, totalSold: totalSold, userID: doc.documentID)
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
                }
            }
        }
    }
}
