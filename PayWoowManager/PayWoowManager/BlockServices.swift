//
//  BlockServices.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 3/29/23.
//

import SwiftUI
import Lottie
import FirebaseFirestore

struct BlockServices: View {
    @StateObject var general = GeneralStore()
    @StateObject var store = BlockStore()
    @StateObject var userStore = UserStore()
    @Environment(\.presentationMode) var present
    @State private var selection : Int = 0
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                HStack(spacing: 15){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName : "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Ban İşlemleri")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top], 20)
                
                HStack(spacing: 15){
                    Text("İhlal")
                        .foregroundColor(selection == 0 ? .white : .gray)
                        .font(.system(size: 18))
                        .onTapGesture {
                            self.selection = 0
                        }
                    
                    Text("Onay")
                        .foregroundColor(selection == 1 ? .white : .gray)
                        .font(.system(size: 18))
                        .onTapGesture {
                            self.selection = 1
                        }
                    
                    Text("Red")
                        .foregroundColor(selection == 2 ? .white : .gray)
                        .font(.system(size: 18))
                        .onTapGesture {
                            self.selection = 2
                        }
                    
                    Spacer(minLength: 0)
                    
                    
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                        ForEach(store.list){ item in
                            if self.selection == 0  && item.step == 5 {
                                BlockContent(angelID: item.angelID, devilID: item.devilID, classs: item.classs, point: item.point, product: item.product, step: item.step, docID: item.docID)
                            }
                            
                            if self.selection == 1  && item.step == 2 || item.step == 3 {
                                BlockContent(angelID: item.angelID, devilID: item.devilID, classs: item.classs, point: item.point, product: item.product, step: item.step, docID: item.docID)
                            }
                            
                            if self.selection == 2  && item.step == 4 {
                                BlockContent(angelID: item.angelID, devilID: item.devilID, classs: item.classs, point: item.point, product: item.product, step: item.step, docID: item.docID)
                            }
                        }
                }
            }
        }
    }
}

struct BlockModel: Identifiable {
    var id = UUID()
    var angelID : String
    var devilID : String
    var classs : String
    var point : Int
    var product : Int
    var step : Int
    var docID : String
}

