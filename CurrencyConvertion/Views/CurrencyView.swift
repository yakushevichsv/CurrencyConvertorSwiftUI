//
//  CurrencyView.swift
//  CurrencyConvertion
//
//  Created by Siarhei Yakushevich on 13.12.20.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject var model = CurrencyViewModel()
    
    var body: some View {
        ZStack {
            ActivityIndicatorView(isAnimating: .init(get: {
                self.model.loadingSubject == true
            }, set: { (newValue) in
                
            }))
            .frame(width: 50, height: 50)
            
            Text("Hello, world!")
                .padding()
                .onAppear(perform: model.onViewWillAppear)
                .alert(isPresented: .init(get: {
                    self.model.errorMessageSubject?.isEmpty == false
                }, set: { (value) in
                    
                }), content: {
                    Alert(title: Text("Error"),
                          message: Text(self.model.errorMessageSubject!), //Text("Failed to load"),
                          dismissButton: .default(Text("OK")))
                })
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
