//
//  Policies.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/14/22.
//

import SwiftUI
import Firebase
import WebKit
import SDWebImageSwiftUI

struct Policies: View {
    @State private var selection = 0
    @Binding var accepted : Bool
    @Environment(\.presentationMode) var present
    var body : some View {
        ZStack{
            LinearGradient(colors: [Color.init(red: 52 / 255, green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack(spacing: 20){
                    
                    Button {
                        self.selection = 0
                    } label: {
                        if self.selection == 0 {
                            Text("Terms Of Services (KVK)")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                        else {
                            Text("Terms Of Services (KVK)")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.leading)
                    
                    Button {
                        self.selection = 1
                    } label: {
                        if self.selection == 1 {
                            Text("Privacy Policy")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .bold()
                        }
                        else {
                            Text("Privacy Policy")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                
                if self.selection == 0 {
                    PolicyPreview(url: URL(string: "https://www.paywoow.com/wp-content/uploads/2022/07/gizlilik-politikasi.docx")!)
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .edgesIgnoringSafeArea(.bottom)
                }
                else if self.selection == 1 {
                    PolicyPreview(url: URL(string: "https://www.paywoow.com/wp-content/uploads/2022/07/KULLANICI-SOZLESMESI-PAYWOOW.docx")!)
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .edgesIgnoringSafeArea(.bottom)
                }
                
                Button {
                    if self.selection == 0 {
                        self.selection = 1
                    }
                    else {
                        self.accepted = true
                        self.present.wrappedValue.dismiss()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.init(hex: "#1CC4BE"))
                        
                        Text("Accept")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(height: 50)
                }
                .padding(.all, 10)

            }
        }
    }
}

struct PolicyPreview: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
