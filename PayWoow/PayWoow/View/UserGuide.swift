//
//  UserGuıde.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 6/2/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserGuide: View {
    @State var goToId : Int = 1
    var body : some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 52 / 255 , green: 58 / 255, blue: 58 / 255), Color.init(red: 16 / 255, green: 16 / 255, blue: 16 / 255)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 100, height: 3, alignment: Alignment.center)
                    .padding(.vertical, 5)
                
                HStack{
                    
                    Image("logoWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45, alignment: Alignment.center)
                    
                    Text("Kullanım Klavuzu")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollViewReader { index in
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(guideData) { item in
                                GuideContent(title: item.title, subTitle: item.subTitle)
                                    .id(item.id)
                            }
                        }
                    }.onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                            index.scrollTo(goToId - 1)
                        }
                    }
                }
            }
        }
    }
}


struct GuideContent: View {
    @State var title : String
    @State var subTitle : [GuideSubTitleModel]
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 15))
                .bold()
            
            ForEach(subTitle) { item in
                GuideSubContent(text: item.text, image: item.image, image2: item.image2)
            }
        }
        .padding(.horizontal)
    }
}

struct GuideSubContent: View {
    @State var text : String
    @State var image : String
    @State var image2 : String
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 15))
            
            Image(image)
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
            
            if self.image2 != "" {
                Image(image2)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            }
        }
    }
}

struct GuideModel: Identifiable{
    var id : Int
    var title : String
    var subTitle : [GuideSubTitleModel]
}

struct GuideSubTitleModel: Identifiable {
    var id : Int
    var text : String
    var image : String
    var image2 : String
}

let guide1 = GuideModel(id: 1, title: "Elmas Kartı Satın Almak", subTitle: [
    GuideSubTitleModel(id: 1, text: "1.1 - Sol alttaki barın ilk öğesi olan Bayiler (Deallers) ekranında yükleme yaptırmak istediğin satıcıyı seç.", image: "newDeallerSC", image2: ""),
    GuideSubTitleModel(id: 2, text: "1.2 - Elmas kartınızı keyfinize göre ayarlayın ve güvenli online ödeme sistemiyle ödemenizi yapabilirsiniz. Yapman gereken sadece ne kadar tutarda elmas almak istediğini yazmak. Ardından yükleme yapacağın platform ID sini yazmak. Banka kartlarını kullanarak hızlı bir şekilde yapabilirsin", image: "sc2", image2: ""),
    GuideSubTitleModel(id: 3, text: "1.3- Kendine en uygun rengi seç ve kişiselleştir.", image: "sc3", image2: "")
])

let guide2 = GuideModel(id: 2, title: "2- Dönüşüm yapmak mı istiyorsun", subTitle: [
    GuideSubTitleModel(id: 1, text: "2.1 - Artık sosyal medya hesaplarınızda telefon bilgilerinizi paylaşarak dönüşüm aramanıza gerek kalmadı. Yapmanız gereken, Sağ alt köşedeki göz ikonuna basmak olacaktır.", image: "sc4", image2: ""),
    GuideSubTitleModel(id: 2, text: "2.2 - Buradan sana en uygun takas miktarını seç ve arayışa geç. Sen gibi bir çok kişi de bunları görecek.", image: "sc5", image2: ""),
    GuideSubTitleModel(id: 3, text: "2.3- Sen mi birisinin dönüşümünü değerlendirmek istiyorsun? Kendine en uygun takas miktarını arayan kullanıcıyı seç ve istek gönder.", image: "sc6", image2: ""),
    GuideSubTitleModel(id: 4, text: "2.4 - Gönderdiğin takas isteğin gönderdiğin kullanıcımızın profiline düşecektir. Üzerine basılı tutup onaylayabilir veya red edebilir. Kabul etmesi taktirinde takas ekranının sağ üst köşesinde mesajlaşma ekranına o kullanıcı ile iletişimini sağlayabilmen için bir sistem tasarladık. Bildirimlerinin açık olması taktirinde kullanıcı kabul ettiğinde sana bildirim düşecektir.", image: "sc4", image2: ""),
])

let guide3 = GuideModel(id: 3, title: "3- Top 50", subTitle: [
    GuideSubTitleModel(id: 1, text: "3.1 - Buradaki listelenen kişiler en çok yükleme yapan 50 kişi. Buraya çıktığınız taktirde ileride düzenleyeceğim etkinlik ve etkinlik içerisindeki ödüllere kazanma hakkın olacaktır.", image: "sc7", image2: "")
])

let guide4 = GuideModel(id: 4, title: "4- Profiliniz", subTitle: [
    GuideSubTitleModel(id: 1, text: "4.1 - Profilini senin için özelleştirdik. Sana gerekli bütün ayarlar ve fonksiyonlar burada. Buradan sana verdiğimiz referans kodunuzu arkadaşlarına paylaşabilir. Sağ üstteki kağıttan uçak simgesi ile ajans grubun ile mesajlaşabilir.  Bildirimlerine bakabilirsin. Genel bilgilerinizi buradan kontrol edebilirsiniz.", image: "sc6", image2: "")
])

let guide5 = GuideModel(id: 5, title: "5- Banka Bilgisi", subTitle: [
    GuideSubTitleModel(id: 1, text: "5.1 - Banka kartlarınızı veya kredi kartlarınızı ekleyerek, elmas kartlarınızı hızlı ve online ödeme ile alabilirsiniz.  Sizler için yapay zeka ekleyerek kredi veya banka kartlarınızı taratarak, kart numarası giremeden direk hızlıca yapabilrsiniz.", image: "sc8", image2: "sc9")
])

let guide6 = GuideModel(id: 6, title: "6- Kullanıdığınız Platform", subTitle: [
    GuideSubTitleModel(id: 1, text: "6.1 - Biliyorsunuz ki bir çok platform var yayıncı olabildiğiniz. Anlaşmalarımız hala devam ediyor. Yakında bir çok platform için hazır hale gelecektir.", image: "sc10", image2: "")
])

let guide7 = GuideModel(id: 7, title: "7- Meleklerin Görevi Nedir?", subTitle: [
    GuideSubTitleModel(id: 1, text: "7.1 - Melekler kullanid[iniz platformda, daha ,nce ban yem'; kullanicilari VIP puanlari ile açtirabilecek kişilerdir", image: "angelGuide", image2: "")
])

let guide8 = GuideModel(id: 8, title: "8- Şeytanların Görevi Nedir?", subTitle: [
    GuideSubTitleModel(id: 1, text: "8.1 - Platformlardan ban yemiş kullanıcılarda, meleklerden yardım isteme özelliğine sahip kullanıcılardır", image: "devilGuide", image2: "")
])

let guideData : [GuideModel] = [guide1,guide2,guide3,guide4,guide5,guide6,guide7,guide8]
