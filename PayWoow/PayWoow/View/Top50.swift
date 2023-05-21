//
//  Top50.swift
//  
//
//  Created by İsa Yılmaz on 1/16/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct Top50: View {
    @StateObject var users = Top50Store()
    @StateObject var userStore = UserInfoStore()
    @State private var showFirst = false
    @StateObject var researcher = Top50Researcher()
    @State private var selectedUserId: String = ""
    @State private var showCard = false
    @State private var toFaq = false
    @State private var lock : Bool = false
    var body: some View {
        ZStack{
            VStack{
                
                HStack{
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Top 50")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer(minLength: 0)
                    
                    if self.lock == false {
                        Button {
                            self.toFaq.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                    }

                }
                .padding([.top, .horizontal])
                
                ScrollView(showsIndicators: false){
                    ZStack{
                        
                        ForEach(self.users.users){ item in
                            if item.index == 2 {
                                SilverRosette(pfImage: item.pfImage, fullname: item.fullname, gift: item.gift, userId: item.userId, platformId: item.platformId, level: item.level, verify: item.verify, nickname: item.nickname, vipType: item.vipType, casper: item.casper)
                                    .onTapGesture {
                                        self.selectedUserId = item.userId
                                        self.showCard = true
                                    }
                                    .scaleEffect(1.1)
                            }
                        }
                        .offset(x: -110, y: 30)
                       
                        
                        ForEach(self.users.users){ item in
                            if item.index == 3 {
                                BronzeRosette(pfImage: item.pfImage, fullname: item.fullname, gift: item.gift, userId: item.userId, platformId: item.platformId, level: item.level, verify: item.verify, nickname: item.nickname, vipType: item.vipType, casper: item.casper)
                                    .onTapGesture {
                                        self.selectedUserId = item.userId
                                        self.showCard = true
                                    }
                                    .scaleEffect(1.1)
                            }
                        }
                        .offset(x: 110, y: 30)
                        
                        
                        ForEach(self.users.users){ item in
                            if item.index == 1{
                                GoldRosette(pfImage: item.pfImage, fullname: item.fullname, gift: item.gift, userId: item.userId, platformId: item.platformId, level: item.level, verify: item.verify, nickname: item.nickname, vipType: item.vipType, casper: item.casper)
                                    .onTapGesture {
                                        self.selectedUserId = item.userId
                                        self.showCard = true
                                    }
                                    .scaleEffect(1.2)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                 
                    ForEach(self.users.users){ item in
                        if item.index >= 4 && item.index <= 50 && item.totalSoldDiamond > 0 {
                            Top47(pfImage: item.pfImage, fullname: item.fullname, gift: item.gift, userId: item.userId, platformId: item.platformId, totalSoldDiamond: item.totalSoldDiamond, level: item.level, verify: item.verify, nickname: item.nickname, vipType: item.vipType, casper: item.casper)
                                .onTapGesture {
                                    self.selectedUserId = item.userId
                                    self.showCard = true
                                }
                            
                            HStack{
                                Spacer()
                                VStack{
                                    Divider()
                                        .background(Color.gray.opacity(0.4))
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .onChange(of: userStore.level, perform: { val in
            self.lock = true
            if userStore.level < 14 {
                self.lock = true
            }
            else {
                self.lock = false
            }
        })
        .onAppear(perform: {
            self.lock = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.lock = true
                if userStore.level < 14 {
                    self.lock = true
                }
                else {
                    self.lock = false
                }
            }
        })
        .popover(isPresented: $toFaq) {
            Top50FAQ()
        }
        .blur(radius: lock ? 11 : 0)
        .allowsHitTesting(!lock)
        .overlay{
            if self.lock {
                VStack(spacing: 15){
                    Image(systemName: "lock")
                        .foregroundColor(.white)
                        .font(.system(size: 80, weight: .light))
                    
                    Text("Kilitli")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Top 50 zirvesini\ngörebilmek için en az 15 level olmanız gerekmektedir!")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}
