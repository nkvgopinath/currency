//
//  ExchangeRateModel.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 29/11/24.
//

struct ExchangeRateModel: Codable {
    let result: String?
    let conversion_rates: [String: Double]?
}
