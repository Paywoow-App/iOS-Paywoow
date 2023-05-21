//
//  Reporter.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 3/14/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct Reporter : View {
    @State private var reportMessage: String = "I'm reporting because"
    @Environment(\.presentationMode) var present
    var body : some View {
        VStack{
            Spacer()
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                
                VStack(alignment: .leading){
                 Text("Why do you want a report? let us know?")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .bold()
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.5))
                        
                        TextEditor(text: $reportMessage)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                        
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green)
                        
                        Text("Send")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                    }
                    .frame(height: 50)
                    
                }
                .padding(10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
        }
    }
}
