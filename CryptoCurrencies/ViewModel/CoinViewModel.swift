//
//  CoinViewModel.swift
//  CryptoCurrencies
//
//  Created by Kapil Shivhare on 9/27/24.
//

import Foundation
import Combine

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    
    private let coinService = CoinService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //getCoins()
        getCoinsUsingCombine()
    }
    
    func getCoins() {
        Task {
            do {
                let coins = try await coinService.fetchCoins()
                
                await MainActor.run {
                    self.coins = coins
                }
            } catch {
                print("Something went wront: \(error)")
            }
            
        }
    }
    
    func getCoinsUsingCombine() {
        coinService.fetchCoinsWithCombine()
            .sink { _ in
            } receiveValue: { [weak self] coins in
                self?.coins = coins
            }
            .store(in: &self.cancellables)

    }
}
