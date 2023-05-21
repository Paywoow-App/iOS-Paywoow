//
//  MessageUsers.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct SpecialMessageUsers: View {
    @State var userID: String
    @State var firstName: String
    @State var lastName: String
    @State var nickname: String
    @State var platformId: String
    @State var pfImage: String
    @State var time: String
    @State var date: String
    @State var lastMessage: String
    @State var isRead: Bool
    @State var level: Int
    @State var docID: String
    
    @State private var toWriter = false
    var body: some View {
        HStack{
            
                ZStack{
                    AnimatedImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                    
                    LevelContentProfile(level: level)
                        .scaleEffect(0.5)
                        .offset(y: 35)
                    
                    LottieView(name: "checkmark", loopMode: .loop)
                        .frame(width: 20, height: 20)
                        .offset(x: -32, y: -30)
                }
                
                VStack(alignment: .leading, spacing: 5){
                    HStack{
                        Text("\(firstName) \(lastName)")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                        
                        Spacer(minLength: 0)
                        
                        if self.isRead == true {
                            Text(time)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        else {
                            Text(time)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                    }
                    
                    HStack{
                        if self.isRead == true {
                            Text(lastMessage)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .fontWeight(.thin)
                                .lineLimit(1)
                        }
                        else {
                            Text(lastMessage)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                        
                        Spacer()

                    }
                }
                
                Spacer(minLength: 0)
            
        }
        .frame(height: 70)
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $toWriter) {
            SpecialChatWriter(senderId: self.$userID)
        }
        .onTapGesture {
            self.toWriter.toggle()
        }
    }
}
