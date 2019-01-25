//
//  Account.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct Account: Decodable {
    let account_name: String//"g42tmojwg4ge",
    let head_block_num: Double //32739098,
    let head_block_time: String //"2018-12-18T12:34:44.500",
    let privileged: Bool // false,
    let last_code_update: String//"1970-01-01T00:00:00.000",
    let created: String//"2018-06-09T12:20:52.000",
    let core_liquid_balance: String//"0.0072 EOS",
    let ram_quota: Double//8148,
    let net_weight: Double//20000,
    let cpu_weight: Double//20000,
    
    let net_limit: NetLimit
    let cpu_limit: CpuLimit
    let ram_usage: Double
    
    let total_resources: TotalResources
    
    let voter_info: VoterInfo
    
    let self_delegated_bandwidth: SelfDelegatedBandwidth
    
    let refund_request: RefundRequest?
}


struct NetLimit: Decodable {
    let used: Double
    let available: Double
    let max: Double
}

struct CpuLimit: Decodable {
    let used: Double
    let available: Double
    let max: Double
}

struct TotalResources: Decodable{
    let owner: String
    let net_weight: String
    let cpu_weight: String
    let ram_bytes: Double
}


struct VoterInfo: Decodable {
    let owner: String
    //let proxy: String
    let producers: [String]
    let staked: Double
    let last_vote_weight: String
    let proxied_vote_weight: String
    let is_proxy: Double
}

struct SelfDelegatedBandwidth: Decodable {
    let from: String
    let to: String
    let net_weight: String
    let cpu_weight: String
}

struct RefundRequest: Decodable {
    let owner: String
    let request_time: String
    let net_amount: String
    let cpu_amount: String
}
