//
//  ManagerAgencyStreamers.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/2/22.
//

import SwiftUI

struct ManagerAgencyStreamers: View {
    @Environment(\.presentationMode) var present
    @StateObject var general = GeneralStore()
    @Binding var streamerList : [String]
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12){
                HStack{
                    Button {
                        self.present.wrappedValue.dismiss()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white)
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 45, height: 45)
                    }
                    
                    
                    Text("Yayıncı Listesi")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding([.top, .horizontal])
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(streamerList, id: \.self) { item in
                        ManagerAgencyStreamerContent(streamerId: item)
                    }
                }
            }
        }
    }
}
