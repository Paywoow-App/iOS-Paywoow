//
//  FAQContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct FAQContent: View {
    @State var title: String
    @State var desc: String
    @Binding var openTab : Bool
    @State private var showIt = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.5))
            
            VStack{
                HStack{
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    Spacer(minLength: 0)
                }
                .padding(.all, 10)

                
                if self.openTab == true || self.showIt{
                    VStack(alignment:. leading){
                        Text(desc)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .fontWeight(.thin)
                    }
                    .padding([.leading, .bottom, .trailing], 10)
                }

            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .animation(.easeIn)
        .onTapGesture {
            self.showIt.toggle()
        }
    }
}
