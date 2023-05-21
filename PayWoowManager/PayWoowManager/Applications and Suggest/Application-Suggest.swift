//
//  Application-Suggest.swift
//  Manager
//
//  Created by İsa Yılmaz on 1/22/22.
//

import SwiftUI

struct Application_Suggest: View {
    @State var dealler : String
    @State private var topSelection = 1
    var body: some View {
        VStack{
            
            HStack{
                Image("logoWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: Alignment.center)
                
               
                if self.topSelection == 1 {
                    Text("Öneri Talep")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                else {
                    Button {
                        self.topSelection = 1
                    } label: {
                        Text("Öneri Talep")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }

                }
                
                if self.topSelection == 0 {
                    Text("Başvurular")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }
                else {
                    Button {
                        self.topSelection = 0
                    } label: {
                        Text("Başvurular")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }

                }
                
                
                Spacer()
            }
            .padding(.all)
            .animation(.spring())

            TabView(selection: $topSelection){
                Applications(dealler: self.dealler, openScroll: true).tag(0)
                
                Suggestions(dealler: self.dealler).tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
