//
//  Angels.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/22/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct AngelContent: View {
    @State var userID : String 
    @State var timeStamp : Int
    @Binding var showBottomBar : Bool
    @Binding var selectedUserID : String
    @Binding var showAngelRequestMaker : Bool
    @Binding var iAmAngel : Bool
    @StateObject var userStore = UserInfoStore()
    //AngelDetails
    @State var totalPoint : Int = 0
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var level : Int = 0
    @State private var nickname : String = ""
    @State private var token : String = ""
    @State private var vipType : String = ""
    
    var body : some View {
        HStack{
            ZStack{
                
                AsyncImage(url: URL(string: pfImage)) { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                        .shadow(radius: 11)
                } placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                        .shadow(radius: 11)
                }
                    
                
                LottieView(name: "angel_white", loopMode: .loop, speed: 2.0)
                    .scaleEffect(1.5)
                    .frame(width: 95, height: 95)
                    .offset(y: -3)
                
                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.8)
                        .offset(y: 40)
                } 
            }
            .scaleEffect(0.7)
            .padding(.leading, -10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(nickname)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                
                HStack{
                    Text("Puan : \(totalPoint)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                    
                    if userID == Auth.auth().currentUser!.uid {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(colors: [
                                    Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255),
                                    Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)
                                ], startPoint: .leading, endPoint: .trailing))
                            
                            Text("Finding")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                        }
                        .frame(width: 110, height: 30, alignment: Alignment.center)
                    } else if !iAmAngel {
                        if self.userID != Auth.auth().currentUser!.uid {
                            Button {
                                self.selectedUserID = userID
                                self.showAngelRequestMaker = true
                                self.showBottomBar = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient(colors: [
                                            Color.init(red: 177 / 255, green: 59 / 255, blue: 201 / 255),
                                            Color.init(red: 232 / 255, green: 92 / 255, blue: 74 / 255)
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    
                                    Text("Yardım İste")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.regular)
                                }
                                .frame(width: 110, height: 30, alignment: Alignment.center)
                            }
                        }
                    }
                }
            }
            .padding(.leading, -10)
        }
        .padding(.horizontal)
        .onAppear{
            listenAngel()
        }
        .contextMenu{
            if self.userID == Auth.auth().currentUser!.uid {
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Angels").document(Auth.auth().currentUser!.uid).delete()
                } label: {
                    Text("Beni kaldır")
                }

            }
        }
    }
    
    func listenAngel(){
        let ref = Firestore.firestore()
        ref.collection("Angels").document(userID).addSnapshotListener { doc, err in
            if let totalPoint = doc?.get("totalPoint") as? Int {
                self.totalPoint = totalPoint
            }
        }
        
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("lastName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let level = doc?.get("level") as? Int {
                                if let nickname = doc?.get("nickname") as? String {
                                    if let token = doc?.get("token") as? String {
                                        if let vipType = doc?.get("vipType") as? String {
                                            self.firstName = firstName
                                            self.lastName = lastName
                                            self.pfImage = pfImage
                                            self.level = level
                                            self.nickname = nickname
                                            self.token = token
                                            self.vipType = vipType
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

struct DevilContent: View {
    @State var userID : String 
    @State var timeStamp : Int
    @Binding var selectedUserID : String
    @Binding var selectedClass : String
    @Binding var selectedDescription : String
    @Binding var selectedPoint : Int
    @Binding var showBottomBar : Bool
    @Binding var showDevilRequestMaker : Bool
    @Binding var iAmAngel : Bool
    @StateObject var userStore = UserInfoStore()
    
    // MARK: Request Details
    @State private var classTitle : String = ""
    @State private var request : String = ""
    @State private var point : Int = 0
    
    // MARK: User Details
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    @State private var nickname : String = ""
    @State private var level : Int = 0
    
    //Alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    @State private var isItDevilPermision: Bool = false
    
    var body : some View {
        HStack{
            ZStack{
                AsyncImage(url: URL(string: pfImage)) { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                        .shadow(radius: 11)
                } placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                        .shadow(radius: 11)
                }

                LottieView(name: "angel_red", loopMode: .loop, speed: 2.0)
                    .scaleEffect(1.5)
                    .frame(width: 95, height: 95)
                    .offset(x: 1.5,y: -3.5)
                
                
                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.8)
                        .offset(y: 40)
                }
            }
            .scaleEffect(0.7)
            .padding(.leading, -10)
            
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    Text(nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text(classTitle)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                HStack{
                    Text(request)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    
                    Spacer(minLength: 0)
                    //
                    
                    if userID == Auth.auth().currentUser!.uid {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(colors: [
                                    Color.init(red: 131 / 255, green: 243 / 255, blue: 227 / 255),
                                    Color.init(red: 86 / 255, green: 180 / 255, blue: 203 / 255)
                                ], startPoint: .leading, endPoint: .trailing))
                            
                            Text("Finding")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                        }
                        .frame(width: 110, height: 30, alignment: Alignment.center)
                    } else if !isItDevilPermision {
                        Button {
                            
                            if self.iAmAngel {
                                self.selectedUserID = userID
                                self.selectedClass = classTitle
                                self.selectedDescription = request
                                self.selectedPoint = point
                                self.showDevilRequestMaker = true
                                self.showBottomBar = false
                            }
                            else {
                                self.alertTitle = "Uyarı"
                                self.alertBody = "Bir şeytana yardım edebilmek için öncelikle melek olmalısın"
                                self.showAlert.toggle()
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(LinearGradient(colors: [
                                        Color.init(red: 177 / 255, green: 59 / 255, blue: 201 / 255),
                                        Color.init(red: 232 / 255, green: 92 / 255, blue: 74 / 255)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                Text("Yardım Et")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                            }
                            .frame(width: 110, height: 30, alignment: Alignment.center)
                        }
                    }
                }
            }
            .padding(.leading, -10)
           
        }
        .padding(.horizontal)
        .onAppear{
            listenAngel()
            isItDevil()
        }
        .contextMenu{
            if self.userID == Auth.auth().currentUser!.uid {
                Button {
                    let ref = Firestore.firestore()
                    ref.collection("Devils").document(Auth.auth().currentUser!.uid).delete()
                } label: {
                    Text("Remove Me")
                }

            }
        }
        .alert("Şeytan kurtarabilmek için öncelikle melek olmalısınız", isPresented: $showAlert) {
            Button {
                self.showAlert = false
            } label: {
                Text("Tamam")
            }

        }
    }
    
    func isItDevil() {
        Firestore.firestore().collection("Devils").addSnapshotListener { snap, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                if doc.documentID == Auth.auth().currentUser?.uid {
                    self.isItDevilPermision = true
                    print("I am fucling devil")
                }
            }
        }
    }
    
    func listenAngel() {
        let ref = Firestore.firestore()
//        ref.collection("Devils").document(userID).addSnapshotListener { doc, err in
//            if err == nil {
//                if let classTitle = doc?.get("class") as? String {
//                    if let point = doc?.get("point") as? Int {
//                        if let timeStamp = doc?.get("timeStamp") as? Int {
//                            if let title = doc?.get("title") as? String {
//                                self.classTitle = classTitle
//                                self.point = point
//                                self.timeStamp = timeStamp
//                                self.request = title
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        ref.collection("Devils").document(userID).addSnapshotListener { doc, err in
            if let error = err {
                print(error.localizedDescription)
            } else {
                classTitle = doc?.get("class") as? String ?? ""
                point = doc?.get("point") as? Int ?? 0
                timeStamp = doc?.get("timeStamp") as? Int ?? 0
                request = doc?.get("title") as? String ?? ""
                
                
            }
            
            
        }
        
        
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let firstName = doc?.get("firstName") as? String {
                    if let lastName = doc?.get("firstName") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let nickname = doc?.get("nickname") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        self.firstName = firstName
                                        self.lastName = lastName
                                        self.pfImage = pfImage
                                        self.token = token
                                        self.nickname = nickname
                                        self.level = level
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
