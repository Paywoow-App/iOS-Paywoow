//
//  Remittences.swift
//  PayWoowManager
//
//  Created by 2017 on 3/17/23.
//

import SwiftUI
import FirebaseFirestore

struct Remittences: View {
    @StateObject var general = GeneralStore()
    @StateObject var userIDStore = RemittencesStore()
    @State private var selection = 0
    @Environment(\.presentationMode) var present
    
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                HStack(spacing: 12){
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

                    
                    Text("Havale EFT Kontrol")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                HStack{
                    Button {
                        selection = 0
                    } label: {
                        Text("Bekleyen")
                            .foregroundColor(selection == 0 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }
                    
                    Button {
                        selection = 1
                    } label: {
                        Text("Onaylanan")
                            .foregroundColor(selection == 1 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }
                    
                    Button {
                        selection = 2
                    } label: {
                        Text("Reddedilen")
                            .foregroundColor(selection == 2 ? Color.white : Color.white.opacity(0.5))
                            .font(.system(size: 18))
                    }
                    
                    Spacer(minLength: 0)

                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(userIDStore.list) { item in
                        RemittenceUserContent(userID: item.userID, selection: $selection)
                    }
                }
            }
        }
    }
}

struct RemittenceUserModel : Identifiable {
    var id = UUID()
    var userID : String
}

struct RemittencesModel : Identifiable {
    var id = UUID()
    var bank : String
    var iban : String
    var price : Int
    var timeStamp : Int
    var userID : String
    var docID : String
    var isDeclinedPrice : Bool
    var isUploadedPrice : Bool
}

class RemittencesStore: ObservableObject {
    @Published var list : [RemittenceUserModel] = []
    
    init(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    self.list.append(RemittenceUserModel(userID: doc.documentID))
                }
            }
        }
    }
}

struct RemittenceUserContent: View {
    @State var userID: String
    @Binding var selection : Int
    @State private var list : [RemittencesModel] = []
    var body : some View {
        VStack{
            ForEach(list) { list in
                if selection == 0 && list.isDeclinedPrice == false && list.isUploadedPrice == false {
                    RemittenceContent(bank: list.bank, iban: list.iban, price: list.price, timeStamp: list.timeStamp, userID: list.userID, docID: list.docID, isDeclinedPrice: list.isDeclinedPrice, isUploadedPrice: list.isUploadedPrice)
                }
                
                else if selection == 1 && list.isUploadedPrice == true {
                    RemittenceContent(bank: list.bank, iban: list.iban, price: list.price, timeStamp: list.timeStamp, userID: list.userID, docID: list.docID, isDeclinedPrice: list.isDeclinedPrice, isUploadedPrice: list.isUploadedPrice)
                }
                
                else if selection == 2 && list.isDeclinedPrice == true {
                    RemittenceContent(bank: list.bank, iban: list.iban, price: list.price, timeStamp: list.timeStamp, userID: list.userID, docID: list.docID, isDeclinedPrice: list.isDeclinedPrice, isUploadedPrice: list.isUploadedPrice)
                }
            }
        }
        .onAppear{
            getMainData()
        }
    }
    
    func getMainData(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).collection("RemittenceHistory").order(by: "timeStamp", descending: true).addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let bank = doc.get("bank") as? String {
                        if let iban = doc.get("iban") as? String {
                            if let price = doc.get("price") as? Int {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let isDeclinedPrice = doc.get("isDeclinedPrice") as? Bool {
                                       if let isUploadedPrice = doc.get("isUploadedPrice") as? Bool {
                                           let data = RemittencesModel(bank: bank, iban: iban, price: price, timeStamp: timeStamp, userID: userID, docID: doc.documentID, isDeclinedPrice: isDeclinedPrice, isUploadedPrice: isUploadedPrice)
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


struct RemittenceContent: View {
    @State var bank : String
    @State var iban : String
    @State var price : Int
    @State var timeStamp : Int
    @State var userID : String
    @State var docID : String
    @State var isDeclinedPrice : Bool
    @State var isUploadedPrice : Bool
    
    @State private var pfImage : String = ""
    @State private var fullname : String = ""
    @State private var dateTime : String = ""
    @State private var vipType : String = ""
    @State private var currentTotal : Int = 0
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    AsyncImage(url: URL(string: pfImage)) { img in
                        img
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
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text(fullname)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                            
                            Spacer(minLength: 0)
                            
                            Text("TL \(price)")
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                        }
                        
                        Text(bank)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }

                }
                
                
                HStack{
                    Text("IBAN")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(iban)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("Tarih")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    Text(dateTime)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text("İşlem Durumu")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    if self.isUploadedPrice == true {
                        Text("Tamamlandı")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    else if isDeclinedPrice == true {
                        Text("Reddedildi")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    else if self.isDeclinedPrice == false && self.isUploadedPrice == false {
                        Text("Beklemede")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                }
            }
            .padding(.all, 15)
        }
        .contextMenu{
            if self.isUploadedPrice == false && self.isDeclinedPrice == false {
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userID).collection("RemittenceHistory").document(docID).setData([
                        "isUploadedPrice" : true
                    ], merge: true)
                    
                    ref.collection("Users").document(userID).collection("VIPCard").document(vipType).setData([
                        "totalPrice" : currentTotal + price
                    ], merge: true)
                    
                } label: {
                    Text("Onayla")
                }
                
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Users").document(userID).collection("RemittenceHistory").document(docID).setData([
                        "isDeclinedPrice" : true
                    ], merge: true)
                    
                } label: {
                    Text("Reddet")
                }
            }

        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .onAppear{
            getData()
        }
    }
    
    func getData(){
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy : HH:mm"
        self.dateTime = formatter.string(from: date)
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { snap, err in
            if err == nil {
                if let firstName = snap?.get("firstName") as? String {
                    if let lastName = snap?.get("lastName") as? String {
                        if let pfImage = snap?.get("pfImage") as? String {
                            if let vipType = snap?.get("vipType") as? String {
                                self.fullname = "\(firstName) \(lastName)"
                                self.pfImage = pfImage
                                self.vipType = vipType
                                ref.collection("Users").document(userID).collection("VIPCard").document(vipType).addSnapshotListener { snap, err in
                                    if err == nil {
                                        if let currentTotal = snap?.get("totalPrice") as? Int {
                                            self.currentTotal = currentTotal
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
