//
//  CurrencyInfo.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation

struct CurrencyInfo: Hashable {
    let code: String
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
