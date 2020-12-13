//
//  NetworkClientType.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation
import Combine

// MARK: - NetworkCurrencyType
protocol NetworkCurrencyType {
    func currencies() -> AnyPublisher<CurrencyList, ErrorInfo>
}

protocol NetworkClientType: NetworkCurrencyType {}
