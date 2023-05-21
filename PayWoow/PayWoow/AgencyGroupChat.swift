//
//  AgencyGroupChat.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/12/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct AgencyStreamerChatModel : Identifiable{
    var id = UUID()
    var sender : String
    var message : String
    var isRead : [String]
    var timeStamp : Int
    var index : Int
    var replyMessage : String
    var replyNickname : String
}

struct StreamerListModel: Identifiable {
    var id = UUID()
    var userID : String
    var nickname : String
    var platformID : String
    var token : String
    var pfImage: String
    var level : Int
    var vipType : String
}

struct SalaryInfoModel: Identifiable {
    var id = UUID()
    var title : String
    var image : UIImage
}

struct AgencyGroupRuleModel: Identifiable {
    var id = UUID()
    var title : String
    var desc : String
}

struct PKRequestModel: Identifiable {
    var id = UUID()
    var userID : String
    var deliveredTo : String
    var timeStamp : Int
    var isAccepted : Bool
}


struct PrivateChatUsers: Identifiable {
    var id = UUID()
    var userID : String
    var deliveredTo : String
    var timeStamp : Int
    var docID : String
}

struct GroupSwapRequestModel: Identifiable {
    var id = UUID()
    var userID : String
    var deliveredTo : String
    var timeStamp : Int
    var isAccepted : Bool
    var productType : String
    var product : Int
    var selectedPlatform : String
    var docID : String
}


struct AgencyGroupChat: View {
    @State private var general = GeneralStore()
    @Environment(\.presentationMode) var present
    @Environment(\.colorScheme) var scene
    
    @State var agencyID : String
    @State private var agencyName : String = ""
    @State private var coverImage : String = ""
    @State private var owner : String = ""
    @State private var platform : String = ""
    @State private var streamers : [String] = []
    
    @State private var messageList : [AgencyStreamerChatModel] = []
    @State private var streamerList : [StreamerListModel] = []
    @State private var pkRequestList : [PKRequestModel] = []
    @State private var pkMessageUserList : [PKRequestModel] = []
    @State private var swapRequestList : [GroupSwapRequestModel] = []
    @State private var swapMessageUserList : [GroupSwapRequestModel] = []
    @State private var privateUserList : [PrivateChatUsers] = []
    @State private var inputMessage : String = ""
    @State private var selection : Int = 0
    
    // Menu items
    @State private var notifySelector : Bool = false
    @State private var showMenu : Bool = false
    @State private var genderSelection : Int = 0
    @State private var showSalaryInfo : Bool = false
    @State private var showBanInfo : Bool = false
    @State private var showRules : Bool = false
    @State private var showPKBubble : Bool = false
    
    @State private var toPrivateChat : Bool = false
    @State private var replyDocID : String = ""
    
    @State private var showSwapList : Bool = false
    @State private var toPrivateMessages : Bool = false
    
    //Context Menu
    @State private var showSwapMaker : Bool = false
    @State private var showPKMaker : Bool = false
    
    //Selections
    @State private var pkBubbleSelection : Int = 0
    @State private var swapSelection : Int = 0
    
    //Reply
    @State private var replyMessage : String = ""
    @State private var replyNickname : String = ""
    @State private var showReply : Bool = false
    
    @State private var userID : String = ""
    @State private var nickname : String = ""
    @State private var level : Int = 0
    @State private var vipType : String = ""
    @State private var pfImage : String = ""
    @State private var token : String = ""
    
    //Alerts
    @State private var alertTitle : String = ""
    @State private var alertBody : String = ""
    @State private var showAlert : Bool = false
    
    //external
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if selection == 0 {
                chatBody
            }
            else if selection == 1 {
                infoBody
            }

            if self.showMenu && self.selection == 0 {
                menuBody
            }
            else {
                Spacer().onAppear{
                    self.showMenu = false
                }
            }
            
            if self.showSalaryInfo {
                salaryInfoBody
            }
            
            else if self.showBanInfo {
                banInfoBody
            }
            
            else if self.showRules {
                rulesInfoBody
            }
            else if self.showPKBubble {
                pkRequestBody
            }
            
            else if self.showSwapList {
                swapRequestBody
            }
            
            else if self.toPrivateMessages {
                privateChatListBody
            }
            
            else if self.showSwapMaker {
                GroupSwapMaker(showSwapMaker: $showSwapMaker, userID: $userID, nickname: $nickname, level: $level, vipType: $vipType, pfImage: $pfImage, token: $token, agencyID: $agencyID)
            }
            
