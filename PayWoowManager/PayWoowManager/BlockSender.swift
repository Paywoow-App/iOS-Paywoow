//
//  BlockSender.swift
//  PayWoowManager
//
//  Created by İsa Yılmaz on 5/31/22.
//

import SwiftUI
import Firebase

struct BlockSender: View {
    @Environment(\.presentationMode) var present
    @Binding var userId: String
    @State private var typedDesc = "Açıklama"
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading){
                Text("Bu kullanıcıyı neden engelliyorsun?")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        
                        Text("Lütfen kullanıcıyı neden engellediğini bize açıkla. Bu bilgiyi kullanıcıya paylaşacağız. Bir kullanıcıyı sebebsiz yere engellemekten kaçının. Bu durum politika gereğince araştırılmaya açık olacaktır.")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.horizontal, 15)
                        
                        Button {
                            blockUser(desc: "Gizlilik politikası ihlali gerçekleştirilmiştir.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Gizlilik politikası ihlali gerçekleştirilmiştir.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        
                        Button {
                            blockUser(desc: "Kullanıcı sözleşmesi ihlali gerçekleştirilmiştir.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Kullanıcı sözleşmesi ihlali gerçekleştirilmiştir.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        Button {
                            blockUser(desc: "Uygulamayı kandırmaya yönelik suç bulunmuştur.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Uygulamayı kandırmaya yönelik suç bulunmuştur.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        
                        Button {
                            blockUser(desc: "Diğer kullanıcılara karşı taciz ve nefret söyleminde bulunulmuştur.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Diğer kullanıcılara karşı taciz ve nefret söyleminde bulunulmuştur.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        
                        Button {
                            blockUser(desc: "Sahte kullanıcı olduğu tespit edilmiştir.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Sahte kullanıcı olduğu tespit edilmiştir.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        
                        
                        
                        Button {
                            blockUser(desc: "Cinsel içerikli bir fotoğraf kullanıldığı tespit edilmiştir.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Cinsel içerikli bir fotoğraf kullanıldığı tespit edilmiştir.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        
                        Button {
                            blockUser(desc: "Özel bilgi (Telefon, Adres, Kimlik Numarası, vb.) paylaşımı yapıldığı tespit edilmiştir.")
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                
                                HStack{
                                    Text("Özel bilgi (Telefon, Adres, Kimlik Numarası, vb.) paylaşımı yapıldığı tespit edilmiştir.")
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                        
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack{
                           TextEditor(text: $typedDesc)
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                                .colorScheme(.light)
                                .multilineTextAlignment(.leading)
                                .cornerRadius(6)
                                
                            Spacer(minLength: 0)
                        }.frame(height: 100)
                            .padding(.horizontal)
                        
                        
                        HStack{
                            Button {
                                present.wrappedValue.dismiss()
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.black)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white, lineWidth: 2)
                                        }
                                    
                                    
                                    Text("İptal")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                            }
                            if self.typedDesc != "Açıklama" && self.typedDesc != ""  && self.typedDesc.count > 12 {
                                
                                Button {
                                    blockUser(desc: typedDesc)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white)
                                        
                                        Text("Engelle")
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                    }
                                }
                            }

                        }
                        .frame(height: 40)
                        .padding(.all)
                    }

                }
            }
        }
    }
    func blockUser(desc: String) {
        let ref =  Firestore.firestore()
        ref.collection("Users").document(userId).setData(["block" : 1, "blockDesc": desc], merge: true)
        setCareCcode(dealler: "Main", code: "9247")
    }
}
