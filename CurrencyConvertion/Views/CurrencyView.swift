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
        Text("Hello, world!")
            .padding()
            .onAppear(perform: model.onViewWillAppear)
            .alert(isPresented: .init(get: { () -> Bool in
                return model.loadingSubject
            }, set: { (_) in
            }), content: {
                Alert(title: Text("Important message"),
                      message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
            })
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
