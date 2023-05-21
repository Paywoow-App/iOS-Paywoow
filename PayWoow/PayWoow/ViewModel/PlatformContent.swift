//
//  PlatformContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 8/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct PlatformContent: View {
    @StateObject var userStore = UserInfoStore()
    @State var platformDocId : String
    @State var platformLogo : String
    @State var platformName : String
    @State var globalUsers : Int
    @State var isActive : Bool
    var body: some View{
        
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.2))
                
                HStack{
                    WebImage(url: URL(string: self.platformLogo))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .clipped()
                        .cornerRadius(12)
                        .padding(.leading, 10)
                    
                    
                    
                    Text(platformName)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .padding(10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
            
        }
    }
}

