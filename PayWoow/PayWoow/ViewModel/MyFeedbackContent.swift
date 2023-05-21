//
//  MyFeedbackContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct MyFeedbacks: View {
    @State var title: String
    @State var desc: String
    @State var img1 : String
    @State var img2 : String
    @State var img3 : String
    @State var timeDate: String
    var body: some View{
        VStack{
            
            ZStack {
            
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.5))
                
                HStack{
                    Text(title)
                       .foregroundColor(.white)
                       .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(timeDate)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .bold()
                }
                .frame(height: 40)
                .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.init(red: 97 / 255, green: 163 / 255, blue: 145 / 255))
                
                VStack(alignment: .leading){
                    HStack{
                        Text(desc)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                        
                        Spacer(minLength: 0)
                    }
                }
                .padding(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
}
