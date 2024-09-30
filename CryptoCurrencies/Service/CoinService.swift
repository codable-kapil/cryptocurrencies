//
//  CoinService.swift
//  CryptoCurrencies
//
//  Created by Kapil Shivhare on 9/27/24.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}

class CoinService {
    
    private static let enpointURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
    private var cancellable = Set<AnyCancellable>()
    
    func fetchCoins() async throws -> [Coin] {
        guard let coinURL = URL(string: Self.enpointURL) else { throw APIError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: coinURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw APIError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Coin].self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
    
    func fetchCoinsWithCombine() -> Future<[Coin], APIError> {
        return Future { promise in
            guard let coinURL = URL(string: Self.enpointURL) else { return promise(.failure(APIError.invalidURL)) }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            URLSession.shared.dataTaskPublisher(for: coinURL)
                .tryMap { (data, response) in
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw APIError.invalidResponse }
                    return data
                }.decode(type: [Coin].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Finished")
                    case .failure(let error):
                        print("Failure: \(error)")
                    }
                } receiveValue: { coins in
                    promise(.success(coins))
                }
                .store(in: &self.cancellable)
            }
        }
}
