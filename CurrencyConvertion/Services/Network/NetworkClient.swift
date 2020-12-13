//
//  NetworkClient.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation
import Combine

// MARK: - NetworkClient
final class NetworkClient {
    static let shared: NetworkClient = .init()
    
    let key: String
    let session: URLSession
    let baseURL: URL
    let decoder: JSONDecoder
    
    private init(baseURL: URL = URL(string: "https://api.currencylayer.com")!,
                 key: String = "f4b734bb620f367750a6c4fbb20dd029") {
        self.key = key
        self.baseURL = baseURL
        session = .shared
        decoder = .init()
    }
}

// MARK: - NetworkCurrencyType
extension NetworkClient: NetworkCurrencyType {
    func currencies() -> AnyPublisher<CurrencyList, ErrorInfo> {
        var urlComponents = URLComponents(url: baseURL,
                                          resolvingAgainstBaseURL: false)
        urlComponents?.path = "/list"
        urlComponents?.queryItems = [.init(name: "access_key",
                                          value: key)]
        let url = urlComponents?.url
        return session.dataTaskPublisher(for: url!).tryMap { [unowned self] (data, response) in
            let httpResponsePtr = response as? HTTPURLResponse
            
            if let errorInfo = try? self.decoder.decode(ErrorInfo.self, from: data) {
                throw errorInfo
            }
            
            guard let httpResponse = httpResponsePtr, httpResponse.statusCode == 200 else {
                throw ErrorInfo(code: httpResponsePtr?.statusCode,
                                info: String(data: data, encoding: .utf8))
            }
            do {
                return try self.decoder.decode(CurrencyList.self, from: data)
            } catch {
                throw ErrorInfo(code: nil,
                                info: error.localizedDescription)
            }
        }
        .mapError({ (errorPtr) -> ErrorInfo in
            guard let error = errorPtr as? ErrorInfo else {
                debugPrint("\(#function) Error \(errorPtr)")
                return .empty
            }
            return error
        })
        .eraseToAnyPublisher()
    }
}

// MARK: - NetworkClientType
extension NetworkClient: NetworkClientType {}
