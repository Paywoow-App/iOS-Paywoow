//
//  MyStreamers.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/14/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyStreamerRequests : View{
    @Environment(\.presentationMode) var present
    @StateObject var requests = MyStreamerRequestStore()
    @StateObject var researcher = StreamerResearcher()
    @StateObject var userStore = UserInfoStore()
    @StateObject var invites = SentStreamerInviteStore()
    @State private var selection = 0
    @State private var search : String = ""
    @State private var showSearch : Bool = false
    @State private var sentInvitesUserId : [SearchStreamerModel] = []
    
    @State private var showAlert = false
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){

                HStack{
                    
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    }

                    
                    Text("My Streamer Request")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    if self.selection == 1 {
                        Button {
                            self.showSearch.toggle()
                        } label: {
                            Text("Davet Gönder")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                }
                .padding([.horizontal, .top])
                
                
                HStack{
                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Başvuranlar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                        else {
                            Text("Başvuranlar")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("Davet Edilenler")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                        else {
                            Text("Davet Edilenler")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                
                
                if self.selection == 0 {
                    if self.requests.streamer.isEmpty {
                        
                        Spacer()
                        
                        Image("emptyStreamer")
                            .resizable()
                            .scaledToFit()
                            .padding(.all)
                        
                        Text("if any user want be your streammer, you will see here.")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                        
                        Spacer()
                    }
                    else {
                        
                        ScrollView(showsIndicators: false){
                            ForEach(self.requests.streamer){ item in
                                MyStreamersRequestsContent(userID : item.streamerID, timeDate: item.timeDate)
                            }
                        }
                        
                    }
                }
                
                else if self.selection == 1 {
                    
                    
                    if self.invites.invites.isEmpty {
                        Spacer()
                        
                        Image("emptyStreamer")
                            .resizable()
                            .scaledToFit()
                            .padding(.all)
                        
                        Text("Eğer bir yayıncıya davet gönderir isen buradan kontrol edebilirsin!")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                        
                        Spacer()
                    }
                    else {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(self.invites.invites) { item in
                                WaitingStreamersContent(firstName: item.firstName, lastName: item.lastName, nickname: item.nickname, pfImage: item.pfImage, token: item.token, level: item.level, userId: item.userId, platformId: item.platformId)
                            }
                        }
                    }
                }
                
                
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Ok")){
                self.present.wrappedValue.dismiss()
            })
        }
        .popover(isPresented: $showSearch) {
            SearchStreamerView()
        }
    }
}

struct WaitingStreamersContent: View {
    @State var firstName : String
    @State var lastName : String
    @State var nickname : String
    @State var pfImage : String
    @State var token : String
    @State var level : Int
    @State var userId : String
    @State var platformId : String
    var body : some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 12){
                
                Text(nickname)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                
                Text("ID: \(platformId)")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                
            }
            
            
            Spacer(minLength: 0)
            
            Text("Davet Gönderildi")
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
    }
}
