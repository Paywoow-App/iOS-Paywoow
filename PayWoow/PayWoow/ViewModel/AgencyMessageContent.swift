//
//  AgencyMessage.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 2/11/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AgencyMessageContent: View {
    
    @State var fullname: String
    @State var isRead: String
    @State var message: String
    @State var month: String
    @State var pfImage: String
    @State var platformId: String
    @State var time: String
    @State var timeDate: String
    @State var userID: String
    @State var addedUser : String
    @State var level : Int
    var body: some View {
        if userID == Auth.auth().currentUser!.uid {
            HStack{
                
                Spacer(minLength: 30)
                
                VStack(alignment: .trailing){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.black.opacity(0.2))
                                .clipped()
                                
                        }
                        .cornerRadius(8)
                        
                        
                        Text(message)
                           .foregroundColor(.white)
                           .font(.system(size: 14))
                           .padding(10)
                           .layoutPriority(1)
                        
                    }
                    
                    HStack{
                        Text(time)
                            .foregroundColor(.gray)
                            .font(.system(size: 9))
                            
                       
                        
                    }
                }

                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        } else if userID != Auth.auth().currentUser!.uid {
            HStack(alignment: .top){
                
                WebImage(url: URL(string: self.pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                
                VStack(alignment: .leading){
                    ZStack {
                        VStack{
                            Image("bubble")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.init(red: 80 / 255, green: 80 / 255, blue: 80 / 255))
                                .clipped()
                                
                        }
                        .cornerRadius(8)
                        
                        
                         Text(message)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(10)
                            .layoutPriority(1)
                    }
                    
                    Text(time)
                        .foregroundColor(.gray)
                        .font(.system(size: 9))
                        .padding(.leading, 5)
                }
                
                Spacer(minLength: 30)

                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}

