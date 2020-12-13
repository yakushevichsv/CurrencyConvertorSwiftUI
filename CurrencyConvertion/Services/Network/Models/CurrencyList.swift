//
//  CurrencyList.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation

struct CurrencyList {
    typealias DicType = [String: String]
    let terms: URL?
    let privacy: URL?
    let currencies: DicType
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case terms
        case privacy
        case currencies
    }
}

// MARK: - Decodable
extension CurrencyList: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let terms = try container.decodeIfPresent(URL.self, forKey: .terms)
        let privacy = try container.decodeIfPresent(URL.self, forKey: .privacy)
        let currencies = try container.decode(CurrencyList.DicType.self, forKey: .currencies)
        //TODO: sort if needed...
        
        self.init(terms: terms,
                  privacy: privacy,
                  currencies: currencies)
    }
}
