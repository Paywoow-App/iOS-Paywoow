//
//  File.swift
//  Customer
//
//  Created by İsa Yılmaz on 4/29/22.
//

import SwiftUI

class BankCardDetectApi: ObservableObject{
    @AppStorage("bankName") var detectedBank : String = ""
    @AppStorage("cardType") var cardType : String = ""

    
    func detectCard(SixCode: String){
        guard let url = URL(string: "https://lookup.binlist.net/\(SixCode)") else {return}
        
        let task = URLSession.shared

        
        task.dataTask(with: URLRequest(url: url)) { dat, res, err in
            let response = try? JSONSerialization.jsonObject(with: dat!, options: JSONSerialization.ReadingOptions .mutableContainers) as! Dictionary<String, Any>
            
            if let bank = response?["bank"] as? Dictionary<String, Any> {
                if let name = bank["name"] as? String {
                    self.detectedBank = name
                    print("card: \(self.detectedBank)")
                }
                
                
            }
            
            if let cardType = response?["scheme"] as? String {
                self.cardType = cardType
                print("card: \(self.cardType)")
            }
          
        }
        .resume()
    }
}
