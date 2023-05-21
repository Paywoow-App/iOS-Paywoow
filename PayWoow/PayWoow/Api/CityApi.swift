//
//  CityApi.swift
//  Customer
//
//  Created by İsa Yılmaz on 4/28/22.
//

import Foundation

struct CityModel: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case bolge
        case id
        case il
        case ilce
        case plaka
    }
    
    var bolge : String
    var id: Int
    var il: String
    var ilce: String
    var plaka: Int
}

class CityJsonApi: ObservableObject  {
    @Published var codes = [CityModel]()
   
    init(){
//        loadData()
    }
//
//    func loadData()  {
//        let parm = " {"bolge": "EGE","id": 901,"il": "MANİSA","ilce": "ŞEHZADELER","plaka": 45},{"bolge": "EGE","id": 902,"il": "MANİSA","ilce": "YUNUSEMRE","plaka": 45}"
//
//        do {
//            // make sure this JSON is in the format we expect
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                // try to read out a string array
//                if let names = json["names"] as? [String] {
//                    print(names)
//                }
//            }
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//        }
//
//    }
     
}

//
//struct CityModel: Codable, Identifiable {
//    enum CodingKeys: CodingKey {
//        case bolge
//        case id
//        case il
//        case ilce
//        case plaka
//    }
//
//    var bolge : String
//    var id: Int
//    var il: String
//    var ilce: String
//    var plaka: Int
//}
//
//class CityJsonApi: ObservableObject  {
//    @Published var codes = [CityModel]()
//
//    init(){
//        loadData()
//    }
//
//    func loadData()  {
//        guard let url = Bundle.main.url(forResource: "il-ilce", withExtension: "json")
//            else {
//                print("Json file not found")
//                return
//            }
//        DispatchQueue.main.async {
//
//            let data = try? Data(contentsOf: url)
//            let jsonResponse = try? JSONDecoder().decode([CityModel].self, from: data!)
//            print(String(data: data!, encoding: .utf8)!)
//            self.codes = jsonResponse!
//        }
//
//    }
//
//}
