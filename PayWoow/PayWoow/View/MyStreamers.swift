//
//  MyStreamers.swift
//  PayWoowApp
//
//  Created by İsa Yılmaz on 10/15/21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyStreamers: View{
    @Environment(\.presentationMode) var present
    @StateObject var streammerStore = MyStreamerStore()
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
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
                    
                    Text("Benim Ajanslarım")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding([.horizontal, .top])
                
                if self.streammerStore.streamer.isEmpty == true {
                    
                    Spacer()
                    
                    Text("Oops!")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    Text("If you have a publisher you will be able to see it here")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .fontWeight(.thin)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .padding(.all, 10)
                    
                    Spacer()
                }
                else {
                    
                    ScrollView(showsIndicators: false){
                        ForEach(self.streammerStore.streamer){ item in
                            MyStreamersContent(pfImage: item.pfImage, fullname: item.fullname, timeDate: item.timeDate, bigoId: item.bigoId, userId: item.userid)
                        }
                    }
                 
                }
            }
        }
    }
}
