//
//  RemittenceTransactionContent.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 11/5/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RemittenceTransactionContent: View {
    @StateObject var cardStore = VIPCardStore()
    @StateObject var userStore = UserInfoStore()
    @State var bank : String
    @State var iban : String
    @State var result : Int
    @State var timeStamp : Int
    @State var price : Int
    @State var merchantDOCID : String
    @State var isUploadedPrice : Bool
    @State var isDeclinedPrice : Bool
    
    @State private var timeDate : String = ""
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text(bank)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 0)
                    
                    Text("₺ \(price)")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                
                
                Text(iban)
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 10))
                
                
                HStack{
                    
                    Text(timeDate)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        if self.result == 0 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                            
                            Text("Beklemede")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        else if self.result == 1 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
                            
                            Text("Karta Yüklendi")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                        }
                        
                        else if self.result == 2 {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                            
                            Text("Reddedildi")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        }
                    
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 30, alignment: Alignment.center)
                }
            }
        }
        .padding(.all, 10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .onAppear{
            let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.mm.yyyy, HH:mm"
            formatter.locale = Locale(identifier: "tr_TRPOSIX")
            self.timeDate = formatter.string(from: date)
        }
    }
}
