//
//  IAPServices.swift
//  PayWoow
//
//  Created by İsa Yılmaz on 7/6/22.
//

import SwiftUI
import StoreKit
import Firebase

class IAPServices: ObservableObject {
    @Published var result : String = ""
    var products : [Product] = []
    
    func fetchProducts(){
        async{
            do {
                let products = try await Product.products(for: ["com.paywoow.musteri.gold","com.paywoow.musteri.black", "com.paywoow.musteri.silver"])
                print(products)
                self.products = products
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func purchase(whichOne: Int) {
        if whichOne == 1 {
            async {
                do {
                    if products.contains(where: {$0.id == "com.paywoow.musteri.silver"}) {
                        print("silver")
                        guard let product = products.first(where: {$0.id == "com.paywoow.musteri.silver"}) else {return}
                        let result = try await product.purchase()
                        switch result{
                            
                        case .success(let verification):
                            
                            switch verification {
                                
                            case .verified(let transaction):
                                print(transaction.productID)
                                writeToDatabase(cardType: "VIP SILVER", docID: "VIPSILVER")
                                break
                            case .unverified(let transaction):
                                self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                                break
                            }
                            
                            break
                            
                        case .userCancelled:
                            self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                            break
                        case .pending:
                            break
                        @unknown default:
                            break
                        }
                    } else {
                       //item could not be found
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        else if whichOne == 2 {
            async {
                do {
                    if products.contains(where: {$0.id == "com.paywoow.musteri.black"}) {
                        print("black")
                        guard let product = products.first(where: {$0.id == "com.paywoow.musteri.black"}) else {return}
                        let result = try await product.purchase()
                        switch result{
                            
                        case .success(let verification):
                            
                            switch verification {
                                
                            case .verified(let transaction):
                                print(transaction.productID)
                                writeToDatabase(cardType: "VIP BLACK", docID: "VIPBLACK")
                                break
                            case .unverified(let transaction):
                                self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                                break
                            }
                            
                            break
                            
                        case .userCancelled:
                            self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                            break
                        case .pending:
                            break
                        @unknown default:
                            break
                        }
                    } else {
                       //item could not be found
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        else if whichOne == 3 {
            async {
                do {
                    if products.contains(where: {$0.id == "com.paywoow.musteri.gold"}) {
                        print("gold")
                        guard let product = products.first(where: {$0.id == "com.paywoow.musteri.gold"}) else {return}
                        let result = try await product.purchase()
                        switch result{
                            
                        case .success(let verification):
                            
                            switch verification {
                                
                            case .verified(let transaction):
                                print(transaction.productID)
                                writeToDatabase(cardType: "VIP GOLD", docID: "VIPGOLD")
                                break
                            case .unverified(let transaction):
                                self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                                break
                            }
                            
                            break
                            
                        case .userCancelled:
                            self.result = "Ödemeniz Red Edildi! Lütfen daha sonra tekrar deneyiniz"
                            break
                        case .pending:
                            break
                        @unknown default:
                            break
                        }
                    } else {
                       //item could not be found
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func writeToDatabase(cardType : String, docID: String){
        let ref = Firestore.firestore()
        let requiredNumbers = Int.random(in: 100000000 ... 999999999)
        let cardNumber = "\(7299669)\(requiredNumbers)"
        let cardPassword = Auth.auth().currentUser!.uid
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let dayAndMonth = formatter.string(from: date)
        let expiryDate = "\(dayAndMonth).\(2027)"
        let data = [
            "cardNo" : cardNumber,
            "cardPassword" : cardPassword,
            "cardType" : cardType,
            "expiryDate" : expiryDate,
            "isActivated" : false,
            "totalPrice" : 0,
            "twoFactor" : false
        ] as [String : Any]
        ref.collection("Users").document(Auth.auth().currentUser!.uid).collection("VIPCard").document(docID).setData(data, merge: true)
        
        ref.collection("Users").document(Auth.auth().currentUser!.uid).setData(["vipType" : docID], merge: true) // complated func
        print("Veri tabanina yazildi")
        
        
        if docID == "VIPGOLD" {
            ref.collection("Users").document(Auth.auth().currentUser!.uid).setData([
                "casper" : true
            ], merge: true)
        }
    }
}


struct CityTownModel : Codable, Hashable{
    var bolge: String
    var il: String
    var plaka: Int
    var ilce : String
}

class DataObserv: ObservableObject {
    @Published var list = [CityTownModel]()
    @Published var cityList : [String] = []
    @Published var townList : [String] = []
    
    init(){
        
        let path = Bundle.main.path(forResource: "il-ilce", ofType: "json")
        let jsonData = NSData(contentsOfMappedFile: path!)
        
        let data = jsonData?.base64EncodedString()
        let base64Encoded = data
        let decodedData = Data(base64Encoded: base64Encoded!)
        let decodedString = String(data: decodedData!, encoding: .utf8)!
        let jsonDecode =  try! JSONDecoder().decode([CityTownModel].self, from: decodedData!)
        self.list = jsonDecode
        
        for doc in list {
            if !self.cityList.contains(where: { $0 == "\(doc.il)"}) {
                self.cityList.append(doc.il)
            }
        }
    }
    
    func findTowns(cityInput : String){
        self.townList.removeAll()
        for doc in list {
            if cityInput == doc.il {
                if !self.townList.contains(where: { $0 == "\(doc.ilce)"}) {
                    self.townList.append(doc.ilce)
                }
            }
        }
    }
}
