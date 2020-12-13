//
//  CurrencyViewModel.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation
import Combine

final class CurrencyViewModel: ObservableObject {
    private let currencyClient: NetworkCurrencyType
    private (set)var setOp: Set<AnyCancellable>
    private (set)var currenciesOp: AnyCancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    @Published private (set)var currenciesInfo = [CurrencyInfo]()
    @Published var errorMessageSubject: String? = nil
    @Published var loadingSubject: Bool = false
    
    init(currencyClient: NetworkCurrencyType = NetworkClient.shared) {
        self.currencyClient = currencyClient
        setOp = .init()
    }
}

//MARK: - API
extension CurrencyViewModel {
    private func startLoading() {
        loadingSubject = true
        errorMessageSubject = nil
    }
    
    private func endLoading(errorMessage message: String?) {
        loadingSubject = false
        errorMessageSubject = message
    }
    
    private func loadCurrencies(){
        startLoading()
        let publisher = currencyClient.currencies().map { (list) -> [CurrencyInfo] in
            let result = list.currencies.sorted { (tuple1, tuple2) -> Bool in
                tuple1.key < tuple2.key
            }
            return result.map { CurrencyInfo(code: $0.key,
                                             name: $0.value) }
        }
        
        let op = publisher.receive(on: DispatchQueue.main).sink(receiveCompletion: {  [unowned self] (result) in
            let message: String?
            switch result {
            case .failure(let error):
                message = error.info
            default:
                message = nil
            }
            self.endLoading(errorMessage: message)
            self.currenciesOp = nil
        }, receiveValue: { [unowned self] (info) in
            debugPrint("!!! Info \(info)")
            self.currenciesInfo = info
        })
        currenciesOp = op
        op.store(in: &setOp)
    }
    
    func onViewWillAppear() {
        guard currenciesOp == nil else { return }
        loadCurrencies()
    }
}
