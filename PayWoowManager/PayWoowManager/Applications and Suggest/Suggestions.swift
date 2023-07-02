//
//  Sugesstions.swift
//  
//
//  Created by İsa Yılmaz on 1/22/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct Suggestions: View {
    @State var dealler: String
    @StateObject var suggest = SuggestionStore()
    var body: some View {
        VStack{
            if !self.suggest.suggest.isEmpty {
                ScrollView(showsIndicators: false){
                    ForEach(suggest.suggest, id: \.timeDate ){ item in
                        SuggestionContent(img1: item.img1, img2: item.img2, img3: item.img3, pfImage: item.pfImage, fullname: item.fullname, desc: item.desc, userId: item.userId, title: item.title, timeDate: item.timeDate,platformID: item.platformID)
                            .padding(.vertical)
                    }
                }
            }
            if self.suggest.suggest.isEmpty {
                VStack(spacing: 20){
                    Image("noSuggest")
                        .resizable()
                        .scaledToFit()
                        .padding(.all)
                    
                    Text("Şu anlık sakin!")
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .padding(.all)
                    
                    Text("Bir öneri size gönderilir ise burada listelenecektir.")
                        .foregroundColor(Color.white.opacity(0.5))
                        .font(.system(size: 18))
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
            }
        }
    }
}

struct SuggestionContent: View{
    @State var img1 : String = ""
    @State var img2 : String = ""
    @State var img3 : String = ""
    @State var pfImage : String = ""
    @State var fullname : String = ""
    @State var desc : String = ""
    @State var userId : String = ""
    @State var title : String = ""
    @State var timeDate : String = ""
    @State var platformID : String = ""
    @State private var ht : CGFloat = CGFloat(80)
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.5))
            VStack{
                HStack{
                    WebImage(url: URL(string: pfImage))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(fullname)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        
                        Text("ID : \(platformID)")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    }
                    Spacer(minLength: 0)
                    Button {
                        if self.ht == 80 {
                            self.ht = 400
                        }
                        else {
                            self.ht = 80
                        }
                    } label: {
                        if self.ht == 80 {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                        else {
                            Image(systemName: "chevron.up")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                }
                .padding(.all)
                
                if self.ht == 400 {
                    VStack(alignment: .leading, spacing: 10){
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                            ScrollView(showsIndicators: true){
                                Text(desc)
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(height: 150)
                            
                        Text("Fotoğraflar")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                        HStack {
                            if self.img1 != "" {
                                VStack{
                                    WebImage(url: URL(string: img1))
                                        .resizable()
                                        .scaledToFit()
                                    
                                    
                                }
                                .clipped()
                                .cornerRadius(8)
                            }
                            
                            if self.img2 != "" {
                                VStack{
                                    WebImage(url: URL(string: img2))
                                        .resizable()
                                        .scaledToFit()
                                }
                                .clipped()
                                .cornerRadius(8)
                            }
                            
                            if self.img3 != "" {
                                VStack{
                                    WebImage(url: URL(string: img3))
                                        .resizable()
                                        .scaledToFit()
                                }
                                .clipped()
                                .cornerRadius(8)
                            }
                        }
                        .frame(height: 70)
                    }
                    .padding(.horizontal,5)
                    .padding(.vertical,2)
                    .padding(.bottom,5)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: ht)
        .contextMenu{
            Button {
                let ref = Firestore.firestore()
                ref.collection("Suggestions").document(userId).delete()
            } label: {
                Label("Okudum, İlgileniyorum", systemImage: "checkmark")
            }
            
        }
    }
}
