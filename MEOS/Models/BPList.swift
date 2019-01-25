//
//  BPList.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import PromiseKit



struct BPList:Decodable {
    let rows: [BPInfo]
    let total_producer_vote_weight: String
}

struct BPInfo:Decodable{
    let owner: String
    let total_votes: String
    let producer_key: String
    let is_active: Int32
    let url: String
    let unpaid_blocks: Int64
    //let last_claim_time: String?
    //let location: Int32?
}
