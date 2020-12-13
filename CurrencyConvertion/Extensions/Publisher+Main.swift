//
//  Publisher+Main.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import Foundation
import Combine

extension Publishers {
  struct MainThreadPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber,
      Never == S.Failure, String == S.Input {

      //debugPrint("IsMainThread: \(Thread.isMainThread)")
      subscriber.receive(subscription: Subscriptions.empty)

      /*DispatchQueue.main.async {
        _ = subscriber.receive("test")
      }*/
    }
  }
}
