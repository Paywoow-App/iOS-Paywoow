//
//  MyStreammerContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyStreamersContent : View {
    @State var pfImage : String = ""
    @State var fullname : String = ""
    @State var timeDate : String = ""
    @State var bigoId : String = ""
    @State var userId : String = ""
    @State private var userStore = UserInfoStore()
    var body : some View {
        HStack{
            AnimatedImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 80, height: 80, alignment: Alignment.center)
            
            VStack(alignment: .leading){
             Text(fullname)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                
                Text("@\(bigoId)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .fontWeight(.thin)
            }
            .frame(height: 70)
            
            Spacer()
                    

        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 90, alignment: Alignment.center)
    }
}

