//
//  Notifications.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct NotificationsContent: View {
    @State var bayiiName : String
    @State var bayiiImage : String
    @State var bayiiId : String
    @State var date : String
    @State var message : String
    
    var body: some View{
        VStack{
            HStack{
                AnimatedImage(url: URL(string: bayiiImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60 , height: 60, alignment: Alignment.center)
                
                VStack(alignment: .leading){
                    HStack{
                        Text(self.bayiiName)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.regular)
                        
                        Spacer()
                        
                        Text(date)
                            .foregroundColor(.white)
                            .font(.footnote)
                            
                    }
                    Spacer(minLength: 0)
                    
                    Text(message)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 13))
                        .fontWeight(.regular)
                }

            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
        .padding(.vertical)
        .onAppear{
           
        }
    }
}

