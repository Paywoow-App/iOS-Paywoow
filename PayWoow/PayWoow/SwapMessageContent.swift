//
//  SwapMessageContent.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/7/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct SwapMessageContent: View {
    @State var sender : String
    @State var isRead : [String]
    @State var timeStamp : Int
    @State var message : String
    @State var docID : String
    
    @State private var timeDate : String = ""
    var body : some View {
        VStack{
            if sender != Auth.auth().currentUser!.uid{
                HStack{
                    
                    VStack(alignment: .leading, spacing: 5){
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
                        
                        Text(timeDate)
                            .foregroundColor(.gray)
                            .font(.system(size: 10))
                            .padding(.leading)
                    }
                    
                    Spacer(minLength: 50)
                    
                }
            }
            else {
                HStack{
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .trailing, spacing: 5){
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
                        }
                        .padding(.trailing)
                        
                        Text(timeDate)
                            .foregroundColor(.gray)
                            .font(.system(size: 10))
                            .padding(.trailing)
                    }
                }
            }
        }
        .onAppear{
            let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            formatter.dateFormat = "dd.MMMM - HH:mm"
            self.timeDate = formatter.string(from: date)
        }
    }
}

