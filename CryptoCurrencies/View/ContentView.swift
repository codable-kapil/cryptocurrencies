//
//  ContentView.swift
//  CryptoCurrencies
//
//  Created by Kapil Shivhare on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = CoinViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.coins) { coin in
                    HStack {
                        Text("\(coin.marketCapRank ?? 0)")
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                            .padding()
                        
                        AsyncImage(url: URL(string: coin.image ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    placeholder: {
                        
                    }.frame(width: 50)
                        
                        VStack(alignment: .leading, content: {
                            Text(coin.name ?? "Bitcoin")
                                .fontWeight(.semibold)
                            Text("$\(coin.currentPrice ?? 25000.0)")
                                .foregroundStyle(.secondary)
                        })
                        .padding()
                    }
                }
            }.navigationTitle("Coins")
        }
    }
}

#Preview {
    ContentView()
}
