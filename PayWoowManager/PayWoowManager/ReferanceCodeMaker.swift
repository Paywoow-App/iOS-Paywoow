//
//  ReferanceCodeMaker.swift
//  PayWoow Manager
//
//  Created by İsa Yılmaz on 12/21/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ReferanceCodeMaker : View {
    //researcher
    @State private var userid : String = ""
    @State private var fullname : String = ""
    @State private var bigoId : String = ""
    @State private var referansCode : String = ""
    @State private var showAlert : Bool = false
    @StateObject var userIdResearcher = UserIDResearcher()
    @State private var searchBigoID = false
    @State private var fontSize : CGFloat = CGFloat(18)
    @Environment(\.presentationMode) var present
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10){
                
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(.leading)
                    
                        Text("Referans Kod Oluşturucu")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                        
                    Spacer()
                }
                .padding(.vertical)
                
                ScrollView(showsIndicators: false) {
                    
                    Spacer()
                    
                    ZStack{
                        
                        Image("defRefPF")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                        
                        WebImage(url: URL(string: self.userIdResearcher.pfImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                            
                    }.padding(.bottom, 20)
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.2))
                            
                        
                        TextField("Bigo ID", text: $bigoId)
                            .foregroundColor(.white)
                            .font(.system(size: fontSize))
                            .padding(.horizontal)
                            .onChange(of: self.bigoId) { val in
                                if val != "" {
                                    self.userIdResearcher.getData(bigoID: val)
                                }
                            }
                    }
                    .frame(height: 50)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)

                    if self.userIdResearcher.fullname != "" {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                                
                            
                            HStack{
                                Text(self.userIdResearcher.userid)
                                    .foregroundColor(.white)
                                    .font(.system(size: fontSize))
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                                
                            
                            HStack{
                                Text(self.userIdResearcher.fullname)
                                    .foregroundColor(.white)
                                    .font(.system(size: fontSize))
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                        
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                                
                            
                            HStack{
                                TextField("Referans Kodu", text: $referansCode)
                                    .foregroundColor(.white)
                                    .font(.system(size: fontSize))
                                    .padding(.horizontal)
                                    .onChange(of: referansCode) { value in
                                        let upper = value.uppercased()
                                        self.referansCode = upper
                                        
                                    }
                                    .keyboardType(.default)
                                    
                                
                                if self.referansCode.count >= 9 {
                                    Button {
                                        let random = Int.random(in: 1111...9999)
                                        let step1 = "\(self.referansCode)\(random)"
                                        self.referansCode = step1
                                        
                                    } label: {
                                        Image(systemName: "shuffle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                            .padding(.trailing)
                                    }
                                }

                            }
                        }
                        .frame(height: 50)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                        
                        if self.referansCode != "" {
                            
                            Button {
                                let ref = Firestore.firestore()
                                let data = [
                                    "contactUserId" : self.userIdResearcher.userid,
                                    "fullname" : self.userIdResearcher.fullname,
                                    "pfImage" : self.userIdResearcher.pfImage,
                                    "referenceCode" : self.referansCode,
                                    "bigoId" : self.userIdResearcher.bigoId
                                ] as [String : Any]
                                
                                ref.collection("Reference").document(referansCode).setData(data, merge: true)
                                
                                ref.collection("Users").document(self.userIdResearcher.userid).setData(["myReferanceCode" : referansCode], merge: true)
                                self.present.wrappedValue.dismiss()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.init(red: 88 / 255, green:  184 / 255, blue: 175 / 255))
                                    
                                    Text("Referans Kodunu Oluştur")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                                .padding(.vertical)
                            }
                        }
                    }

                    
                    Spacer()

                }
            }
        }
    }
}


class UserIDResearcher: ObservableObject {
    @Published var userid : String = ""
    @Published var fullname : String = ""
    @Published var bigoId : String = ""
    @Published var pfImage : String = ""
    
    let ref = Firestore.firestore()
    
    func getData(bigoID : String){
        ref.collection("Users").addSnapshotListener { snap, err in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                for doc in snap!.documents {
                    if let bigoId = doc.get("bigoId") as? String {
                        if bigoId == bigoID {
                            if let firstName = doc.get("firstName") as? String {
                                if let lastName = doc.get("lastName") as? String {
                                    if let pfImage = doc.get("pfImage") as? String {
                                        self.bigoId = bigoId
                                        self.fullname = "\(firstName) \(lastName)"
                                        self.pfImage = pfImage
                                        self.userid = "\(doc.documentID)"
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
