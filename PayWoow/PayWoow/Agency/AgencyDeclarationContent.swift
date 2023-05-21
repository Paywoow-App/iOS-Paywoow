//
//  AgencyDeclarationContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/8/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct AgencyDeclarationContent: View {
    @State var agencyName : String
    @State var description : String
    @State var month : String
    @State var year : String
    @State var process : Int
    @State var timeStamp : Int
    @State var title : String
    @State var agencyId : String
    @State var decID : String
    
    @State private var show : Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text(agencyName)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Spacer(minLength: 0)
                        
                        if self.process == 0 {
                            Text("Bekelemede")
                                .foregroundColor(.init(hex: "#62BDFF"))
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        else if self.process == 1 {
                            Text("Çözüldü")
                                .foregroundColor(.init(hex: "#00FFFF"))
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        else if self.process == 2 {
                            Text("Reddedildi")
                                .foregroundColor(.init(hex: "#FF6262"))
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
            }
            .onTapGesture {
                self.show.toggle()
            }
            
            if self.show {
                Text(description)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
            }
            
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
