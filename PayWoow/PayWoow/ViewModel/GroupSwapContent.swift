//
//  GroupSwapContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct GroupSwapContent: View {
    @State var bigoId : String
    @State var diamond : Int
    @State var fullname: String
    @State var level : Int
    @State var pfImage : String
    @State var timeDate : String
    @State var userId : String
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: pfImage))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5){
                Text(fullname)
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .bold()
                
                Text("@\(bigoId)")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: 15))
            }
            
            Spacer(minLength: 0)
            
            Image("dia")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text("\(diamond)")
                .foregroundColor(.black)
                .font(.system(size: 15))
                .bold()
            
            
        }
    }
}

