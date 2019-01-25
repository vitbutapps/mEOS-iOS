//
//  BPRealm.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import RealmSwift

class BPRealm: Object {
    @objc dynamic var  owner = ""
    @objc dynamic var  total_votes = ""
    @objc dynamic var  producer_key = ""
    @objc dynamic var  is_active:Int32 = 0
    @objc dynamic var  url = ""
    @objc dynamic var  unpaid_blocks:Int64 = 0
    @objc dynamic var  voted:Bool = false
    
    override static func primaryKey() -> String? {
        return "owner"
    }
}
