//
//  AccountModel.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct TokensList: Decodable {
    let errno: Int32
    let errmsg: String
    let data: SymbolList
}


struct SymbolList: Decodable {
    let symbol_list: [TokenSymbols]
}

struct TokenSymbols: Decodable {
    let symbol: String
    let code: String
    let balance: String
}
