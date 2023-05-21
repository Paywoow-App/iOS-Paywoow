/*
 if self.result == "Beklemede" {
     
     RoundedRectangle(cornerRadius: 4)
         .fill(Color.black)
     
     Text("Beklemede")
         .foregroundColor(.white)
         .font(.system(size: 14))
 }
 else if self.result == "İşleme Alındı" {
     RoundedRectangle(cornerRadius: 4)
         .fill(Color.init(red: 172 / 255, green: 152 / 255, blue: 84 / 255))
     
     Text("İşleme Alındı")
         .foregroundColor(.white)
         .font(.system(size: 14))
 }
 
 else if self.result == "Yükleme Başarılı" {
     RoundedRectangle(cornerRadius: 4)
         .fill(LinearGradient(colors: [Color.init(red: 121 / 255, green: 203 / 255, blue: 195 / 255), Color.init(red: 117 / 255, green: 219 / 255, blue: 209 / 255)], startPoint: .top, endPoint: .bottom))
     
     Text("Yükleme Başarılı")
         .foregroundColor(.white)
         .font(.system(size: 14))
 }
 
 else if self.result == "Red Edildi" {
     RoundedRectangle(cornerRadius: 4)
         .fill(Color.red)
     
     Text("Reddedildi")
         .foregroundColor(.white)
         .font(.system(size: 14))
 }
 
 else if self.result == "İşlem Onaylandı" {
     RoundedRectangle(cornerRadius: 4)
         .fill(Color.purple)
     
     Text("İşlem Onaylandı")
         .foregroundColor(.white)
         .font(.system(size: 14))
 }
 
 
 
 MARK: Siparisler
 
 .contextMenu{
     
     if self.result == "Beklemede" {
         
         
         Button {
             let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "İşleme Alındı", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year]  as [String : Any]
             
             UIPasteboard.general.string = self.id
             
             ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).setData(transferData)
             
             ref.collection("Bayii").document(dealler).collection("Orders").document(docId).delete()
             
             ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "İşleme Alındı"])
             
             let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz işleme alındı ."] as [String : Any]
             let notifyDocId = UUID().uuidString
             
             ref.collection("Users").document(userId).collection("Notifications").document(notifyDocId).setData(userNotify, merge: true)
             
             if self.dealler == "FerinaValentino" {
                 ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOn"], merge: true)
             }
             else {
                 ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOn"], merge: true)
             }
             
             sendPushNotify(title: "İşleme Alındı!", body: "Onaylandığında hesabınıza yüklenecektir", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
             
         } label: {
             Label("İşleme Alındı", systemImage: "timer")
         }
         .onAppear {
             self.tokenResearcher.findToken(userId: self.userId)
         }
     } else if self.result == "İşleme Alındı" {
         
         Button {
             
             let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "Red Edildi", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year] as [String : Any]
             
             ref.collection("Bayii").document(dealler).collection("DeclinedOrders").document(docId).setData(transferData)
             
             ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).delete()
             
             ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "Red Edildi"])
             
             let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz red edildi."] as [String : Any]
             
             let notifyDocId = UUID().uuidString
             
             ref.collection("Users").document(userId).collection("Notifications").document(notifyDocId).setData(userNotify, merge: true)
             
             if self.dealler == "FerinaValentino" {
                 ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOff"], merge: true)
             }
             else {
                 ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOff"], merge: true)
             }
             sendPushNotify(title: "Red Edildi!", body: "Bilgilerinizin güncelliğinden dolayı red edildi", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
             
         } label: {
             Label("Red Edildi", systemImage: "xmark")
         }
         .onAppear {
             self.tokenResearcher.findToken(userId: self.userId)
         }
         
         
         Button {
             
             let billDocId = UUID().uuidString
             let transferData = ["fullname" : self.fullname, "timeDate" : self.timeDate, "bigoId" : self.id, "transfer" : self.transfer, "diamond" : self.diamond, "price" : self.price, "userid" : userId,"pfImage": self.pfImage, "result" : "Yükleme Başarılı", "signatureURL" : self.signatureURL, "levelPoint" : levelPoint, "hexCodeTop": hexCodeTop, "hexCodeBottom": hexCodeBottom, "timeStamp" : Int(timeStamp), "month" : month, "year" : year] as [String : Any]
             
             ref.collection("Bayii").document(dealler).collection("AcceptedOrders").document(docId).setData(transferData)
             
             ref.collection("Bayii").document(dealler).collection("ProcessedOrders").document(docId).delete()
             
             ref.collection("Users").document(userId).collection("Orders").document(docId).updateData(["result" : "Yükleme Başarılı"])
             
             let userNotify = ["bayiiId" : dealler, "bayiiName" : self.bayiiInfo.bayiiName, "bayiiImage" : self.bayiiInfo.bayiiImage, "date" : timeDate, "message" : "Siparişiniz Onaylandı"] as [String : Any]

             ref.collection("Users").document(userId).collection("Notifications").document(billDocId).setData(userNotify, merge: true)

             
             let newBalance = self.bayiiInfo.balance - self.diamond
             ref.collection("Bayii").document(dealler).setData(["balance" : newBalance], merge: true)
             
             let plusTotalBalance = self.bayiiInfo.totalBalance + self.price
             ref.collection("Bayii").document(dealler).setData(["totalBalance" : plusTotalBalance], merge: true)
             
             let step1 = self.price / 100 + self.usersGiftStore.userGift
             
             ref.collection("Users").document(self.userId).setData(["gift" : step1], merge: true) // turn off

             if self.dealler == "FerinaValentino" {
                 ref.collection("Users").document(self.userId).setData(["customerFerina" : "turnOff"], merge: true)
             }
             else {
                 ref.collection("Users").document(self.userId).setData(["customerDiamond" : "turnOff"], merge: true)
                 
                 
             }
             
             sendPushNotify(title: "Yükleme Başarılı!!", body: "Tebrikler! Elmasınız \(self.id) hesabınıza tanımlandı.", userToken: tokenResearcher.fetchedToken, sound: "pay.mp3")
             
             //Caalculate the new level point
             
             let divide100 = self.diamond / 100
             let percent10 = divide100 * 10
             let newLevelPoint = percent10 + self.levelPoint
             ref.collection("Users").document(self.userId).setData(["levelPoint" : newLevelPoint], merge: true)
             
             
             findAndWrite()

             
             
         } label: {
             Label("Yükleme Başarılı", systemImage: "checkmark")
         }
         .onAppear {
             self.tokenResearcher.findToken(userId: self.userId)
             self.usersGiftStore.getData(userid: self.userId)
         }
     }
     else{
         
     }
     
 }

 
 
 
 
 
 MARK: TabView orders
 
 WaitingOrders(dealler: dealler).tag(0)
 
 ProcessedOrders(dealler: dealler).tag(1)
 
 AcceptedOrders(searchBar: $searchBar, dealler: dealler).tag(2)
 
 DeclinedOrders(dealler: dealler).tag(3)
 
 */
