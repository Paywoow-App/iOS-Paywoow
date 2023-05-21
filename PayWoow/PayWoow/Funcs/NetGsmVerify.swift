//
//  NetGsmVerify.swift
//  Customer
//
//  Created by İsa Yılmaz on 5/11/22.
//

import SwiftUI
import Foundation

func sendCode(code: String, number: String, header: String, usercode: String, password: String){
    guard let url = URL(string: "https://api.netgsm.com.tr/sms/send/otp") else {return}
    var xml = ""
    if number.first == "5" {
        xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Bu iki faktörlü doğrulama kodunu kimse ile paylaşmayınız. Verification Code :  \(code)]]></msg><no>0\(number)</no></body></mainbody>"
    }
    else {
        xml = "<mainbody><header><usercode>\(usercode)</usercode><password>\(password)</password><msgheader>\(header)</msgheader></header><body><msg><![CDATA[Bu iki faktörlü doğrulama kodunu kimse ile paylaşmayınız. Verification Code :  \(code)]]></msg><no>\(number)</no></body></mainbody>"
    }
    
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = xml.data(using: .utf8)
    request.setValue("text/xml", forHTTPHeaderField:  "Content-Type")
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { dat, res, err in
        print(String(data: dat!, encoding: .utf8)!)

        if err == nil, let data = dat, let response = res as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    print(String(data: data, encoding: .utf8) ?? "")
            addCountNetGSM()
                } else {
                    print("Status code 404")
                }

    }.resume()
    
    
}
