//
//  AgencyManagerGroupMessageContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/5/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import AVFoundation
import AVKit

struct AgencyManagerGroupMessageContent: View {
    @Binding var agencyID: String
    @State var docID : String
    @State var images : [String]
    @State var isRead : [String]
    @State var sender : String
    @State var message : String
    @State var timeStamp : Int
    
    @State private var dateTime : String = ""
    @State private var isStreamerDemo : Bool = false
    @State private var showAllImages : Bool = false
    @State private var ref = Firestore.firestore()
    
    @State private var streamerCity : String = ""
    @State private var streamerDemoView : String = ""
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var streamerMonth : String = ""
    @State private var streamerProcess : Int = 0
    @State private var streamerID : String = ""
    @State private var streamerPlatform : String = ""
    @State private var streamerTimeStamp : Int = 0
    @State private var streamerYear : String = ""
    
    var body: some View {
        VStack{
            

                if sender == Auth.auth().currentUser!.uid {
                    if self.streamerID != "" {
                        HStack{
                            Spacer(minLength: 0)
                            
                            VStack(alignment: .center, spacing: 12){
                                  VideoPlayer(player: AVPlayer(url: URL(string: streamerDemoView)!))
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.4)
                                
                                
                                Text("\(firstName) \(lastName)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                
                                Text("ID: \(streamerID)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                
                                if self.streamerProcess == 0 {
                                    Text("Beklemede")
                                        .foregroundColor(.init(hex: "#62BDFF"))
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                                else if self.streamerProcess == 1 {
                                    Text("Onaylandı")
                                        .foregroundColor(.init(hex: "#00FFFF"))
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                                else if self.streamerProcess == 2 {
                                    Text("Reddedildi")
                                        .foregroundColor(.init(hex: "#FF6262"))
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                }
                                
                            }
                            .padding(.all, 10)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    else {
                        
                            HStack{
                                Spacer(minLength: UIScreen.main.bounds.width * 0.2)
                                VStack(alignment: .trailing, spacing: 10){
                                    if message != "" {
                                        ZStack{
                                            Image("bubble")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(Color.white.opacity(0.2))
                                                .cornerRadius(radius: 12, corners: [.topLeft, .topRight, .bottomLeft])
                                            
                                            Text(message)
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .padding(.all, 10)
                                                .layoutPriority(1)
                                                .onAppear{
                                                    findStreamerDemo()
                                                }
                                        }
                                        .padding(.trailing)
                                        
                                        
                                        if images.isEmpty {
                                            Text(dateTime)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 10))
                                                .padding(.trailing)
                                        }
                                    }
                                    
                                    if !self.images.isEmpty {
                                        if !showAllImages {
                                            ZStack{
                                                WebImage(url: URL(string: images[0]))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                                    .clipped()
                                                    .cornerRadius(radius: 12, corners: .allCorners)
                                                
                                                if images.count > 1 {
                                                    WebImage(url: URL(string: images[1]))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                                        .clipped()
                                                        .cornerRadius(radius: 12, corners: .allCorners)
                                                        .offset(x: -10, y: 10)
                                                }
                                                
                                                if images.count > 2 {
                                                    WebImage(url: URL(string: images[2]))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                                        .clipped()
                                                        .cornerRadius(radius: 12, corners: .allCorners)
                                                        .offset(x: -20, y: 20)
                                                }
                                            }
                                            .onTapGesture {
                                                self.showAllImages.toggle()
                                                haptic(style: .rigid)
                                            }
                                            .padding(.trailing)
                                        }
                                        else {
                                            ForEach(images, id: \.self) { item in
                                                WebImage(url: URL(string: item))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(radius: 12, corners: [.topLeft, .topRight, .bottomLeft])
                                                    .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                                                    .onTapGesture(count: 2) {
                                                        self.showAllImages.toggle()
                                                        haptic(style: .light)
                                                    }
                                            }
                                            .padding(.trailing)
                                        }
                                        
                                        if showAllImages {
                                            Text(dateTime)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 10))
                                                .padding(.trailing)
                                                .padding(.bottom)
                                        }
                                        else {
                                            Text(dateTime)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 10))
                                                .padding(.trailing)
                                                .padding(.top)
                                                .padding(.bottom)
                                        }
                                    }
                                    
                                }
                                .contextMenu{
                                    if message != "" {
                                        Button {
                                            self.ref.collection("Agencies").document(agencyID).collection("Chat").document(docID).setData(["message" : ""], merge: true)
                                        } label: {
                                            Label("Mesajı Sil", systemImage: "text.badge.xmark")
                                        }
                                    }
                                    
                                    if !images.isEmpty {
                                        Button {
                                            self.ref.collection("Agencies").document(agencyID).collection("Chat").document(docID).setData(["images" : []], merge: true)
                                        } label: {
                                            Label("Resimleri Sil", systemImage: "rectangle.badge.xmark")
                                        }
                                    }
                                    
                                    if !images.isEmpty && self.message != "" {
                                        Button {
                                            self.ref.collection("Agencies").document(agencyID).collection("Chat").document(docID).delete()
                                        } label: {
                                            Label("Mesaj ve Resimleri Sil", systemImage: "xmark.circle")
                                        }
                                    }
                                }
                               
                            }

                            .onAppear{
                                timeStampToDate()
                            }
                            
                        
                    }
                }
                else { //MARK: non current user id
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 10){
                            if self.message != "" {
                                ZStack{
                                    Image("bubble")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color.black.opacity(0.2))
                                        .cornerRadius(radius: 12, corners: [.topLeft, .topRight, .bottomRight])
                                    
                                    Text(message)
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .padding(.all, 10)
                                        .layoutPriority(1)
                                        
                                }
                                .padding(.leading)
                                
                                if images.isEmpty {
                                    Text(dateTime)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                        .padding(.leading)
                                }
                            }
                            
                            if !self.images.isEmpty {
                                if !showAllImages {
                                    ZStack{
                                        WebImage(url: URL(string: images[0]))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                            .clipped()
                                            .cornerRadius(radius: 12, corners: .allCorners)
                                        
                                        if images.count > 1 {
                                            WebImage(url: URL(string: images[1]))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                                .clipped()
                                                .cornerRadius(radius: 12, corners: .allCorners)
                                                .offset(x: 10, y: 10)
                                        }
                                        
                                        if images.count > 2 {
                                            WebImage(url: URL(string: images[2]))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width * 0.7, height: 100)
                                                .clipped()
                                                .cornerRadius(radius: 12, corners: .allCorners)
                                                .offset(x: 20, y: 20)
                                        }
                                    }
                                    .onTapGesture {
                                        self.showAllImages.toggle()
                                        haptic(style: .rigid)
                                    }
                                    .padding(.leading)
                                }
                                else {
                                    ForEach(images, id: \.self) { item in
                                        WebImage(url: URL(string: item))
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(radius: 12, corners: [.topLeft, .topRight, .bottomRight])
                                            .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                                            .onTapGesture(count: 2) {
                                                self.showAllImages.toggle()
                                                haptic(style: .light)
                                            }
                                    }
                                    .padding(.leading)
                                }
                                
                                if showAllImages {
                                    Text(dateTime)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                        .padding(.leading)
                                        .padding(.bottom)
                                }
                                else {
                                    Text(dateTime)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                        .padding(.leading)
                                        .padding(.top)
                                        .padding(.bottom)
                                }
                            }
                            
                        }
                        
                        
                        Spacer(minLength: UIScreen.main.bounds.width * 0.2)
                    }
                    .onAppear{
                        timeStampToDate()
                    }
                }
            
        }
        .onAppear{
            findStreamerDemo()
        }
    }
    
    func timeStampToDate(){
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MMMM - HH:mm"
        self.dateTime = formatter.string(from: date)
    }
    
    func findStreamerDemo(){
        if self.message != "" {
            
                let ref = Firestore.firestore()
                ref.collection("Agencies").document(agencyID).collection("StreamerDemo").document(message).addSnapshotListener { doc, err in
                    if err == nil {
                        if let city = doc?.get("city") as? String {
                            if let demoVideo = doc?.get("demoVideo") as? String {
                                if let firsName = doc?.get("firstName") as? String {
                                    if let lastName = doc?.get("lastName") as? String {
                                        if let month = doc?.get("month") as? String {
                                            if let process = doc?.get("process") as? Int {
                                                if let streamerID = doc?.get("streamerID") as? String {
                                                    if let streamerPlatform = doc?.get("streamerPlatform") as? String {
                                                        if let timeStamp = doc?.get("timeStamp") as? Int {
                                                            if let year = doc?.get("year") as? String {
                                                                self.streamerCity = city
                                                                self.streamerDemoView = demoVideo
                                                                self.firstName = firsName
                                                                self.lastName = lastName
                                                                self.streamerMonth = month
                                                                self.streamerYear = year
                                                                self.streamerID = streamerID
                                                                self.streamerPlatform = streamerPlatform
                                                                self.streamerTimeStamp = timeStamp
                                                                self.streamerProcess = process
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
