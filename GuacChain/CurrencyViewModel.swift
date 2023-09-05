//
//  CurrencyViewModel.swift
//  GuacChain
//
//  Created by Francesca MACDONALD on 2023-09-05.
//

import Foundation
//{
//    "id": 1,
//    "user": {
//        "user_name": "Tester",
//        "real_info": {
//            "full_name":"Jon Doe"
//        }
//    }
//}
//fileprivate struct RawServerResponse: Decodable {
//    struct User: Decodable {
//        var user_name: String
//        var real_info: UserRealInfo
//    }
//
//    struct UserRealInfo: Decodable {
//        var full_name: String
//    }
//
//
//    var id: Int
//    var user: User
//    var reviews_count: [Review]
//}

@MainActor
class CurrencyViewModel: ObservableObject {
    struct Result: Codable {
        var bpi: BPI
    }
    struct BPI: Codable {
        var USD: USD
        var GBP: GBP
        var EUR: EUR
    }
    struct USD: Codable {
        let rate_float: Double
    }
    struct GBP: Codable {
        let rate_float: Double
    }
    struct EUR: Codable {
        let rate_float: Double
    }
    
    var urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
    @Published var usdPerBTC = 0.0
    @Published var gbpPerBTC = 0.0
    @Published var eurPerBTC = 0.0
    
    func getData() async {
        guard let url = URL(string: urlString) else {
            print("ERROR: \(urlString) not a valid url string")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let decodedResponse = try? JSONDecoder().decode(Result.self, from: data) else {
                print("JSON ERROR: CCould not decode JSON returned from \(urlString)")
                return
            }
            usdPerBTC = decodedResponse.bpi.USD.rate_float
            gbpPerBTC = decodedResponse.bpi.GBP.rate_float
            eurPerBTC = decodedResponse.bpi.EUR.rate_float
            print("One bitccoin is currently worth: $\(usdPerBTC), ￡\(gbpPerBTC), €\(eurPerBTC)")
            
        } catch {
            print("ERROR: invalid data")
        }
        
    }
}
