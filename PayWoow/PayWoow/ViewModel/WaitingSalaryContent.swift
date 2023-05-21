//
//  WaitingSalaryContent.swift
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

struct WaitingSalaryContent: View {
    @State var userId: String = ""
    @State var month: String = ""
    @State var year: String = ""
    @State var sender : String = ""
    @State var total : Int = 0
    @State var docId : String = ""
    @State var result : Int = 0
    @State private var toSalaryWriter = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.5))
            
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text("Waiting")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                    
                    HStack{
                        Text("\(month)")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.light)
                        
                        Text("\(year)")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.light)
                    }
                }
                
                Spacer()
                
                Text("$\(total)")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
        .padding(.vertical, 10)
        .onTapGesture {
            self.toSalaryWriter.toggle()
        }
        .popover(isPresented: $toSalaryWriter) {
            WithdrawEarnings(salary: total, docId: docId, month: month, year: year)
        }
    }
}
