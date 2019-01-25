//
//  ChainInfo.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import PromiseKit

struct ChainInfo: Decodable {
    let server_version: String
    let chain_id: String
    let head_block_num: UInt32
    let last_irreversible_block_num: Double
    let last_irreversible_block_id: String
    let head_block_id: String
    let head_block_time: String
    let head_block_producer: String
    let virtual_block_cpu_limit: Double
    let virtual_block_net_limit: Double
    let block_cpu_limit: Double
    let block_net_limit: Double
    let server_version_string: String
}
