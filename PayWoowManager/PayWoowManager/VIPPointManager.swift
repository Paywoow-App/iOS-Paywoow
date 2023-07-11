//
//  VIPPoıntManager.swift
//  PayWoowManager
//
//  Created by 2017 on 3/19/23.
//

import SwiftUI
import FirebaseFirestore

struct VIPPointManager: View {
    @StateObject var general = GeneralStore()
    @State private var uploadSelection = 1
    @State private var currentMonth : String = ""
    @State private var currentYears : String = ""
    @State private var nextMonth : String = ""
    @State private var list : [String] = []
    @State private var attack : Bool = false
    @State private var selectedDate = Date()
    @State private var selection : Int = 0
    @State private var complatedList : [Bool] = []
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20){
                HStack(spacing: 15){
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
                    
                    Text("VIP Puan Yönetimi")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                HStack(spacing: 15){
                    Text("\(currentMonth) ayından")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .opacity(0.5)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    Text("\(nextMonth) puanı")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
                
                TabView(selection: $selection){
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(list, id: \.self){ item in
                            VIPointUserContent(userID: item, currentYear: $currentYears, currentMonth: $currentMonth, attack: $attack, nextMonth: $nextMonth, complatedList: $complatedList, selection: $selection)
                            
                        }
                    }

                    VStack{
                        
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                            .colorScheme(.dark)
                            .colorMultiply(Color.white)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
                if complatedList.contains(where: {$0 == false}) {
                    
                    Button {
                        self.attack = true
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            Text("Toplu Puan Gönder")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                        }
                        .frame(height: 50)
                        .padding(.all)
                    }

                }

            }
        }
        .onAppear{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.currentMonth = formatter.string(from: date)
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy"
            formatter2.locale = Locale(identifier: "tr_TRPOSIX")
            self.currentYears = formatter2.string(from: date)
            
            if let date = Calendar.current.date(byAdding: .month, value: 1, to: date) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM"
                formatter.locale = Locale(identifier: "tr_TRPOSIX")
                self.nextMonth = formatter.string(from: date)
                getData()
            }
        }
    }
    
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("Users").addSnapshotListener { snap, err in
            if err == nil {
                self.list.removeAll()
                for doc in snap!.documents {
                    print("I amworkinggss")
                    self.list.append(doc.documentID)
                    
                }
            }
        }
    }
}

struct ControlPointModel : Identifiable {
    var id = UUID()
    var month : String
    var year : String
    var point : Int
}

struct VIPointUserContent: View {
    @State var userID : String
    @Binding var currentYear : String
    @Binding var currentMonth : String
    @Binding var attack : Bool
    @Binding var nextMonth : String
    @Binding var complatedList : [Bool]
    @Binding var selection : Int
    //userInfo
    @State var currentUpload : Int = 0
    
    @State private var list : [ControlPointModel] = []
    @State private var point : Int = 0
    @State private var lock : Bool = false
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var platformID : String = ""
    @State private var collectID : String = ""
    @State private var block : Bool = false
    
