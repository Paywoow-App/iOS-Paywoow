//
//  PlatformContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI


struct AddedPlatformContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var platformId : String
    @State var platformLogo : String
    @State var platformName : String
    @State private var showContent = false
    @State private var unable = false
    var body: some View{
        
        VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.2))
                    
                    if self.userStore.selectedPlatform == self.platformName {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.init(red: 0, green: 245 / 255, blue: 207 / 255))
                            .padding(1)
                    }
                    
                    HStack{
                        WebImage(url: URL(string: self.platformLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.leading, 10)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text(platformName)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Text("ID: \(platformId)")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        if self.userStore.selectedPlatform == self.platformName {
                            Text("Active")
                                .foregroundColor(Color.init(red: 0, green: 245 / 255, blue: 207 / 255))
                                .font(.system(size: 20))
                                .onAppear{
                                    self.unable = false
                                }
                                
                        }
                        else {
                            Text("Not Active")
                                .foregroundColor(Color.init(red: 255 / 255, green: 0 / 255, blue: 0 / 255))
                                .font(.system(size: 20))
                                .onAppear {
                                    self.unable = true
                                }
                                
                        }
                    }
                    .padding(10)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
            
        }
    }
}