            else if self.showPKMaker {
                GroupPKMaker(showPKMaker: $showPKMaker, userID: $userID, nickname: $nickname, level: $level, vipType: $vipType, pfImage: $pfImage, token: $token, agencyID: $agencyID)
            }
        }
        .onAppear{
            getAgencyDetails()
            getChat()
            getPKRequets()
            getSwapRequets()
            getPrivateChatUser()
        }
        .onChange(of: userID) { val in
            if val != "" {
                getSelectedUser()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertBody), dismissButton: Alert.Button.default(Text("Tamam")))
        }
        .fullScreenCover(isPresented: $toPrivateChat) {
            if self.replyDocID == "" {
                GroupPrivateChat(userID: userID, agencyID: agencyID, docID: "", showReply: true, replyMessage: replyMessage, replyNickname: replyNickname)
            }
            else {
                GroupPrivateChat(userID: userID, agencyID: agencyID, docID: replyDocID, showReply: true, replyMessage: replyMessage, replyNickname: replyNickname)
            }
        }
    }
    
    var chatBody: some View {
        VStack(spacing: 0){
            HStack{
                Button {
                    self.present.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(width: 25, height: 25)
                }
                
                Spacer(minLength: 0)
                    
                VStack{
                    AsyncImage(url: URL(string: coverImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                            .colorScheme(.dark)
                            .frame(width: 50, height: 50)
                        
                    }
                    .onChange(of: coverImage) { newValue in
                        print("cover image = \(newValue)")
                    }
                    
                    Text(agencyName)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .onTapGesture {
                    self.selection = 1
                }
                
                Spacer(minLength: 0)
                
                Button {
                    self.showMenu.toggle()
                } label: {
                    Image(systemName: "rectangle.3.group")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 25, height: 25)
                }
            }
            .padding([.horizontal, .top])
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messageList) { item in
                        AgencyStreamerMessageContent(message: item.message, sender: item.sender, isRead: item.isRead, timeStamp: item.timeStamp, replyMessage: item.replyMessage, replyNickname: item.replyNickname)
                            .id(item.index)
                            .onAppear{
                                proxy.scrollTo(item.index)
                            }
                            .contextMenu{
                                
                                Button{
                                    self.replyMessage = item.message
                                    self.userID = item.sender
                                    self.showReply = true
                                } label: {
                                    Label("Reply", systemImage: "arrowshape.turn.up.backward")
                                }
                                .onAppear{
                                    self.getPrivateChatUserForReply(selectedUserID: item.sender)
                                }
                                
                                Button{
                                    self.userID = item.sender
                                    self.replyMessage = item.message
                                    self.toPrivateChat.toggle()
                                } label: {
                                    Label("Special Repy", systemImage: "arrowshape.turn.up.right")
                                }
                                
                                Button{
                                    self.userID = item.sender
                                    self.showPKMaker = true
                                    
                                } label: {
                                    if scene == .dark {
                                        Label("Submit PK Request", image: "pkLight")
                                    }
                                    else {
                                        Label("Submit PK Request", image: "pkDark")
                                    }
                                }
                                
                                Button {
                                    self.userID = item.sender
                                    self.showSwapMaker = true
                                } label: {
                                    Label("Takas Yap", systemImage: "repeat")
                                }
                                
                                Button{
                                    self.alertTitle = "Bildirildi!"
                                    self.alertBody = "Mesaj şikayeti elimize ulaştı. İlginizden dolayı teşekkür ederimaa"
                                    self.showAlert.toggle()
                                } label: {
                                    Label("Report", systemImage: "exclamationmark.triangle")
                                }
                                
                                Button{
                                    self.deleteMessage(docID: "\(item.timeStamp)")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            
            if self.showReply == true {
                HStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 2, height: 40)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(replyNickname)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                        Text(replyMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .lineLimit(1)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        self.userID = ""
                        self.replyNickname = ""
                        self.replyMessage = ""
                        self.showReply = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }

                }
                .padding(.horizontal)
                .padding(.vertical, 15)
                .background{
                    Color.black.opacity(0.5)
                }
            }
            
            Divider()
            
            HStack{
                TextField("Mesaj Yaz", text: $inputMessage)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .colorScheme(.dark)
                
                
                if self.inputMessage != "" {
                    Button {
                        sendMessaga()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.white)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                        }
                        .frame(width: 35, height: 35)
                    }
                }

            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
    
    var infoBody : some View {
        VStack{
            HStack(spacing: 12){
                Button {
                    self.selection = 0
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
                
                Text("Ajans Hakkında")
                    .foregroundColor(.white)
                    .font(.title2)
                
                Spacer(minLength: 0)

            }
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15){
                    HStack{
                        
                        Spacer(minLength: 0)
                        VStack(alignment: .center){
                            AsyncImage(url: URL(string: coverImage)) { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 130, height: 130)
                            } placeholder: {
                                Image("defualtAgency")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 130, height: 130)
                            }
                            
                            Text(agencyName)
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                        }
                        
                        Spacer(minLength: 0)

                    }
                    
                    Text("Kişiler")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .padding(.leading)
                    
                    ForEach(streamerList) { item in
                        HStack{
                            ZStack{
                                AsyncImage(url: URL(string: item.pfImage)) { img in
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 62, height: 62)
                                        .offset(y: 1)
                                } placeholder: {
                                    Image("defualtPf")
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 62, height: 62)
                                        .offset(y: 1)
                                }
                                
                                
                                if  item.vipType == "VIPSILVER" {
                                    LottieView(name: "crown_silver")
                                        .frame(width: 62, height: 62)
                                        .scaleEffect(lottieScale)
                                        .offset(x: 0, y: offsetY)
                                }
                                else if item.vipType == "VIPBLACK" {
                                    LottieView(name: "crown_black")
                                        .frame(width: 62, height: 62)
                                        .scaleEffect(lottieScale)
                                        .offset(x: 0, y: offsetY)
                                }
                                else if item.vipType == "VIPGOLD" {
                                    LottieView(name: "crown_gold")
                                        .frame(width: 62, height: 62)
                                        .scaleEffect(lottieScale)
                                        .offset(x: 0, y: offsetY)
                                }
                                
                                if item.level != 0 {
                                    LevelContentProfile(level: item.level)
                                        .scaleEffect(0.6)
                                        .offset(x: 0, y: 32.5)
                                }
                            }
                            .scaleEffect(0.8)
                            
                            VStack(alignment: .leading, spacing: 7){
                                Text(item.nickname)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                                
                                Text("ID: \(item.platformID)")
                                    .foregroundColor(.white.opacity(0.5))
                                    .font(.system(size: 13))
                            }
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }


                        }
                        .padding(.trailing)
                        .padding(.leading, 10)
                    }
                    
                }
                
            }
        }
    }
    
    var menuBody : some View {
        ZStack{
            
            Color.black.opacity(0.000000004).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showMenu = false
                }
            
            VStack{
                HStack{
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 20){
                        Button {
                            self.notifySelector.toggle()
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
                        }
                        
                        
                        Button {
                            if self.genderSelection < 2 {
                                self.genderSelection = self.genderSelection + 1
                            }
                            else {
                                self.genderSelection = 0
                            }
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
                            self.showMenu.toggle()
                            self.showSalaryInfo.toggle()
                        } label: {
                            Text("$")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.heavy)
                                .scaleEffect(1.6)
                        }
                        
                        Button {
                            self.showMenu.toggle()
                            self.showBanInfo.toggle()
                        } label: {
                            Image("banned")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .scaleEffect(1)
                        }
                        
                        Button {
                            self.showMenu.toggle()
                            self.showRules.toggle()
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        
                        Button {
                            self.showMenu.toggle()
                            self.showPKBubble.toggle()
                        } label: {
                            ZStack{
                                Text("PK")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .fontWeight(.heavy)

                            }
                        }
                        
                        
                        Button {
                            self.showMenu.toggle()
                            self.showSwapList.toggle()
                        } label: {
                            ZStack{
                                Image(systemName: "repeat")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)

                            }
                        }
                        
                        Button {
                            self.toPrivateMessages.toggle()
                            self.showMenu.toggle()
                        } label: {
                            ZStack{
                                Image(systemName: "bubble.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)
                             
                            }
                        }
                    }
                    .padding(.all, 10)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(6)
                    .padding([.trailing, .bottom], 10)
                    .padding(.top, 90)
                }
                
                Spacer(minLength: 0)
            }
        }
    }

    var salaryInfoBody: some View {
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showSalaryInfo = false
                }
            
            VStack{
                Spacer(minLength: 0)
                
                VStack(spacing: 15){
                    TabView(){
                        ForEach(general.salaryInfoStore) { item in
                            VStack{
                                Text(LocalizedStringKey(item.title))
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                
                                Image(uiImage: item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .contextMenu{
                                        Button {
                                            let saver = ImageSaver()
                                            saver.writeToPhotoAlbum(image: item.image)
                                        } label: {
                                            Label("Fotoğraf Kütüphanesine Kaydet", systemImage: "square.and.arrow.down")
                                        }

                                    }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .padding(.all, 15)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.all)
                .frame(height: 400)
            }
        }
    }
    
    var rulesInfoBody: some View {
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showRules = false
                }
            
            VStack{
                Spacer(minLength: 0)
                
                VStack(spacing: 15){
                    TabView(){
                        ForEach(general.rulesInfoList) { item in
                            VStack{
                                Text(LocalizedStringKey(item.title))
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    Text(LocalizedStringKey(item.desc))
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .padding(.all, 15)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.all)
                .frame(height: 400)
            }
        }
    }
    
    var banInfoBody: some View {
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showBanInfo = false
                }
            
            VStack{
                Spacer(minLength: 0)
                
                VStack(spacing: 15){
                    Text("Ban Sebepleri")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    ScrollView(showsIndicators: true){
                        Text("To create a better user experience, BIGO monitors and monitors broadcasts. For this reason, broadcasters are expected to abide by certain rules during broadcasting. We hope that you, our valued partners, can support us and work with us in this direction so that we can provide a better community environment. Important Note: BIGO Management agency group does not have the authority to unban or unban. Only VIP teams provide this support. * Reasons for Ban* 1-) If the broadcaster has a very prominent décolleté or shows nipples while on the air, they will be banned 2-) Broadcasters who insult national leaders, countries and religions, discriminate or talk about terrorism on the air will be permanently banned. 3-) If the broadcaster is live while driving, he will be banned. 4-) If the broadcaster says the name of the competing applications in the live broadcast, he will be banned. 5-) If the broadcaster swears or insults BIGO or BIGO Management while on the air, he will be permanently banned. 6-) Publishers who are found to be underage or who show children or babies during the broadcast will be banned. 7-) If the broadcaster acts in any way that endanger his security during the live broadcast, he will be permanently banned. 8-) If the broadcaster is playing Greedy BIGO, Yummy BIGO or Fisher BIGO while it is live, it will get a global ban. 9-) Smoking or hugging, drinking alcohol, using drugs or exhibiting drug behavior in BIGO are grounds for ban.")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                    }
                }
                .padding(.all, 15)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.all)
                .frame(height: 400)
            }
        }
    }
    
    var pkRequestBody: some View {
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showPKBubble = false
                }
            
            VStack{
                Spacer(minLength: 0)
                
                VStack(spacing: 15){
                    HStack(spacing: 10){
                        Button {
                            self.pkBubbleSelection = 0
                        } label: {
                            if self.pkBubbleSelection == 0 {
                                Text("PK Talepleri")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .fontWeight(.medium)
                            }
                            else {
                                Text("PK Talepleri")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        Button {
                            self.pkBubbleSelection = 1
                        } label: {
                            if self.pkBubbleSelection == 1 {
                                Text("Mesajlar")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                    .fontWeight(.medium)
                            }
                            else {
                                Text("Mesajlar")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        Spacer(minLength: 0)

                    }
                    
                    if self.pkBubbleSelection == 0 {
                        ScrollView(showsIndicators: true){
                            ForEach(pkRequestList){ pk in
                                PKRequestContentNew(userID: pk.userID, agencyID: agencyID, timeStamp: pk.timeStamp, isAccepted: pk.isAccepted)
                            }
                        }
                    }
                    else {
                        ScrollView(showsIndicators: true){
                            ForEach(pkRequestList){ item in
                                if item.isAccepted == true {
                                    PKMessageUsers(userID: item.userID, agencyID: agencyID, timeStamp: item.timeStamp)
                                }
                            }
                            
                            
                            ForEach(pkMessageUserList){ item in
                                if item.isAccepted == true {
                                    PKMessageUsers(userID: item.userID, agencyID: agencyID, timeStamp: item.timeStamp)
                                }
                            }
                        }
                    }
                }
                .padding(.all, 15)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.all)
                .frame(height: 400)
            }
        }
    }
    
    var swapRequestBody: some View {
        
            ZStack{
                
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.showSwapList = false
                    }
                
                VStack{
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 15){
                        HStack(spacing: 10){
                            Button {
                                self.swapSelection = 0
                            } label: {
                                if self.swapSelection == 0 {
                                    Text("Takas İstekleri")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                        .fontWeight(.medium)
                                }
                                else {
                                    Text("Takas İstekleri")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                }
                            }
                            
                            Button {
                                self.swapSelection = 1
                            } label: {
                                if self.swapSelection == 1 {
                                    Text("Mesajlar")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .fontWeight(.medium)
                                        .fontWeight(.medium)
                                }
                                else {
                                    Text("Mesajlar")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                }
                            }
                            
                            Spacer(minLength: 0)

                        }
                        
                        if self.swapSelection == 0 {
                            ScrollView(showsIndicators: true){
                                ForEach(swapRequestList){ swap in
                                    SwapRequestContentGroup(userID: swap.userID, deliveredTo: swap.deliveredTo, timeStamp: swap.timeStamp, isAccepted: swap.isAccepted, productType: swap.productType, product: swap.product, selectedPlatform: swap.selectedPlatform, docID: swap.docID, agencyID: agencyID)
                                }
                            }
                        }
                        else {
                            ScrollView(showsIndicators: true){
                                ForEach(swapRequestList){ item in
                                    if item.isAccepted == true {
                                        SwapMessageUsers(userID: item.userID, agencyID: agencyID, timeStamp: item.timeStamp, docID: item.docID)
                                    }
                                }
                                
                                
                                ForEach(swapMessageUserList){ item in
                                    if item.isAccepted == true {
                                        SwapMessageUsers(userID: item.userID, agencyID: agencyID, timeStamp: item.timeStamp, docID: item.docID)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.all, 15)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.all)
                    .frame(height: 400)
                }
            }
        
    }
    
    var privateChatListBody: some View {
            
                ZStack{
                    
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.toPrivateMessages = false
                        }
                    
                    VStack{
                        Spacer(minLength: 0)
                        
                        VStack(alignment: .leading, spacing: 15){
                            HStack{
                                Text("Özel Mesajlar")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .fontWeight(.medium)
                                
                                Spacer(minLength: 0)
                            }
                            
                            if !self.privateUserList.isEmpty {
                                ScrollView(showsIndicators: true){
                                    ForEach(privateUserList){ chat in
                                        PrivateChatUsersContent(userID: chat.userID, docID: chat.docID, agencyID: agencyID)
                                    }
                                    .padding(.top, 7)
                                }
                            }
                            else {
                                VStack(alignment: .center){
                                    Spacer(minLength: 0)
                                    
                                    Image(systemName: "envelope")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                    
                                    Text("Mesaj Yok")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    
                                    Text("Bir mesajın şuan mevcut değil")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15))
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        .padding(.all, 15)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.all)
                        .frame(height: 400)
                    }
                }
            
        
    }

    
    //MARK: Functions

    func getAgencyDetails(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).addSnapshotListener { doc, err in
            if err == nil {
                if let agencyName = doc?.get("agencyName") as? String {
                    if let coverImage = doc?.get("coverImage") as? String {
                        if let owner = doc?.get("owner") as? String {
                            if let streamers = doc?.get("streamers") as? [String] {
                                if let platform = doc?.get("platform") as? String {
                                    self.agencyName = agencyName
                                    self.coverImage = coverImage
                                    self.owner = owner
                                    self.platform = platform
                                    self.streamers = streamers
                                    getStremaerDetails()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getChat(){
        let ref = Firestore.firestore()
        var  index : Int = 0
        ref.collection("Agencies").document(agencyID).collection("StreamerChat").addSnapshotListener { snap, err in
            if err == nil {
                self.messageList.removeAll()
                for doc in snap!.documents {
                    if let message = doc.get("message") as? String {
                        if let sender = doc.get("sender") as? String {
                            if let isRead = doc.get("isRead") as? [String] {
                                if let timeStamp = doc.get("timeStamp") as? Int {
                                    if let replyMessage = doc.get("replyMessage") as? String {
                                        if let replyNickname = doc.get("replyNickname") as? String {
                                            index = index + 1
                                            let data = AgencyStreamerChatModel(sender: sender, message: message, isRead: isRead, timeStamp: timeStamp, index: index, replyMessage: replyMessage, replyNickname: replyNickname)
                                            self.messageList.append(data)
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
    
    func sendMessaga(){
        let ref = Firestore.firestore()
        let data = [
            "message" : inputMessage,
            "sender" : Auth.auth().currentUser!.uid,
            "isRead" : [Auth.auth().currentUser!.uid],
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "replyMessage" : replyMessage,
            "replyNickname" : replyNickname
        ] as [String : Any]
        
        ref.collection("Agencies").document(self.agencyID).collection("StreamerChat").document("\(Int(Date().timeIntervalSince1970))").setData(data)
        self.inputMessage = ""
        self.replyMessage = ""
        self.replyNickname = ""
        self.showReply = false
    }
    
    func getStremaerDetails(){
        let ref = Firestore.firestore()
        for docID in streamers {
            self.streamerList.removeAll()
            ref.collection("Users").document(docID).addSnapshotListener { doc, err in
                if err == nil {
                    if let nickname = doc?.get("nickname") as? String {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let token = doc?.get("token") as? String {
                                if let platformID = doc?.get("platformID") as? String {
                                    if let level = doc?.get("level") as? Int {
                                        if let vipType = doc?.get("vipType") as? String {
                                            let data = StreamerListModel(userID: docID, nickname: nickname, platformID: platformID, token: token, pfImage: pfImage, level: level, vipType: vipType)
                                            self.streamerList.append(data)
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
    
    func getPKRequets(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PK").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.pkRequestList.removeAll()
                self.pkMessageUserList.removeAll()
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let deliveredTo = doc.get("deliveredTo") as? String {
                            if let isAccepted = doc.get("isAccepted") as? Bool {
                                if deliveredTo == Auth.auth().currentUser!.uid {
                                    let data = PKRequestModel(userID: sender, deliveredTo: deliveredTo, timeStamp: Int(doc.documentID)!, isAccepted: isAccepted)
                                    self.pkRequestList.append(data)
                                }
                                else if sender == Auth.auth().currentUser!.uid {
                                    let data = PKRequestModel(userID: deliveredTo, deliveredTo: sender, timeStamp: Int(doc.documentID)!, isAccepted: isAccepted)
                                    self.pkMessageUserList.append(data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getSwapRequets(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("Swap").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                self.swapRequestList.removeAll()
                self.swapMessageUserList.removeAll()
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let timeStamp = doc.get("timeStamp") as? Int {
                            if let product = doc.get("product") as? Int {
                                if let productType = doc.get("productType") as? String {
                                    if let selectedPlatform = doc.get("selectedPlatform") as? String {
                                        if let deliveredTo = doc.get("deliveredTo") as? String {
                                            if let isAccepted = doc.get("isAccepted") as? Bool {
                                                    if deliveredTo == Auth.auth().currentUser!.uid {
                                                        let data = GroupSwapRequestModel(userID: sender, deliveredTo: deliveredTo, timeStamp: timeStamp, isAccepted: isAccepted, productType: productType, product: product, selectedPlatform: selectedPlatform, docID: doc.documentID)
                                                        self.swapRequestList.append(data)
                                                    }
                                                    else if sender == Auth.auth().currentUser!.uid {
                                                        let data = GroupSwapRequestModel(userID: deliveredTo, deliveredTo: sender, timeStamp: timeStamp, isAccepted: isAccepted, productType: productType, product: product, selectedPlatform: selectedPlatform, docID: doc.documentID)
                                                        self.swapMessageUserList.append(data)
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
    
    func getPrivateChatUser(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PrivateChat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let deliveredTo = doc.get("deliveredTo") as? String {
                            if let timeStamp = doc.get("timeStamp") as? Int {
                                if deliveredTo == Auth.auth().currentUser!.uid {
                                    let data = PrivateChatUsers(userID: sender, deliveredTo: deliveredTo, timeStamp: timeStamp, docID: doc.documentID)
                                    self.privateUserList.append(data)
                                }
                                else if sender == Auth.auth().currentUser!.uid {
                                    let data = PrivateChatUsers(userID: deliveredTo, deliveredTo: sender, timeStamp: timeStamp, docID: doc.documentID)
                                    self.privateUserList.append(data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getPrivateChatUserForReply(selectedUserID : String){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PrivateChat").order(by: "timeStamp", descending: false).addSnapshotListener { snap, err in
            if err == nil {
                for doc in snap!.documents {
                    if let sender = doc.get("sender") as? String {
                        if let deliveredTo = doc.get("deliveredTo") as? String {
                            if let timeStamp = doc.get("timeStamp") as? Int {
                                if selectedUserID == sender || selectedUserID == deliveredTo {
                                    self.replyDocID = doc.documentID
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getSelectedUser(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let level = doc?.get("level") as? Int {
                        if let pfImage = doc?.get("pfImage") as? String {
                            if let vipType = doc?.get("vipType") as? String {
                                if let token = doc?.get("token") as? String {
                                    self.nickname = nickname
                                    self.level = level
                                    self.pfImage = pfImage
                                    self.vipType = vipType
                                    self.token = token
                                    self.replyNickname = nickname
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteMessage(docID: String){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("StreamerChat").document(docID).delete()
    }
}

struct AgencyStreamerMessageContent: View {
    @State var message : String
    @State var sender : String
    @State var isRead : [String]
    @State var timeStamp : Int
    @State var replyMessage : String
    @State var replyNickname : String
    
    @State private var timeDate : String = ""
    
    //MARK: User Details
    @State private var nickname : String = ""
    @State private var pfImage: String = ""
    @State private var token : String = ""
    var body : some View {
        VStack{
            if self.sender == Auth.auth().currentUser!.uid {
                HStack{
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .trailing, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomLeft])
                            
                            VStack(alignment: .leading){
                                
                                if replyMessage != "" {
                                    HStack(spacing: 10){
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                            .frame(width: 2, height: 40)
                                        
                                        VStack(alignment: .leading, spacing: 7){
                                            Text(replyNickname)
                                                .foregroundColor(.white)
                                                .font(.system(size: 13))
                                            
                                            Text(replyMessage)
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                                .lineLimit(3)
                                            
                                        }
                                        
                                    }
                                }
                                
                                Text(message)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .layoutPriority(1)
                            
                        }
                        .padding(.trailing)
                        
                        Text("\(timeDate)")
                            .foregroundColor(.white.opacity(0.2))
                            .font(.system(size: 10))
                            .padding(.trailing)
                    }
                }
            }
            else {
                HStack(alignment: .top){
                    
                    AsyncImage(url: URL(string: pfImage)) { img in
                        img
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        Image("defaultPf")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                    .padding(.leading)

                    
                    VStack(alignment: .leading, spacing: 7) {
                        ZStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black.opacity(0.2))
                                .cornerRadius(radius: 8, corners: [.topLeft, .topRight, .bottomRight])
                            
                            VStack(alignment: .leading){
                                
                                if replyMessage != "" {
                                    HStack(spacing: 10){
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                            .frame(width: 2, height: 40)
                                        
                                        VStack(alignment: .leading, spacing: 7){
                                            Text("Yanıt : \(replyNickname)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                            
                                            Text(replyMessage)
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                                .lineLimit(3)
                                            
                                        }
                                        
                                    }
                                }
                                
                                Text(message)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .layoutPriority(1)
                        }
                        
                        Text("\(timeDate)")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 10))
                    }
                    
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .onAppear{
            getDate()
            if sender != Auth.auth().currentUser!.uid {
                getUserDetails()
            }
        }
    }
    
    func getDate(){
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TRPOSIX")
        formatter.dateFormat = "dd.MMMM - HH:mm"
        formatter.string(from: date)
        self.timeDate = formatter.string(from: date)
    }
    
    func getUserDetails(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(sender).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let pfImage = doc?.get("pfImage") as? String {
                        if let token = doc?.get("token") as? String {
                            self.nickname = nickname
                            self.pfImage = pfImage
                            self.token = token
                        }
                    }
                }
            }
        }
    }
}

struct GroupSwapMaker: View {
    @Binding var showSwapMaker : Bool
    @Binding var userID : String
    @Binding var nickname : String
    @Binding var level : Int
    @Binding var vipType : String
    @Binding var pfImage : String
    @Binding var token : String
    @Binding var agencyID : String
    
    //Swaps
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    @State private var selectedSwapProduct : String = "5000"
    @State private var showSuccessView : Bool = false
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showSwapMaker = false
                }
            
            if self.showSuccessView {
                VStack{
                    
                    Spacer(minLength: 10)

                    VStack(alignment: .center, spacing: 15){
                        Spacer(minLength: 0)
                        
                        HStack{
                            Spacer(minLength: 0)
                            
                            LottieView(name: "paperplane", loopMode: .playOnce, speed: 1.0)
                                .frame(height: 200)
                            
                            Spacer(minLength: 0)
                        }
                        
                        Text("Talep Gönderiliyor!")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding([.horizontal, .bottom])
                    .frame(maxHeight: 400)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                            self.showSwapMaker = false
                            self.showSuccessView = false
                        }
                    }
                }
            }
            else {
                VStack{
                    
                    Spacer(minLength: 10)
                    
                    ZStack{
                        
                        AsyncImage(url: URL(string: pfImage)) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        } placeholder: {
                            Image("defualtPf")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 62, height: 62)
                        }
                        
                        
                        if vipType == "VIPSILVER" {
                            LottieView(name: "crown_silver")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        else if vipType == "VIPBLACK" {
                            LottieView(name: "crown_black")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        else if vipType == "VIPGOLD" {
                            LottieView(name: "crown_gold")
                                .frame(width: 62, height: 62)
                                .scaleEffect(1.7)
                                .offset(x: 0, y: -7)
                        }
                        
                        LevelContentProfile(level: level)
                            .scaleEffect(0.6)
                            .offset(x: 0, y: 32.5)
                    }
                    .scaleEffect(1.5)
                    .padding(.bottom, -30)
                    .zIndex(1)
                    
                    VStack(alignment: .center, spacing: 15){
                        Text("@\(nickname)")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.top, 55)
                        
                        
                        Picker("Takas Miktarı Seç", selection: $selectedSwapProduct) {
                            ForEach(general.swapArray, id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .preferredColorScheme(.light)
                        
                        HStack{
                            Button {
                                self.showSwapMaker = false
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.black)
                                    
                                    Text("Vazgeç")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                }
                            }
                            
                            Button {
                                sendSwapRequest()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black)
                                    
                                    Text("Oluştur")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                }
                            }
                        }
                        .frame(height: 45)
                    }
                    .padding(.all, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding([.horizontal, .bottom])
                    .zIndex(0)
                }
            }
        }
        
    }
    
    func sendSwapRequest(){
        self.showSuccessView = true
        
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("Swap").document("\(Int(Date().timeIntervalSince1970))").setData([
            "deliveredTo" : userID,
            "sender" : Auth.auth().currentUser!.uid,
            "isAccepted" : false,
            "product" : Int(selectedSwapProduct)!,
            "productType" : "diamond",
            "selectedPlatform" : userStore.selectedPlatform,
            "timeStamp" : Int(Date().timeIntervalSince1970)
        ], merge: true)
    }
    
}

struct GroupPKMaker: View {
    @Binding var showPKMaker : Bool
    @Binding var userID : String
    @Binding var nickname : String
    @Binding var level : Int
    @Binding var vipType : String
    @Binding var pfImage : String
    @Binding var token : String
    @Binding var agencyID : String
    
    //Swaps
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
    
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showPKMaker = false
                }
            
            VStack{
                
                Spacer(minLength: 10)

                VStack(alignment: .center, spacing: 15){
                    Spacer(minLength: 0)
                    
                    HStack{
                        Spacer(minLength: 0)
                        
                        LottieView(name: "paperplane", loopMode: .playOnce, speed: 1.0)
                            .frame(height: 200)
                        
                        Spacer(minLength: 0)
                    }
                    
                    Text("PK Talebi Gönderiliyor!")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    
                    Spacer(minLength: 0)
                }
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(8)
                .padding([.horizontal, .bottom])
                .frame(maxHeight: 400)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        sendPKRequest()
                    }
                }
            }
        }
        
    }
    
    func sendPKRequest(){
        let ref = Firestore.firestore()
        ref.collection("Agencies").document(agencyID).collection("PK").document("\(Int(Date().timeIntervalSince1970))").setData([
            "deliveredTo" : userID,
            "sender" : Auth.auth().currentUser!.uid,
            "timeStamp" : Int(Date().timeIntervalSince1970),
            "isAccepted" : false,
        ], merge: true)
        
        self.showPKMaker = false
    }
    
}

struct PrivateChatUsersContent: View {
    @State var userID : String
    @State var docID : String
    @State var agencyID : String
    
    //Data
    @State private var nickname : String = ""
    @State private var token : String = ""
    @State private var pfImage : String = ""
    @State private var level : Int = 0
    @State private var vipType : String = ""
    
    // Present
    @State private var toChat : Bool = false
    //Lottie
    @State private var lottieScale : CGFloat = 1.7
    @State private var offsetY : CGFloat = -5
    var body : some View {
        HStack(spacing: 10){
            ZStack{
                
                AsyncImage(url: URL(string: pfImage), content: { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                }, placeholder: {
                    Image("defualtPf")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 62, height: 62)
                })
                    .offset(y: 1)
                
                if self.vipType == "VIPSILVER" {
                    LottieView(name: "crown_silver")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPBLACK" {
                    LottieView(name: "crown_black")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }
                else if self.vipType == "VIPGOLD" {
                    LottieView(name: "crown_gold")
                        .frame(width: 62, height: 62)
                        .scaleEffect(lottieScale)
                        .offset(x: 0, y: offsetY)
                }

                if self.level != 0 {
                    LevelContentProfile(level: level)
                        .scaleEffect(0.6)
                        .offset(x: 0, y: 32.5)
                }
            }
            .scaleEffect(0.8)
            
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                }
                
                Text("Son Mesaj")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }
        }
        .onAppear{
            getInfo()
        }
        .onTapGesture {
            self.toChat.toggle()
        }
        .fullScreenCover(isPresented: $toChat) {
            GroupPrivateChat(userID: userID, agencyID: agencyID, docID: docID)
        }
    }
    
    func getInfo(){
        let ref = Firestore.firestore()
        ref.collection("Users").document(userID).addSnapshotListener { doc, err in
            if err == nil {
                if let nickname = doc?.get("nickname") as? String {
                    if let token = doc?.get("token") as? String {
                        if let level = doc?.get("level") as? Int {
                            if let vipType = doc?.get("vipType") as? String {
                                if let pfImage = doc?.get("pfImage") as? String {
                                    self.nickname = nickname
                                    self.token = token
                                    self.pfImage = pfImage
                                    self.level = level
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
