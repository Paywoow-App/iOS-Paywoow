//
//  FAQ.swift
//  PayWoowProject
//
//  Created by İsa Yılmaz on 2/25/22.
//

import SwiftUI
 
struct FAQ: View {
    @State private var openTab = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 5, alignment: Alignment.center)
                    .padding(5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Sıkça Sorulan Sorular")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.leading , 5)
                    
                    Spacer()
                    
                    Button {
                        self.openTab.toggle()
                    } label: {
                        if self.openTab {
                            Image(systemName: "eye.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                        else {
                            Image(systemName: "eye.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                    }

                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false){
                    Group{
                        FAQContent(title: "Nasıl Ajans Olduğumu bildiririm , Yayıncımı nasıl bana bağlı Gösterebilirim?", desc: "• Profil Düzenleme kısmından Hesap Yönetimi-Kişisel Bilgiler kısmından sağ üst köşede PayWoow ID yazan yerin kopyalayıp , yayıncılarınıza gönderin", openTab: $openTab)
                        
                        FAQContent(title: "Nasıl Yayıncı Olduğumu Bildiririm?", desc: "• Ajansınızı size verdiği PayWoow ID yi Account Type – Streamer kısmına yapıştırarak yayıncı olduğunuz ajansınızın doğrulamasını yapabilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat (Ajans Messenger) Kısmını Nasıl Açabilirim?", desc: "• Hesap Yönetimi – Hesap Türü kısmına girip Ajans olduğunu bildir butonuna basarak ; Ajans Adı , İletişim numarası ve Aktif 5 Yayıncınızın PayWoow ID sini giriniz.", openTab: $openTab)
                        
                        FAQContent(title: "Yayıncılarımı Nasıl PaywoowChat gurubuna alabilirim?", desc: "• Yayıncılığı onaylanan her yayıncıyı otomatikmen PaywoowChat gurubuna alabilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Nasıl Ajans Olduğumu bildiririm , Yayıncımı nasıl bana Bağlı Gösterebilirim?", desc: "• Profil Düzenleme kısmından Hesap Yönetimi-Kişisel Bilgiler kısmından sağ üst köşede PayWoow ID yazan yerin kopyalayıp , yayıncılarınıza gönderin", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat grubunda özel olarak nasıl mesajlaşabilirim?", desc: "• Grubta yazılan mesajın üzerine basılı tutup özel olarak cevapla diyebilirsiniz.", openTab: $openTab)
                    }
                    
                    Group{
                        FAQContent(title: "PaywoowChat de Pk nedir?", desc: "• Kullandığınız plartformlarda pk atmak istediğinizde bunu ajansınızın içindeki kişilere talep olarak gönderme işlemidir.", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat de Takas Butonu Nasıl Kullanırım?", desc: "• Kullandığınız plartformlarda ajans içi takas yapmak istediğinizde bunu talep olarak gönderme işlemidir.", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat’de Slider Ne işe yarar?", desc: "• Ajansınızın bilgilendirmeleri yaptığı alandır.", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat Yönetici , Asistan , Muhasebe Birimleri nedir?", desc: "• Kullandığı plartformda Sisteme kayıtlı ajans sahibinin üzerine açılan grubun ; grub sahibi ; yönetici , diğer yöneticiler ;asistan , muhasebe ilgili sorun ve sorulara ilgilenme için muhasebe adı altında yetkilendirilmişlerdir.", openTab: $openTab)
                        
                        FAQContent(title: "PaywoowChat ajans mesaj gurubundan nasıl çıkabilirim?", desc: "Ne zaman başka bir ajansa geçerseniz o zaman ayrılmış olacaaksınız", openTab: $openTab)
                    }
                    
                    
                    Group{
                        FAQContent(title: "Elmas Siparişi nasıl verebilirim?", desc: "• Alt bardaki sol sekmede ki home kısmından girerek sipariş verebilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Siparişim İşlem Aşamasında nasıl görürüm?", desc: "• Son siparişlerinizi anlık olarak profilinizden görebilir , sipariş aşamalarını takip edebilirsiniz ; beklemede , işleme alındı , yükleme başarılı .", openTab: $openTab)
                        
                        FAQContent(title: "Banka Bilgilerimi Nasıl Girebilirim?", desc: "• Alt bardaki kart iconundan veya profilinizdeki Banka bilgilerim kısmından  banka bilgilerinizi kayıt edebilir.", openTab: $openTab)
                        
                        FAQContent(title: "Geçmiş Siparişlerimi nereden görebilirim?", desc: "• Alt bardaki siparişlerim iconundan  veya profilinizde ki SİPARİŞLERİM yazan yerden geçmiş siparişlerinizi görebilir , son siparişlerinizi de profilinizde görebilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Hediye Elmas Çekim Talebim Ne zaman Gelir?", desc: "• Hediyeleriniz yükleme başına top ilk 3 girme başına ve Referans koduna sahipseniz davet ettiğiniz her kişi başına artar. 1000 ne ulaştığında çekiminizi gerçekleştirebilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Nasıl Hediye Elmas Kazanabilirim?", desc: "• Bir ajansa bağlı olup yayıncılığınızı yapıp , en çok takas yapan yayıncılar arasından ve en çok yükleme yapan destekçiler arasında seçilen kişilere Paywoow Referans Kodu gönderir. Size ait referans kodunuzu arkadaşlarınızla ve izleyicilerinizle paylaşarak hediye elmaslar kazanabilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Faturalarım Ne zaman Gelir ?", desc: "• İlk 3ila 7 gün arasında siparişlerinizin faturaları gelir", openTab: $openTab)
                        
                        FAQContent(title: "Neden imza ve Kimlik İle Selfie Fotoğrafı Gerekli?", desc: "• Yayıncılarımız güvenliği için geri çekimin önlemini sağlamak ve  Kart çalıntı ve şüpheli işlemlerin önüne geçmek için , işlemleri sizin yaptığınıza dair imza ve kimlik fotoğrafınızla birlikte selfie istenir. Uygulamaya her girişinizde de parmak izi ve faceıd alınır.", openTab: $openTab)
                        
                        FAQContent(title: "Sipariş Destek Kısmı ne zaman açılır?", desc: "• Siparişinizi gerçekleştirdikten 3ila 5 dk içinde sipariş destek kısmınızı açılır. Paywoow Müşteri hizmetleri ile iletişime geçebilirsiniz.", openTab: $openTab)
                        
                        FAQContent(title: "Top 50 de Nickname nasıl gizlerim?", desc: "• Vip kısmınız aktif olduğunda gizli kullanıcı modunu aktif edebilir ve adınız ile ıdnizi tüm kullanıcılara gizleyebilirsiniz.", openTab: $openTab)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}
