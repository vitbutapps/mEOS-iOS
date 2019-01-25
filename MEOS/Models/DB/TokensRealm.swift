//
//  TokensRealm.swift
//  MEOS
//
//  Created by Виталий on 21/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import RealmSwift

class TokensRealm: Object {
    @objc dynamic var  owner = ""
    @objc dynamic var  symbol = ""
    @objc dynamic var  code = ""
    @objc dynamic var  balance = ""
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
}
