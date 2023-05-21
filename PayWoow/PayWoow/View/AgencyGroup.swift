//
//  AgencyGroup.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/1/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI
import Lottie

struct AgencyGroup: View {
    @State var fetchedAgencyName: String = ""
    @State private var slider1Check : String = ""
    //Store
    @StateObject var groupInfoStore = GroupMessageStore()
    @StateObject var userStore = UserInfoStore()
    @StateObject var pkStore = PKStoreOLD()
    @StateObject var swapStore = GroupSwapUserStore()
    @StateObject var messageStore = DirectMessageUserStore()
    @StateObject var tokenResearcher = TokenResearcher()
    
    //Externals
    @State private var inputMessage = ""
    @State private var showIndicators = false
    @State private var toAgencyInfo = false
    @State private var showSlider = false
    @State private var showSuccessSwap = false
    @State private var specialMessanger = false
    @State private var showReporter = false
    @State private var reportMessage: String = "I'm reporting because"
    @Environment(\.presentationMode) var present
    @Environment(\.colorScheme) var colorScheme
    
    
    // Special Reply
    @State private var specialReply_userId = ""
    @State private var toSpecialChat = false
    
    //Reply
    @State private var toReply = false
    @State private var replyMessage = ""
    @State private var replyFullname = ""
    
    //Menu
    @State private var openMenu = false
    @State private var toMessages = false
    @State private var showSalaryInfo = false
    @State private var showBanInfo = false
    @State private var showRules = false
    @State private var showPKBubble = false
    @State private var showPKRequestDetails = false
    @State private var showSwapList = false
    @State private var showAskSwap = false
    
    // while sending
    @State private var showSwapBubble = false
    
    //Salary
    @State private var maas1 = UIImage(named: "maas1")
    @State private var maas2 = UIImage(named: "maas2")
    @State private var maas3 = UIImage(named: "maas3")
    @State private var maas4 = UIImage(named: "maas4")
    
    //Selections
    @State private var genderSelection = 0
    @State private var notifySelector = false
    @State private var ruleSelector = 0
    @State private var sliderSelector = 0
    
    //PK
    @State private var pk_agencyName: String = ""
    @State private var pk_bigoId : String = ""
    @State private var pk_fullname : String = ""
    @State private var pk_level : Int = 0
    @State private var pk_pfImage : String = ""
    @State private var pk_timeDate : String = ""
    @State private var pk_userId : String = ""
    
    //Swap
    @State private var swap_bigoId : String = ""
    @State private var swap_diamond : Int = 0
    @State private var swap_fullname: String = ""
    @State private var swap_level : Int = 0
    @State private var swap_pfImage : String = ""
    @State private var swap_timeDate : String = ""
    @State private var swap_userId : String = ""
    
    @State private var swapSelectorUserId = ""
    @State private var number = 5000
    @State private var diamondArray : [Int] = [5000,10000,15000,20000,25000,30000,35000,40000, 45000, 50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000,90000,95000, 100000, 150000, 200000]
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(5)
                
                ForEach(groupInfoStore.info){ item in
                    HStack{
                        WebImage(url: URL(string: item.groupImage))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                        
                        Text(item.groupName)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .onTapGesture {
                                self.toAgencyInfo.toggle()
                            }
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            self.openMenu.toggle()
                        } label: {
                            Image(systemName: "rectangle.3.group")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }

                    }
                    .padding(.all, 10)
                    
                }

