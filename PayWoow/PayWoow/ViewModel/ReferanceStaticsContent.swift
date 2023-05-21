//
//  ReferanceStaticsContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct ReferanceUsers: View {
    @StateObject var referenceUsers = ReferanceStore()
    @StateObject var userStore = UserInfoStore()
    
    var body: some View {
        
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.2))
                
                VStack{
                    
                    Text("Details")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding(.top, 10)
                    
                    Text(self.userStore.myRefeanceCode)
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.vertical, 5)
                    
                    HStack{
                        VStack(alignment: .center){
                            Text("Incoming\nUser")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(self.referenceUsers.totalUser)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.225)
                        
                        Group{
                            Spacer(minLength: 0)
                            
                            Divider()
                                .background(Color.white)
                            
                            Spacer(minLength: 0)
                        }
                        
                        
                        VStack(alignment: .center){
                            Text("Load\nAmount")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(self.referenceUsers.totalUserSoldPrice)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.225)
                        
                        Group{
                            Spacer(minLength: 0)
                            
                            Divider()
                                .background(Color.white)
                            
                            Spacer(minLength: 0)
                            
                        }
                        
                        VStack(alignment: .center){
                            Text("Destekçi\nÖdül")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(self.referenceUsers.totalUserGivenGift)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.225)
                        
                        Group{
                            
                            Spacer(minLength: 0)
                            
                            Divider()
                                .background(Color.white)
                            
                            Spacer(minLength: 0)
                        }
                        
                        VStack(alignment: .center){
                            Text("Streamer\nAward")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(self.referenceUsers.totalStreamerGift)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.225)
                        
                        
                        
                        
                        
                        
                        
                    }
                    .frame(height: 80)
                    .padding(.top, 5)
                    
                    Divider().background(Color.white)
                        .padding(.horizontal, 10)
                    
                    ScrollView(showsIndicators: false){
                        
                        ForEach(self.referenceUsers.users) { item in
                            
                            HStack{
                                
                                
                                VStack(alignment: .center){
                                    
                                    WebImage(url: URL(string: item.profileImage))
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                        .padding(.leading, 5)
                                    
                                    
                                    Text(item.userFullname)
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                    
                                    Text(item.userBigoId)
                                        .foregroundColor(.white)
                                        .font(.system(size: 10))
                                    
                                }
                                
                                Spacer(minLength: 0)
                                
                                Text("\(item.userSoldPrice)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .frame(width: UIScreen.main.bounds.width * 0.220)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(item.userGivenGift)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .frame(width: UIScreen.main.bounds.width * 0.220)
                                
                                Spacer(minLength: 0)
                                
                                Text("\(item.streamerGivenGift)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .frame(width: UIScreen.main.bounds.width * 0.220)
                                
                                Spacer(minLength: 0)
                                
                                
                            }
                            .frame(height: 100)
                            .padding(.horizontal, 10)
                            
                            Divider()
                                .background(Color.white)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                            
                        }
                        
                    }
                }
                
            }.frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.65)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    referenceUsers.getUsers(refCode: "\(userStore.myRefeanceCode)")
                }
            }
        
    }
}
