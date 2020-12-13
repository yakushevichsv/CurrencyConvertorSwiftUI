//
//  ErrorInfo.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation

// MARK: - ErrorInfo
struct ErrorInfo: Error {
    let code: Int? //"code"
    let info: String?  /*"info": "Your monthly usage limit has been reached. Please upgrade your subscription plan." */
    var erorCode: CurrencyErrorCode? { code.flatMap { CurrencyErrorCode(rawValue: $0)} }
    
    static let empty: Self = .init(code: nil,
                                     info: nil)
    var isNotEmpty: Bool { code != nil || info != nil }
}

enum CurrencyErrorCode: Int, CaseIterable {
    case monthlyLimitReached = 104
}

// MARK: - Decodable
extension ErrorInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case code
        case info
        case error
    }
    
    init(from decoder: Decoder) throws {
        let containerTop = try decoder.container(keyedBy: CodingKeys.self)
        let container = try containerTop.nestedContainer(keyedBy: CodingKeys.self,
                                                         forKey: .error)
        let code = try container.decodeIfPresent(Int.self, forKey: .code)
        let info = try container.decodeIfPresent(String.self, forKey: .info)
        self.init(code: code,
                  info: info)
    }
}