class BlockStore: ObservableObject {
    @Published var list : [BlockModel] = []
    let ref = Firestore.firestore()
    init(){
        ref.collection("BlockTransactions").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    if let angelID = doc.get("angelID") as? String {
                        if let devilID = doc.get("devilID") as? String {
                            if let classs = doc.get("class") as? String {
                                if let point = doc.get("point") as? Int {
                                    if let product = doc.get("product") as? Int {
                                        if let step = doc.get("step") as? Int {
                                            let data = BlockModel(angelID: angelID, devilID: devilID, classs: classs, point: point, product: product, step: step, docID: doc.documentID)
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

struct BlockContent: View {
    @State var angelID : String
    @State var devilID : String
    @State var classs : String
    @State var point : Int
    @State var product : Int
    @State var step : Int
    @State var docID : String
    
    @State private var angel_pfImage : String = ""
    @State private var angel_level : Int = 0
    @State private var angel_nick : String = ""
    @State private var angel_vipPoint : Int = 0
    @State private var angel_gift : Int = 0
    
    @State private var devil_pfImage : String = ""
    @State private var devil_level : Int = 0
    @State private var devil_nick : String = ""
    @State private var devil_vipType : String = ""
    @State private var devil_money : Int = 0
    
    @State private var showDetails : Bool = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            VStack(spacing: 15){
                
                HStack{
                    VStack(alignment: .center){
                        ZStack{
                            
                            AsyncImage(url: URL(string: angel_pfImage)) { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 11)
                            } placeholder: {
                                Image("logoWhite")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 11)
                            }
                            
                            
                            LottieView(name: "angel_white", loopMode: .loop)
                                .scaleEffect(1.5)
                                .frame(width: 95, height: 95)
                                .offset(y: -3)
                            
                            if self.angel_level != 0 {
                                LevelContentProfile(level: angel_level)
                                    .scaleEffect(0.8)
                                    .offset(y: 40)
                            }
                        }
                        .scaleEffect(0.7)
                        
                        Text(angel_nick)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        Text("\(point)pt")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
                    .padding(.leading, -10)
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .center){
                        Button {
                            self.showDetails.toggle()
                        } label: {
                            if step == 2 || step == 3 {
                                Text("Onay")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.green)
                                    .cornerRadius(4)
                            }
                            else if step == 4 {
                                Text("Red")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                            else if step == 5 {
                                Text("İhlal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(classs)
                            .foregroundColor(.white)
                            .font(.system(size: 15))

                        
                    }
                    
                    Spacer(minLength: 0)
                    VStack(alignment: .center){
                        ZStack{
                            
                            AsyncImage(url: URL(string: devil_pfImage)) { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 11)
                            } placeholder: {
                                Image("logoWhite")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 11)
                            }
                            
                            
                            LottieView(name: "angel_red", loopMode: .loop)
                                .scaleEffect(1.5)
                                .frame(width: 95, height: 95)
                                .offset(x: 1.5, y: -3)
                            
                            if self.devil_level != 0 {
                                LevelContentProfile(level: devil_level)
                                    .scaleEffect(0.8)
                                    .offset(y: 40)
                            }
                        }
                        .scaleEffect(0.7)
                        
                        Text(devil_nick)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                        
                        Text("\(product) elmas")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
                    .padding(.trailing, -10)
                }
                
                if showDetails && step == 5{
                    HStack(spacing: 15){
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Users").document(devilID).collection("VIPCard").document(devil_vipType).setData(
                                [
                                    "totalPrice" : devil_money + (point * 50)
                                ], merge: true)
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Şeytana Ödül İade")
                                    .foregroundColor(.black)
                                    .font(.system(size: 13))
                            }
                        }
                        
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Users").document(angelID).setData(
                                [
                                    "gift" : angel_gift + product,
                                    "vipPoint" : angel_vipPoint - point
                                ], merge: true)
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                Text("Meleğe Ödül Transfer")
                                    .foregroundColor(.black)
                                    .font(.system(size: 13))
                            }
                        }
                        
                    }
                    .frame(height: 50)
                    
                    HStack(spacing: 15){
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Users").document(angelID).setData([
                                "vipType" : "Casper"
                            ],merge: true)
                            
                            ref.collection("BlockTransactions").document(docID).setData([
                                "step" : 6
                            ], merge: true)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Melek VIP İptal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13))
                            }
                        }
                        
                        Button {
                            let ref = Firestore.firestore()
                            ref.collection("Users").document(devilID).setData([
                                "vipType" : "Casper"
                            ],merge: true)
                            
                            ref.collection("BlockTransactions").document(docID).setData([
                                "step" : 6
                            ], merge: true)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white)
                                
                                Text("Şeytan VIP İptal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13))
                            }
                        }
                        
                    }
                    .frame(height: 50)
                }
                
            }
            .padding(.all, 15)
        }
        .padding(.horizontal)
        .onAppear{
            let ref = Firestore.firestore()
            
            ref.collection("Users").document(angelID).addSnapshotListener { doc, err in
                if err == nil {
                    if let nickname = doc?.get("nickname") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let vipPoint = doc?.get("vipPoint") as? Int {
                                    if let gift = doc?.get("gift") as? Int {
                                        self.angel_nick = nickname
                                        self.angel_pfImage = pfImage
                                        self.angel_level = level
                                        self.angel_vipPoint = vipPoint
                                        self.angel_gift = gift
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            ref.collection("Users").document(devilID).addSnapshotListener { doc, err in
                if err == nil {
                    if let nickname = doc?.get("nickname") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let vipType = doc?.get("vipType") as? String {
                                    self.devil_nick = nickname
                                    self.devil_pfImage = pfImage
                                    self.devil_level = level
                                    self.devil_vipType = vipType
                                    ref.collection("Users").document(devilID).collection("VIPCard").document(vipType).addSnapshotListener { snap, err in
                                        if err == nil {
                                            if let totalPrice = snap?.get("totalPrice") as? Int {
                                                self.devil_money = totalPrice
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



