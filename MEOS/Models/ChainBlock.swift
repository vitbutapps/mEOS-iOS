//
//  ChainBlock.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import PromiseKit

struct ChainBlock: Decodable {
    let ref_block_prefix: UInt64
}


struct ChainBlocks: Decodable {
    let head_block_num: UInt32
    let ref_block_prefix: UInt64
}
