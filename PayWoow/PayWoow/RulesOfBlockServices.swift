//
//  RulesOfBlockServices.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 4/2/23.
//

import SwiftUI

struct RulesOfBlockServices: View {
    @StateObject var general = GeneralStore()
    @Environment(\.presentationMode) var present
    var body: some View {
        ZStack{
            general.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button {
                        present.wrappedValue.dismiss()
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
                    
                    Text("Kural İhlali Cezaları")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer(minLength: 0)

                }
                .padding([.horizontal, .top])
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15){
                        Text("1- Melek Kural ihlali yaparsa")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                       Text("Banın açılmamasına rağmen açıldı denirse . Melek ödülünü alamaz tüm reddedilen işlemler 72 saat içinde denetlenir. Vip özelliğiniz iptal edilir.Liyakatı düşer. 3 ihlalde bir daha melek olma hakkını kaybeder")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        
                        Text("2- Şeytan Kural ihlali yaparsa")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                       Text("Banın açılmasına rağmen açılmadı denirse . Şeytanın yükleme tutarı blokeden kalkmaz . Tüm reddedilen işlemler 72 saat içinde denetlenir. Kural ihlali tespitinde şeytanın tutarı meleğe transfer edilir. Vip özelliğiniz iptal edilir.Liyakatı düşer. 3 ihlalde bir daha melek olma hakkını kaybeder")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        
                        Text("Ban Yardım İşlemleri")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        
                        Text("1-Melek")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                       Text("Melek paywoowdan yaptığı ödemelerin sonucu platformda aldığı puan tutarı kadar puan alır.Melek olmaya çıktığı an puanı  çekilir beklemede tutulur. Islem onaylandığında , ihlal bildirimi gelmezse 72 saat içinde puan silinir .Ban açılmazsa silinmez")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        
                        Text("2-Şeytan")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                        
                       Text("Şeytan ban derecesinde cüzdanına yaptıgı havale işlemi ile şeytan olabilir.Şeytanın aldığı tutar meleğin banı acması ile meleğe transfer edilir.Banı açılmadığı taktirde bakiyesi eksilmez. Şeytan ban islemi sırasında iken cüzdanı blokededir. Bloke ban acıldıktan sonra kalkar. Red işlemlerin blokesi 72 saat boyunca devam eder ve denetlenir.")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    }
                    .padding(.all)
                }
            }
        }
    }
}