//                if self.showSlider &&  groupInfoStore.info.isEmpty == false {
//                    
//                    TabView(selection: $sliderSelector){
//                        ForEach(groupInfoStore.info){ item in
//                            VStack{
//                                WebImage(url: URL(string: item.slider1))
//                                    .resizable()
//                                    .scaledToFill()
//                                    
//                                    
//                            }
//                            .clipped()
//                            .cornerRadius(4)
//                            .padding(.all, 10)
//                            .tag(0)
//                            .onAppear{
//                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
//                                    self.sliderSelector = 1
//                                }
//                            }
//                            VStack{
//                                WebImage(url: URL(string: item.slider2))
//                                    .resizable()
//                                    .scaledToFill()
//                                    
//                                    
//                            }
//                            .clipped()
//                            .cornerRadius(4)
//                            .padding(.all, 10)
//                            .tag(1)
//                            .onAppear{
//                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
//                                    self.sliderSelector = 2
//                                }
//                            }
//                            
//                            VStack{
//                                WebImage(url: URL(string: item.slider3))
//                                    .resizable()
//                                    .scaledToFill()
//                                    
//                                    
//                            }
//                            .clipped()
//                            .cornerRadius(4)
//                            .padding(.all, 10)
//                            .tag(2)
//                            .onAppear{
//                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
//                                    self.sliderSelector = 3
//                                }
//                            }
//                            
//                            VStack{
//                                WebImage(url: URL(string: item.slider4))
//                                    .resizable()
//                                    .scaledToFill()
//                                    
//                                    
//                            }
//                            .clipped()
//                            .cornerRadius(4)
//                            .padding(.all, 10)
//                            .tag(3)
//                            .onAppear{
//                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
//                                    self.sliderSelector = 0
//                                }
//                            }
//                            
//                        }
//                    }
//                    .frame(height: 200)
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                }
//                
//                if self.showSlider == true {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(Color.black)
//                            .opacity(0.15)
//                        
//                        Button{
//                            self.showSlider.toggle()
//                        } label: {
//                            Image(systemName: "chevron.up")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.white)
//                                .frame(width: 20, height: 10)
//                        }
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 20)
//                }
//                
//                else {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 4)
//                            .fill(Color.black)
//                            .opacity(0.15)
//                        
//                        Button{
//                            self.showSlider.toggle()
//                        } label: {
//                            Image(systemName: "chevron.down")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.white)
//                                .frame(width: 20, height: 10)
//                        }
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 20)
//                }
                
                
                ScrollView(showsIndicators: false){
                    LazyVStack{
                        ForEach(groupInfoStore.message){ item in
                            if self.genderSelection == 0 {
                                AgencyMessageContent(fullname: item.fullname, isRead: "", message: item.message, month: item.month, pfImage: item.pfImage, platformId: item.platformId, time: item.time, timeDate: item.timeDate, userID: item.userId, addedUser: item.addedUser, level: item.level)
                                .contextMenu{
                                    if item.userId != Auth.auth().currentUser!.uid {
                                        
                                            Button{
                                                toReply.toggle()
                                                self.replyMessage = item.message
                                                self.replyFullname = item.fullname
                                            } label: {
                                                Label("Reply", systemImage: "arrowshape.turn.up.backward")
                                            }
                                            
                                            Button{
                                                self.specialReply_userId = item.userId
                                                if self.specialReply_userId == item.userId {
                                                    self.toSpecialChat.toggle()
                                                }
                                            } label: {
                                                Label("Special Repy", systemImage: "arrowshape.turn.up.right")
                                            }
                                            
                                            
                                        
                                            
                                            Button{
                                                let ref = Firestore.firestore()
                                                
                                                let timeDateC = Date()
                                                let timeDateFormatter = DateFormatter()
                                                timeDateFormatter.dateStyle = .full
                                                timeDateFormatter.timeStyle = .full
                                                let timeDate = timeDateFormatter.string(from: timeDateC)
                                                 
                                                let request = [
                                                    "bigoId" : userStore.bigoId,
                                                    "fullname" : "\(userStore.firstName) \(userStore.lastName)",
                                                    "level" : userStore.level,
                                                    "pfImage" : userStore.pfImage,
                                                    "timeDate" : timeDate,
                                                    "userId" : Auth.auth().currentUser!.uid
                                                ] as [String : Any]
                                                
                                                ref.collection("Groups").document("BigoLive").collection(fetchedAgencyName).document("GroupInfo").collection("Users").document(item.userId).collection("PK").addDocument(data: request)
                                            } label: {
                                                
                                                Label("Submit PK Request", image: "pkDark")

                                                    
                                            }
         
                                            Button{
                                                showAskSwap.toggle()
                                                self.swapSelectorUserId = item.userId
                                            } label: {
                                                Label("Submit Swap Request", systemImage: "repeat")
                                            }
                                            
                                            Button{
                                                self.showReporter.toggle()
                                            } label: {
                                                Label("Report", systemImage: "exclamationmark.triangle")
                                            }
                                            
                                            
                                    }
                                    
                                   
                                    if item.userId == Auth.auth().currentUser!.uid {
                                        Section {
                                            Button{
                                                let ref = Firestore.firestore()
                                                ref.collection("Groups").document("BigoLive").collection(fetchedAgencyName).document(item.messageId).delete()
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                            }
                            else if self.genderSelection == 1 {
                                if item.gender == "Kadın" {
                                    AgencyMessageContent(fullname: item.fullname, isRead: "", message: item.message, month: item.month, pfImage: item.pfImage, platformId: item.platformId, time: item.time, timeDate: item.timeDate, userID: item.userId, addedUser: item.addedUser, level: item.level)
                                }
                            }
                            else if  self.genderSelection == 2 {
                                if item.gender == "Erkek" {
                                    AgencyMessageContent(fullname: item.fullname, isRead: "", message: item.message, month: item.month, pfImage: item.pfImage, platformId: item.platformId, time: item.time, timeDate: item.timeDate, userID: item.userId, addedUser: item.addedUser, level: item.level)
                                }
                            }
                        }
                    }
                }
                
                
                if self.toReply == true {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
                        
                        HStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                                .frame(width: 2)
                            
                            VStack(alignment: .leading){
                                Text(replyFullname)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .bold()
                                
                                Text(replyMessage)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .lineLimit(1)
                            }
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.trailing)

                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 45)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.5))
                    
                    HStack{
                        TextField("Type Message", text: $inputMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .colorScheme(.dark)
                        
                        if self.showIndicators == true {
                            ProgressView()
                                   .colorScheme(.dark)
                                   .padding(.leading, 55)
                                   .onAppear{
                                       DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                           let timeC = Date()
                                           let timeFormatter = DateFormatter()
                                           timeFormatter.dateFormat = "HH:mm"
                                           let time = timeFormatter.string(from: timeC)
                                           
                                           let monthC = Date()
                                           let monthFormatter = DateFormatter()
                                           monthFormatter.dateFormat = "MMMM"
                                           let month = monthFormatter.string(from: monthC)
                                           
                                           let timeDateC = Date()
                                           let timeDateFormatter = DateFormatter()
                                           timeDateFormatter.dateStyle = .full
                                           timeDateFormatter.timeStyle = .medium
                                           timeDateFormatter.locale = Locale(identifier: "tr_TRPOSIX")
                                           let timeDate = timeDateFormatter.string(from: timeDateC)
                                           
                                           let fullname = "\(userStore.firstName) \(userStore.lastName)"
                                           
                                           if self.replyMessage != "" {
                                               let reply = "\(replyFullname) 'ın ,\(replyMessage) 'ına Yanıt Olarak:\n\(inputMessage)"
                                               sendMessage(gender: userStore.gender, message: reply, month: month, platformId: userStore.bigoId, fullname: fullname, pfImage: userStore.pfImage, time: time, timeDate: timeDate, userId: Auth.auth().currentUser!.uid, level: userStore.level, agencyName: self.fetchedAgencyName)
                                               self.replyMessage = ""
                                               self.toReply.toggle()
                                           }
                                           else {
                                               sendMessage(gender: userStore.gender, message: inputMessage, month: month, platformId: userStore.bigoId, fullname: fullname, pfImage: userStore.pfImage, time: time, timeDate: timeDate, userId: Auth.auth().currentUser!.uid, level: userStore.level, agencyName: self.fetchedAgencyName)
                                           }
                                           
                                           self.inputMessage = ""
                                           self.showIndicators = false
                                       }
                                   }
                        }
                        else {
                            if self.inputMessage != "" && self.inputMessage != " " && self.inputMessage != "  " && self.inputMessage != "   " && self.inputMessage != "    " && self.inputMessage != "     " && self.inputMessage != "      " && self.inputMessage != "       " && self.inputMessage != "        " && self.inputMessage != "         " && self.inputMessage != "          "{
                                Button{
                                    self.showIndicators = true
                                } label: {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            else {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 20, height: 20)
                            }
                        }

                    }
                    .padding(.horizontal)
                }
                .frame(height: 40)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                


            }


            // MARK: Menu
            if self.openMenu == true {
                
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.7))
                        
                        VStack(spacing: 20){
                            Button {
                                self.notifySelector.toggle()
                                haptic(style: .rigid)
                            } label: {
                                if self.notifySelector {
                                    Image(systemName: "bell.slash.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.red)
                                        .frame(width: 25, height: 25)
                                }
                                else {
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                }
                            }.padding(.top)
                            
                            
                            
                            Button {
                                if self.genderSelection == 0 {
                                    self.genderSelection = 1
                                }
                                else if self.genderSelection == 1 {
                                    self.genderSelection = 2
                                }
                                else if self.genderSelection == 2 {
                                    self.genderSelection = 0
                                }
                                self.openMenu.toggle()
                                haptic(style: .rigid)
                            } label: {
                                if self.genderSelection == 0 {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25)
                                }
                                else if self.genderSelection == 1 {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.pink)
                                        .frame(width: 25, height: 25)
                                }
                                else if self.genderSelection == 2 {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.blue)
                                        .frame(width: 25, height: 25)
                                }
                            }
                            
                            Button {
                                self.openMenu.toggle()
                                self.showSalaryInfo.toggle()
                                haptic(style: .rigid)
                            } label: {
                                Text("$")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)
                                    .scaleEffect(1.6)
                            }
                            
                            
                            Button {
                                self.openMenu.toggle()
                                self.showBanInfo.toggle()
                                haptic(style: .rigid)
                            } label: {
                                Image("banned")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .scaleEffect(1)
                            }
                          
                            
                            
                            Button {
                                self.openMenu.toggle()
                                self.showRules.toggle()
                                haptic(style: .rigid)
                            } label: {
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                self.openMenu.toggle()
                                self.showPKBubble.toggle()
                                haptic(style: .rigid)
                            } label: {
                                ZStack{
                                    Text("PK")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.heavy)
                                    
                                    if self.pkStore.users.isEmpty == false {
                                        ZStack{
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 20, height: 20)
                                            
                                            Text("1")
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                        }
                                        .offset(x: 10, y: -10)
                                    }
                                }
                            }
                            
                            Button {
                                self.openMenu.toggle()
                                self.showSwapList.toggle()
                                haptic(style: .rigid)
                            } label: {
                                ZStack{
                                    Image(systemName: "repeat")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                    
                                    if self.swapStore.users.isEmpty == false {
                                        ZStack{
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 20, height: 20)
                                            
                                            Text("1")
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                        }
                                        .offset(x: 10, y: -10)
                                    }
                                }
                            }
                            
                            Button {
                                self.toMessages.toggle()
                                self.openMenu.toggle()
                                haptic(style: .rigid)
                            } label: {
                                ZStack{
                                    Image(systemName: "bubble.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                 
                                    if self.messageStore.users.isEmpty == false {
                                        ZStack{
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 20, height: 20)
                                            
                                            Text("1")
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                        }
                                        .offset(x: 10, y: -10)
                                    }
                                 
                                }
                            }
                            .padding(.bottom)
                            

                        }
                    }
                    .frame(width: 50, height: 390)
                    .padding(.trailing, 10)
                    .offset(x: 0, y: -30)
                }
            }
            
            
            //MARK: Salary Info
            if self.showSalaryInfo ==  true {
                ZStack{
                    Color.black.opacity(0.0000001).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showSalaryInfo.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            
                            
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            TabView{
                                VStack{
                                    
                                    Text("V System Salary")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .bold()
                                        .padding(.top, 10)
                                    
                                    ScrollView{
                                        Image(uiImage: maas1!)
                                            .resizable()
                                            .scaledToFit()
                                            .contextMenu{
                                                Button{
                                                  let saver = ImageSaver()
                                                    saver.writeToPhotoAlbum(image: maas1!)
                                                } label: {
                                                    Label("Download", systemImage: "square.and.arrow.down")
                                                }
                                            }
                                    }
                                    
                                }
                                
                                VStack{
                                    
                                    Text("Blue System Salary")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .bold()
                                        .padding(.top, 10)
                                    
                                    ScrollView{
                                        Image(uiImage: maas2!)
                                            .resizable()
                                            .scaledToFit()
                                            .contextMenu{
                                                Button{
                                                  let saver = ImageSaver()
                                                    saver.writeToPhotoAlbum(image: maas2!)
                                                } label: {
                                                    Label("Download", systemImage: "square.and.arrow.down")
                                                }
                                            }
                                    }
                                    
                                }
                                
                                VStack{
                                    
                                    Text("Streamer Weekly Salary")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .bold()
                                        .padding(.top, 10)
                                    
                                    ScrollView{
                                        Image(uiImage: maas3!)
                                            .resizable()
                                            .scaledToFit()
                                            .contextMenu{
                                                Button{
                                                  let saver = ImageSaver()
                                                    saver.writeToPhotoAlbum(image: maas3!)
                                                } label: {
                                                    Label("Download", systemImage: "square.and.arrow.down")
                                                }
                                            }
                                    }
                                    
                                }
                                
                                VStack{
                                    
                                    Text("Content Streamer Salary")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .bold()
                                        .padding(.top, 10)
                                    
                                    ScrollView{
                                        Image(uiImage: maas4!)
                                            .resizable()
                                            .scaledToFit()
                                            .contextMenu{
                                                Button{
                                                  let saver = ImageSaver()
                                                    saver.writeToPhotoAlbum(image: maas4!)
                                                } label: {
                                                    Label("Download", systemImage: "square.and.arrow.down")
                                                }
                                            }
                                    }
                                    
                                }
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                        .padding(.bottom)
                    }
                }
            }
            
            if self.showBanInfo == true {
                ZStack{
                    Color.black.opacity(0.00005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showBanInfo.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            VStack{
                                Text("Ban Sebepleri")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                                
                                ScrollView(){
                                    Text("To create a better user experience, BIGO monitors and monitors broadcasts. For this reason, broadcasters are expected to abide by certain rules during broadcasting. We hope that you, our valued partners, can support us and work with us in this direction so that we can provide a better community environment. Important Note: BIGO Management agency group does not have the authority to unban or unban. Only VIP teams provide this support. * Reasons for Ban* 1-) If the broadcaster has a very prominent décolleté or shows nipples while on the air, they will be banned 2-) Broadcasters who insult national leaders, countries and religions, discriminate or talk about terrorism on the air will be permanently banned. 3-) If the broadcaster is live while driving, he will be banned. 4-) If the broadcaster says the name of the competing applications in the live broadcast, he will be banned. 5-) If the broadcaster swears or insults BIGO or BIGO Management while on the air, he will be permanently banned. 6-) Publishers who are found to be underage or who show children or babies during the broadcast will be banned. 7-) If the broadcaster acts in any way that endanger his security during the live broadcast, he will be permanently banned. 8-) If the broadcaster is playing Greedy BIGO, Yummy BIGO or Fisher BIGO while it is live, it will get a global ban. 9-) Smoking or hugging, drinking alcohol, using drugs or exhibiting drug behavior in BIGO are grounds for ban.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .fontWeight(.light)
                                }
                                
                            }
                            .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                        .padding(.bottom)
                    }
                }
            }
            
            if self.showRules == true {
                ZStack{
                    Color.black.opacity(0.00005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showRules.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            VStack{
                                if self.ruleSelector == 0 {
                                    Text("Quota Rules")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                }
                                else if self.ruleSelector == 1 {
                                    Text("Transfer Rules")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                }
                                else if self.ruleSelector == 2 {
                                    Text("What is PK")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                }
                                
                                
                                TabView(selection: $ruleSelector){
                                    VStack{
                                        ScrollView(showsIndicators: false){
                                            
                                            Text("1-) A publisher who collects more than 75 percent of its quota from other publishers does not deserve a commission and its active publishing status is lost. This situation is called cross-support. Publishers who do not receive commissions due to cross-support are reported to the agencies. These publishers need to go through the demo again.\n2-) Publishers who fill 75 percent of their quota in the last three days of the month do not deserve a salary and their active publishing status is lost. These publishers need to go through the demo again.\n3-) Publishers who do not make a quota for three consecutive months will lose their active publishing status. These publishers are shared with you in the first week of each month in qualifying lists, and you are expected to re-demode themselves as soon as possible. The publisher that does not re-demo will receive a commission if they make a quota the following month. However, they will not be counted as a publisher in the following months. Publishers on the qualifying list are not disconnected from their agency. Content publishers will not be included in the elimination list.\n4-) When the broadcaster whose broadcasting has been dropped passes the demo again, the commission system will be reset to the Blue system.\n5-) Maximum 60% of the quota of the publishers who are in the monthly Blue or V system can be overseas origin beans. If it is between 60%-80%, the publisher and agency will receive a half commission; In case of 80% or more of overseas sourced beans, the publisher and agency commission is cancelled. Publishers can see what percentage of the gifts discarded from their own data are of overseas origin.")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                                .fontWeight(.light)
                                        }
                                    }
                                    .tag(0)
                                    
                                    VStack{
                                        ScrollView(showsIndicators: false){
                                            
                                            Text("1-) Transfer Rules BIGO publishers find themselves outside of BIGO and work depending on the agencies that recruit in BIGO. Unless there is any negligence or abuse, they are not transferred from their agency. If an agency transfers a publisher without the permission of the original agency, these rules should be followed. Important note: Eliminated publishers are not allowed to open a second account and work with other agencies. If a violation of this rule is detected, the publisher's account will be banned and the publisher will not receive that month's salary 1-) The Publisher whose Transfer is Requested Must Meet the Conditions\n- The publisher must have worked in their own agency for at least 6 months.\n- The publisher has 120K beans in any month in the last 3 months must have collected. The publisher must fulfill both conditions. Transfer Rules\n2-) Transfer Fee The new agency has to pay the publisher's highest salary in the last 6 months as the transfer fee to the old agency. Example: If the publisher's highest salary in the last 6 months is $3,240, the publisher's transfer fee is $3,240. Payment Method: Upon request, the transfer fee can be deducted from the new agency's premium and added to the old agency's premium.\n3-) Transfer Application and Process - Publisher or new agency applies to BIGO by the end of the 21st of each month - BIGO ensures that the necessary conditions for the transfer of the publisher are met. checks. -If the publisher meets the conditions for the transfer, Bigo contacts both agencies. - BIGO informs the publisher about the results. Note: The salary of the month for which the publisher applies for the transfer is sent to their new agency, but the commission is sent to the old agency.")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                                .fontWeight(.light)
                                        }
                                    }
                                    .tag(1)
                                    
                                    
                                    VStack{
                                        ScrollView(showsIndicators: false){
                                            
                                            Text("Events\nPlayer-killer is an event organized by the content and family team. It can be called a competition of two publishers. By participating in these PKs organized by the management, your publishers can have the rewards that the management organizes for each event. Also, PKs are an important step towards fulfilling your publishers' monthly quotas and getting recognized. PK Rules Many events are held every month. These events are shared as announcements in agency groups. All you have to do is to read the PK rules and content carefully and submit the ID and Level of your eligible publishers. PK announcements are shared two days before PKs. You have to send the ID and level of the publishers you want to participate in the PKs after the announcements made. If your publishers' availability is predetermined, you can also specify a specific PK date; The relevant person from the content team will take the necessary notes. If the Bigo official did not say 'We have received a note' after transmitting the ID and level, your publisher has not been noted and you need to send the ID again. If you forward it again, you can tag the relevant agency manager who made the announcement in the groups. The process will be followed closely by the relevant manager.")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                                .fontWeight(.light)
                                        }
                                    }
                                    .tag(2)
                                    
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                
                            }
                            .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                        .padding(.bottom)
                    }
                }
            }
            
            if self.showPKBubble == true {
                ZStack{
                    Color.black.opacity(0.000005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showPKBubble.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            VStack{
                                HStack{
                                
                                    Text("PK Requests")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .bold()
                                    Spacer()
                                }
                                
                                ScrollView{
                                    ForEach(pkStore.users){ req in
                                        PKRequestContentOld(bigoId: req.bigoId, fullname: req.fullname, level: req.level, pfImage: req.pfImage, timeDate: req.timeDate, userId: req.userId)
                                            .onTapGesture {
                                                self.pk_bigoId = req.bigoId
                                                self.pk_fullname = req.fullname
                                                self.pk_level = req.level
                                                self.pk_pfImage = req.pfImage
                                                self.pk_timeDate = req.timeDate
                                                self.pk_userId = req.userId
                                                showPKRequestDetails.toggle()
                                                showPKBubble.toggle()
                                            }
                                            
                                    }
                                    
                                    
                                    if self.pkStore.users.isEmpty == true {
                                        VStack(spacing: 10){
                                            
                                            Text("Oops..")
                                                .foregroundColor(.black)
                                                .bold()
                                            
                                            Text("You have not any request")
                                                .foregroundColor(.black)
                                                .bold()
                                        }
                                        .frame(height: 300)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                        .padding(.bottom)
                    }
                }
            }
            
            if self.showPKRequestDetails == true {
                ZStack{
                    Color.black.opacity(0.000005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showPKRequestDetails.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            VStack{
                                WebImage(url: URL(string: pk_pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                
                                Text(pk_fullname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.bottom, 5)
                                
                                Text("@\(pk_bigoId)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .fontWeight(.light)
                                
                                LevelContentProfile(level: pk_level)
                                
                                Text("Are you ready to take it down?")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                                
                            
                                
                                HStack{
                                    Button {
                                        self.showPKRequestDetails.toggle()
                                        showPKBubble.toggle()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                                            
                                            Text("Cancel")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    
                                    Button {
                                        
                                        let timeC = Date()
                                        let timeFormatter = DateFormatter()
                                        timeFormatter.dateFormat = "HH:mm"
                                        let time = timeFormatter.string(from: timeC)
                                        
                                        let monthC = Date()
                                        let monthFormatter = DateFormatter()
                                        monthFormatter.dateFormat = "MMMM"
                                        let month = monthFormatter.string(from: monthC)
                                        
                                        let timeDateC = Date()
                                        let timeDateFormatter = DateFormatter()
                                        timeDateFormatter.dateStyle = .full
                                        timeDateFormatter.timeStyle = .medium
                                        let timeDate = timeDateFormatter.string(from: timeDateC)
                                        
                                        let messageId = UUID().uuidString
                                        let pkUserMessage = [
                                            "fullname" : "\(pk_fullname)",
                                            "isRead" : "No",
                                            "message" : "Merhaba! PK İsteğini kabul ettim!",
                                            "month" : month,
                                            "pfImage" : pk_pfImage,
                                            "platformId" : pk_bigoId,
                                            "time" : time,
                                            "timeDate" : timeDate,
                                            "userId" : pk_userId
                                        ]

                                        let myUserDetails = [
                                            "fullname" : "\(userStore.firstName) \(userStore.lastName)",
                                            "isRead" : "Yes",
                                            "lastMessage" : "Merhaba! PK İsteğini kabul ettim!",
                                            "pfImage" : userStore.pfImage,
                                            "platformId" : userStore.bigoId,
                                            "userId" : Auth.auth().currentUser!.uid
                                        ] as [String : Any]
                                        
                                        let pkUserDetails = [
                                            "fullname" : pk_fullname,
                                            "isRead" : "Yes",
                                            "lastMessage" : "Merhaba! PK İsteğini kabul ettim!",
                                            "pfImage" : pk_pfImage,
                                            "platformId" : pk_bigoId,
                                            "userId" : pk_userId
                                        ] as [String : Any]
                                        
                                        let ref = Firestore.firestore()
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(pk_userId).collection("DirectMessage").document(messageId).setData(pkUserMessage)
                                        
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(pk_userId).setData(pkUserDetails, merge: true) // details
                                        
                                        ref.collection("Users").document(pk_userId).collection("DirectMessage").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(messageId).setData(pkUserMessage)

                                        ref.collection("Users").document(pk_userId).collection("DirectMessage").document(Auth.auth().currentUser!.uid).setData(myUserDetails, merge: true) // details
                                        
                                        self.showPKRequestDetails.toggle()
                                        
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black)
                                            
                                            Text("Yes")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                        }
                                    }

                                }
                                .frame(height: 40)
                                
                                
                                
                            }
                            .padding()

                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 320)
                        .padding(.bottom)
                    }
                }
            }
            
            if self.showSwapBubble == true {
                ZStack{
                    Color.black.opacity(0.000005).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showSwapBubble.toggle()
                        }
                    
                    VStack{
                        Spacer()
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            
                            VStack{
                                
                                HStack{
                                    
                                    Text("Swap Request")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .bold()
                                    
                                    Spacer()
                                }
                                
                                WebImage(url: URL(string: swap_pfImage))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    
                                
                                Text(swap_fullname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.bottom, 10)
                                
                                Text("@\(swap_bigoId)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .fontWeight(.light)
                                
                                LevelContentProfile(level: swap_level)
                                
                                HStack{
                                    Image("dia")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("\(swap_diamond)")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                
                                HStack{
                                    Button{
                                        self.showSwapBubble.toggle()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white)
                                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                                            
                                            Text("Cancel")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    
                                    Button{
                                        let ref = Firestore.firestore()
                                        let data = [
                                            "bigoId" : swap_bigoId,
                                            "diamond" : swap_diamond,
                                            "fullname" : swap_fullname,
                                            "level" : swap_level,
                                            "timeDate" : swap_timeDate,
                                            "userId" : swap_userId,
                                            "pfImage" : swap_pfImage,
                                            "secondUserId" : Auth.auth().currentUser!.uid,
                                            "secondPfImage" : userStore.pfImage
                                        ] as [String : Any]
                                        
                                        ref.collection("Groups").document("BigoLive").collection(fetchedAgencyName).document("Swaps").collection("MatchedSwaps").document(swap_userId).setData(data, merge: true)
                                        
                                        ref.collection("Groups").document("BigoLive").collection(fetchedAgencyName).document("Swaps").collection("WaitingSwaps").document(Auth.auth().currentUser!.uid).collection("RequestUsers").document(swap_userId).delete()
                                        
                                        let timeC = Date()
                                        let timeFormatter = DateFormatter()
                                        timeFormatter.dateFormat = "HH:mm"
                                        let time = timeFormatter.string(from: timeC)
                                        
                                        let monthC = Date()
                                        let monthFormatter = DateFormatter()
                                        monthFormatter.dateFormat = "MMMM"
                                        let month = monthFormatter.string(from: monthC)
                                        
                                        let timeDateC = Date()
                                        let timeDateFormatter = DateFormatter()
                                        timeDateFormatter.dateStyle = .full
                                        timeDateFormatter.timeStyle = .medium
                                        let timeDate = timeDateFormatter.string(from: timeDateC)
                                        
                                        let messageId = UUID().uuidString
                                        let pkUserMessage = [
                                            "fullname" : "\(swap_fullname)",
                                            "isRead" : "No",
                                            "message" : "Merhaba! \("💎") \(swap_diamond)  Elmas Takas İsteğini kabul ettim!",
                                            "month" : month,
                                            "pfImage" : swap_pfImage,
                                            "platformId" : swap_bigoId,
                                            "time" : time,
                                            "timeDate" : timeDate,
                                            "userId" : swap_userId
                                        ]

                                        let myUserDetails = [
                                            "fullname" : "\(userStore.firstName) \(userStore.lastName)",
                                            "isRead" : "Yes",
                                            "lastMessage" : "Merhaba! \("💎") \(swap_diamond)  Elmas Takas İsteğini kabul ettim!",
                                            "pfImage" : userStore.pfImage,
                                            "platformId" : userStore.bigoId,
                                            "userId" : Auth.auth().currentUser!.uid
                                        ] as [String : Any]
                                        
                                        let pkUserDetails = [
                                            "fullname" : swap_fullname,
                                            "isRead" : "Yes",
                                            "lastMessage" : "Merhaba! \("💎") \(swap_diamond)  Elmas Takas İsteğini kabul ettim!",
                                            "pfImage" : swap_pfImage,
                                            "platformId" : swap_bigoId,
                                            "userId" : swap_userId
                                        ] as [String : Any]
                                        
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(swap_userId).collection("DirectMessage").document(messageId).setData(pkUserMessage)
                                        
                                        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(swap_userId).setData(pkUserDetails, merge: true) // details
                                        
                                        ref.collection("Users").document(swap_userId).collection("DirectMessage").document(Auth.auth().currentUser!.uid).collection("DirectMessage").document(messageId).setData(pkUserMessage)

                                        ref.collection("Users").document(swap_userId).collection("DirectMessage").document(Auth.auth().currentUser!.uid).setData(myUserDetails, merge: true) // details
                                        
                                        self.showSwapBubble.toggle()
                                        
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black)
                                            
                                            Text("Accept")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    
                                }
                                .frame(height: 50)
                                
                                
                                
                                
                            }
                            .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 380)
                        .padding(.bottom)
                    }
                }
            }
            
            Group{
                if self.showSwapList == true {
                    ZStack{
                        Color.black.opacity(0.000005).edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showSwapList.toggle()
                            }
                        
                        VStack{
                            Spacer()
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                VStack{
                                    HStack{
                                    
                                        Text("Swap Requests")
                                            .foregroundColor(.black)
                                            .font(.system(size: 20))
                                            .bold()
                                        Spacer()
                                    }
                                    
                                    ScrollView{
                                        ForEach(swapStore.users){ req in
                                            GroupSwapContent(bigoId: req.bigoId, diamond: req.diamond, fullname: req.fullname, level: req.level, pfImage: req.pfImage, timeDate: req.timeDate, userId: req.userId)
                                                .onTapGesture {
                                                    swap_bigoId = req.bigoId
                                                    swap_diamond = req.diamond
                                                    swap_fullname = req.fullname
                                                    swap_level = req.level
                                                    swap_pfImage = req.pfImage
                                                    swap_timeDate = req.timeDate
                                                    swap_userId = req.userId
                                                    self.showSwapList.toggle()
                                                    self.showSwapBubble.toggle()
                                                }
                                                
                                        }
                                        
                                        
                                        if self.swapStore.users.isEmpty == true {
                                            VStack(spacing: 10){
                                                
                                                Text("Oops..")
                                                    .foregroundColor(.black)
                                                    .bold()
                                                
                                                Text("You have not any request")
                                                    .foregroundColor(.black)
                                                    .bold()
                                            }
                                            .frame(height: 300)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                            .padding(.bottom)
                        }
                    }
                }
                
                if self.showAskSwap == true {
                    ZStack{
                        Color.black.opacity(0.000005).edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showAskSwap.toggle()
                            }
                        
                        VStack{
                            Spacer()
                                
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                
                                VStack{
                                    HStack{
                                    
                                        Text("Swap Request Amount")
                                            .foregroundColor(.black)
                                            .font(.system(size: 20))
                                            .bold()
                                        
                                        
                                        
                                        Spacer()
                                    }
                                    
                                    
                                    Picker("", selection: $number) {
                                        ForEach(self.diamondArray, id: \.self) {
                                            Text("\($0)")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .colorScheme(.light)
                                    
                                    HStack{
                                        Image("dia")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        
                                        Text("\(number)")
                                            .foregroundColor(.black)
                                            .font(.system(size: 20))
                                            .bold()
                                    }
                                    
                                    HStack{
                                        Button{
                                            self.showAskSwap.toggle()
                                        } label: {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.white)
                                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                                                
                                                Text("Cancel")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                        
                                        Button{
                                            let ref = Firestore.firestore()
                                            
                                            let timeDateC = Date()
                                            let timeDateFormatter = DateFormatter()
                                            timeDateFormatter.dateStyle = .full
                                            timeDateFormatter.timeStyle = .full
                                            let timeDate = timeDateFormatter.string(from: timeDateC)
                                            
                                            let data = [
                                                "bigoId" : userStore.bigoId,
                                                "diamond" : 5000,
                                                "fullname" : "\(userStore.firstName) \(userStore.lastName)",
                                                "level" : userStore.level,
                                                "pfImage" : userStore.pfImage,
                                                "timeDate" : timeDate,
                                                "userId" : Auth.auth().currentUser!.uid
                                            ] as [String : Any]
                                            
                                            ref.collection("Groups").document("BigoLive").collection(fetchedAgencyName).document("Swaps").collection("WaitingSwaps").document(swapSelectorUserId).collection("RequestUsers").document(Auth.auth().currentUser!.uid).setData(data, merge: true)
                                            self.showSuccessSwap.toggle()
                                        } label: {
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.black)
                                                    
                                                
                                                Text("Send")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                    }
                                    .frame(height: 50)

                                }
                                .padding()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 400)
                            .padding(.bottom)
                        }
                    }
                }
                
                if showReporter {
                    reporter
                }
            }
        }
        .onAppear{
            groupInfoStore.getData(agency: self.fetchedAgencyName)
        }
        .popover(isPresented: $toAgencyInfo) {
            AgencyInfo(fetchedAgencyName: self.fetchedAgencyName)
        }
        .fullScreenCover(isPresented: $toSpecialChat, content: {
            SpecialChatWriter(senderId: self.$specialReply_userId)
        })
        .popover(isPresented: $toMessages, content: {
            SpecialMessanger()
        })
        .alert(isPresented: $showSuccessSwap) {
            Alert(title: Text("Swap Request was sent"), message: Text("Congratulation 🥳\nI sent the your request to User"), dismissButton: Alert.Button.cancel(Text("Ok"), action: {
                self.showSuccessSwap.toggle()
                self.showAskSwap.toggle()
            }))
        }
    }

    //MARK: Reporter
    var reporter : some View {
        ZStack{
            
            Color.black.opacity(0.0006).edgesIgnoringSafeArea(.all).onTapGesture {
                self.showReporter.toggle()
            }
            
            VStack{
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                    
                    VStack(alignment: .leading){
                     Text("Why you report this user?")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .bold()
                        
                        TextEditor(text: $reportMessage)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .colorScheme(.light)
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                            
                            Text("Send")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                        }
                        .frame(height: 50)
                        
                    }
                    .padding(10)
                }
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
            }
        }
    }
    
}


// MARK: Functions

private func sendMessage(gender: String, message: String, month: String, platformId: String, fullname: String, pfImage: String, time: String, timeDate: String, userId: String, level: Int, agencyName: String){
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MMMM.yyyy - HH:mm.ss"
    formatter.locale = Locale(identifier: "tr_TRPOSIX")
    let fulldate = formatter.string(from: date)
    let data = [
        "gender" : gender,
        "message" : message,
        "month" : month,
        "platformId" : platformId,
        "fullname" : fullname,
        "pfImage" : pfImage,
        "time" : time,
        "timeDate" : timeDate,
        "userId" : userId,
        "level" : level,
        "addedUser" : "",
        "fulldate" : fulldate
    ] as [String : Any]
    let ref = Firestore.firestore()
    ref.collection("Groups").document("BigoLive").collection(agencyName).addDocument(data: data)
}



