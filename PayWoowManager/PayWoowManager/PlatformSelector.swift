//
//  PlatformSelector.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 10/23/22.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct PlatformSelector: View {
    @Binding var selectedPlatform : String
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @StateObject var platforms = PlatformStore()
    var body: some View {
        ZStack{
            general.backGroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack (spacing: 15){
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    Text("Platform Seç")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(platforms.list) { item in
                        PlatformContent(platformName: item.platformName, platformImage: item.platformImage, selectedPlatform: $selectedPlatform)
                    }
                }
            }
        }
    }
}
