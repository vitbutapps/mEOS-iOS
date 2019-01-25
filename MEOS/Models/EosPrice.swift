//
//  EosPrice.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation

struct EosPrice: Decodable {
    let data: EosPriceData?
    let metadata: EosPriceDataMetaData
}

struct EosPriceData: Decodable {
    let id: Int64
    let name: String
    let symbol: String
    let website_slug: String
    let rank: Int32
    let circulating_supply: Double
    let total_supply: Double
    let quotes: EosPriceDataQuotes
    let last_updated: Double
}

struct EosPriceDataQuotes: Decodable {
    let USD: [String:Double]
}

struct EosPriceDataMetaData: Decodable {
    let timestamp: Double
    let error: String?
}
