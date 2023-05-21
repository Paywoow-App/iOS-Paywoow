//
//  ProcessingSalaryContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 23.04.2022.
//

import Foundation
import SDWebImage
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ProcessingSalaryContent: View {
    @State var userId: String = ""
    @State var month: String = ""
    @State var year: String = ""
    @State var sender : String = ""
    @State var total : Int = 0
    @State var docId : String = ""
    @State var result : Int = 0
    @State var bank : String = ""
    @State var iban : String = ""
    @State var bankImage : String = ""
    @StateObject var userStore = UserInfoStore()
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 10){
                
                HStack{
                    Image(bankImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    
                    Text("\(self.userStore.firstName) \(self.userStore.lastName)")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    
                    Spacer()
                    
                    Text("$\(total)")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                }
                .padding()
                
                Spacer(minLength: 0)
                
                Text(iban)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .fontWeight(.light)
                    .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                HStack{
                    Text("\(month) \(year)")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer()
                    
                    Text("Progress")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .bold()
                    
                }
                .padding(.all)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
        .padding(.vertical, 10)
    }
}

