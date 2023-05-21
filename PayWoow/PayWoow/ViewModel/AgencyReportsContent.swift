//
//  AgencyReportsContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AgencyReportsContent: View {
    @State var pfImage: String = ""
    @State var fullname: String = ""
    @State var userId: String = ""
    @State var platformId: String = ""
    @State var desc: String = ""
    @State private var showDetails : Bool = false
    var body: some View {
        VStack{
            HStack{
                WebImage(url: URL(string: pfImage))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading){
                    Text(fullname)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Text("@\(platformId)")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                Spacer(minLength: 10)
                
                Button {
                    self.showDetails.toggle()
                } label: {
                    if showDetails {
                        Image(systemName: "chevron.up")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    }
                    else {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    }
                }

            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 55)
            
            if showDetails {
                Text(desc)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
