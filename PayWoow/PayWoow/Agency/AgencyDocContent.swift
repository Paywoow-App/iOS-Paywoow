//
//  AgencyDocContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 10/15/22.
//

import SwiftUI

struct AgencyDocContent: View {
    @State var agencyName: String
    @State var agencyID : String
    @State var timeStamp : Int
    @State var month : String
    @State var year : String
    @State var day : String
    @State var agencyPrice : Int
    @State var streamersPrice : Int
    @State var xlsx : String
    @State var pdf : String
    @State var selection : Int
    
    @Binding var showURL : String
    
    @State private var showDetails : Bool = false
    
    @State private var shareSheet : Bool = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(){
            HStack{
                
                if self.selection == 0 {
                    Image("excel")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                }
                else {
                    Image("adobePDF")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                }
                
                VStack(alignment: .leading, spacing: 7){
                    
                    HStack{
                        if self.selection == 0 {
                            Text("\(month) Maaş Raporu")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        else {
                            Text("\(month) Ayı Faturası")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("$\(agencyPrice)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    
                    HStack(alignment: .center, spacing: 10){
                        Button {
                            if self.selection == 0 {
                                self.showURL = xlsx
                            }
                            else {
                                self.showURL = pdf
                            }
                        } label: {
                            Image(systemName: "eye")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        
                        Button {
                            self.shareSheet.toggle()
                        } label: {
                            Image("download")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                        
                        
                        Button {
                            if self.selection == 0 {
                                openURL(URL(string: xlsx)!)
                            }
                            else {
                                openURL(URL(string: pdf)!)
                            }
                        } label: {
                            Image(systemName: "arrow.turn.up.right")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("$\(streamersPrice)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))

                    }
                }
                
                Spacer(minLength: 0)
                

            }.padding(10)
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .popover(isPresented: $shareSheet) {
                    if self.selection == 0 {
                        ShareSheet(activityItems: [URL(string: xlsx)!])
                    }
                    else {
                        ShareSheet(activityItems: [URL(string: pdf)!])
                    }
                }
            
            HStack{
                
                Spacer(minLength: 0)
                
                Text("\(day) \(month) \(year)")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .opacity(0.5)
                
                
            }
            .padding(.horizontal)
        }
        
    }
}
