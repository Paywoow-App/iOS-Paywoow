//
//  Top50FAQ.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 28.03.2022.
//

import SwiftUI

struct Top50FAQ: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 60, height: 3, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("About Top50 List")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading){
                        HStack{
                            Text("1- How can I rise to the Top 50?")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("The easiest way to rise here is the amount of diamonds in the diamond cards you receive. So the fastest way to rise is to buy diamond cards.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("2- Why is it important to be in the Top 50?")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("When he rises here, he will start to see you among your supporters and other players.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("3- How can I get the Top50 Gift?")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("In order for you to receive the gifts we have specially prepared for you, the first thing we want is to maintain your continuity. It will be a matter of time before you reach our Top 50 list by maintaining your continuity. Our biggest gift in the Top 50 will be to give you a large amount of diamond cards as our own Sellers. Of course, if we tell other surprises in advance, it will have no purpose.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("4- Bronze, Silver, Gold Olmak?")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal)
                        
                        Text("You will be able to win prizes in our events that we will prepare for you soon.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                    }
                    
                }
            }
        }
    }
}
