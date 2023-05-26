//
//  AgencyView.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI

struct AgencyView: View {
    @StateObject var general = GeneralStore()
    @StateObject var userStore = UserInfoStore()
        
    //External
    @State private var toMyStreamers : Bool = false
    @State private var toStreamerRequest : Bool = false
    @State private var toAgencyDeclarations : Bool = false
    @State private var toDemoSender : Bool = false
    @State private var toAgencyDocs : Bool = false
    @State private var toStreamerDemos : Bool = false
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack(spacing: 12){
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    Text("Ajans")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.horizontal,.top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    Button {
                        self.toStreamerRequest.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            HStack{
                                
                                Image(systemName: "person.fill.questionmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("Streamer Applications")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        
                        .frame(height: 50, alignment: Alignment.center)
                        .padding(.horizontal, 10)
                        
                    }
                    
                    Button {
                        self.toMyStreamers.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            HStack{
                                
                                Image(systemName: "music.mic")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("Yayıncılarım")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        
                        .frame(height: 50, alignment: Alignment.center)
                        .padding(.horizontal, 10)
                        
                    }
                    
                    Button {
                        self.toDemoSender.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))

                            HStack{
                                
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("Send Streamer Demo")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        
                        .frame(height: 50, alignment: Alignment.center)
                        .padding(.horizontal, 10)
                        
                    }
                    
                    Button {
                        self.toStreamerDemos.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "person.crop.square")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("Streamer Demo List")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        
                        .frame(height: 50, alignment: Alignment.center)
                        .padding(.horizontal, 10)
                        
                    }
                    
                    Button {
                        self.toAgencyDeclarations.toggle()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                            
                            HStack{
                                
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                
                                Text("Declarations")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .colorScheme(.dark)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                                
                            }
                        }
                        
                        .frame(height: 50, alignment: Alignment.center)
                        .padding(.horizontal, 10)
                        
                    }
                        
                        Button {
                            self.toAgencyDocs.toggle()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.2))

                                HStack{
                                    
                                    Image(systemName: "doc.text")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 10)
                                    
                                    Text("Documents")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .colorScheme(.dark)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                    
                                }
                            }
                            .frame(height: 50, alignment: Alignment.center)
                            .padding(.horizontal, 10)
                        
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $toStreamerRequest, content: {
            MyStreamerRequests()
        })
        .fullScreenCover(isPresented: $toMyStreamers) {
            MyStreamers()
        }
        .fullScreenCover(isPresented: $toAgencyDeclarations) {
            AgencyDeclarations()
        }
        .fullScreenCover(isPresented: $toDemoSender) {
            if #available(iOS 16.0, *) {
                StreamerDemoSender()
            } else {
                // Fallback on earlier versions
            }
        }
        .fullScreenCover(isPresented: $toStreamerDemos) {
            AgencyStreamerDemos()
        }
        
        .fullScreenCover(isPresented: $toAgencyDocs) {
            AgencyDocs()
        }
    }
}

