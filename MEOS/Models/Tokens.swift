//
//  Tokens.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct Tokens: Decodable {
    let code: Int32
    let data: TokenData
}

struct TokenData: Decodable {
    let symbol: String
    let price: Decimal
}

/*struct TokenStatus: Decodable {
    let timestamp: String
    let error_code: Int32
    let error_message: String?
    let elapsed: Int32
    let credit_count: Int32
}

struct SymbolInfo: Decodable {
    let id: Int32
    let name: String
    let symbol: String
    let slug: String
    let platform: TokenPlatform
    let quote: [String: QuoteInfo]
}

struct TokenPlatform: Decodable {
    let id: Int32
    let name: String
    let symbol: String
    let slug: String
}

struct QuoteInfo: Decodable {
    let price: Decimal
    let volume_24h: Decimal
    let percent_change_1h: Decimal
    let percent_change_24h: Decimal
    let percent_change_7d: Decimal
    let market_cap: Decimal
    let last_updated: String
}*/