    @State private var requiredSelectin : Int = 1
    var body: some View {
            ZStack{
            if currentUpload != 0 && self.lock == false && !self.list.contains(where: {$0.month == nextMonth}) {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    VStack{
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
                            
                            VStack(spacing: 10){
                                HStack{
                                    Text("\(firstName) \(lastName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(currentUpload)K")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("PID: \(platformID)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(point)p")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                    }
                    .padding(.all, 15)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .onAppear{
                    self.complatedList.removeAll()
                    complatedList.append(false)
                }
            }
            else if currentUpload != 0 && self.lock == false && self.list.contains(where: {$0.month == nextMonth}) {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    VStack{
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
                            
                            VStack(spacing: 10){
                                HStack{
                                    Text("\(firstName) \(lastName)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(currentUpload)K")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                                
                                HStack{
                                    Text("PID: \(platformID)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("\(point)p")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                    }
                    .padding(.all, 15)
                    .opacity(0.5)
                    
                    Text("Tamamlandı")
                        .foregroundColor(.green)
                        .font(.system(.title2))
                        .bold()
                        .rotationEffect(.degrees(-20))
                }
                .padding(.horizontal)
                .padding(.bottom)
                .onAppear{
                    self.complatedList.removeAll()
                    complatedList.append(true)
                }
            }
        }
        .contextMenu{
            Button {
                getAgainThePoints()
            } label: {
                Text("Puanı geri al")
            }
        }
        .onAppear{
            let ref = Firestore.firestore()
            ref.collection("Users").document(userID).addSnapshotListener { doc, err in
                if err == nil {
                    if let firstName = doc?.get("firstName") as? String {
                        if let lastName = doc?.get("lastName") as? String {
                            if let pfImage = doc?.get("pfImage") as? String {
                                if let platformID = doc?.get("platformID") as? String {
                                    self.firstName = firstName
                                    self.lastName = lastName
                                    self.platformID = platformID
                                    self.pfImage = pfImage
                                    print("docID mı iasdkjasd = \(platformID)")
                                }
                            }
                        }
                    }
                }
            }
            
            ref.collection("Users").document(userID).collection("UserStatics").document("SoldDiamond").collection("Years").document(currentYear).addSnapshotListener { doc, err in
                if err == nil {
                    self.currentUpload = 0
                    if let currentUpload = doc?.get("\(currentMonth)") as? Int {
                        print("printttts = \(userID)")
                       if currentUpload > 29999 {
                            let k = currentUpload / 1000
                            self.currentUpload = k
                            
                            if currentUpload >= 30000 && currentUpload < 150000 {
                                self.point = 250
                                self.requiredSelectin = 1
                            }
                            
                            if currentUpload >= 150000 && currentUpload < 300000 {
                                self.point = 500
                                self.requiredSelectin = 2
                            }
                            
                            if currentUpload >= 300000 && currentUpload < 500000 {
                                self.point = 900
                                self.requiredSelectin = 3
                            }
                            
                            if currentUpload >= 500000 && currentUpload < 800000 {
                                self.point = 1500
                                self.requiredSelectin = 4
                            }
                            if currentUpload >= 800000 {
                                self.point = 2000
                                self.requiredSelectin = 5
                            }
                            
                        }
                    }
                }
            }
            
            ref.collection("Users").document(userID).collection("SentVipPoint").addSnapshotListener { snap, err in
                if err == nil {
                    self.list.removeAll()
                    for doc in snap!.documents {
                        if let month = doc.get("sentForMonth") as? String {
                            if let year = doc.get("sentForYear") as? String {
                                if let point = doc.get("point") as? Int {
                                    if month == nextMonth && currentYear == year {
                                        let data = ControlPointModel(month: month, year: year, point: point)
                                        self.list.append(data)
                                        self.collectID = doc.documentID
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        // Send VIP POint ile ilgili
        .onChange(of: attack) { val in
            if currentUpload != 0 && self.lock == false && !self.list.contains(where: {$0.month == nextMonth}){
                let ref = Firestore.firestore()
                let timeStamp = Date().timeIntervalSince1970
                print("-BuğUaserIDDDSSSS- \n\(userID)\n\(nextMonth)\n\(currentYear)\n\(timeStamp)\n\(point)-BuğUaserIDDDSSSS-")
                ref.collection("Users").document(userID).collection("SentVipPoint").document("\(Int(timeStamp))").setData([
                    "sentForMonth" : nextMonth,
                    "sentForYear" : currentYear,
                    "timeStamp" : Int(timeStamp),
                    "point" : point,
                ], merge: true)
                self.attack = false
                
            }
        }
    }
    
    
    func getAgainThePoints(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).collection("SentVipPoint").document(collectID).delete()
    }
}
