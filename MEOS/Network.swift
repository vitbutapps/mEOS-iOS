//
//  Network.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class Network{
    
    class func loadAccount(accountName:String)-> Promise<Account>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var headers = [String:String]()
        headers["Accept"] = "application/json"
        
        if let apikey = UserDefaults.standard.string(forKey: "apikey"){
            headers["XApiKey"] = apikey
        }
        
        let params:Parameters = ["account_name":accountName]
        return firstly {
            
            Alamofire.request("https://eos.greymass.com/v1/chain/get_account", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(Account.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func loadTokensList()-> Promise<TokensList>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            
            Alamofire.request("https://api.mobileeos.io/v1/account/get_token_list/"+AccountData.data.accountName, method: .get).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(TokensList.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func loadToken(symbol:String, code:String)-> Promise<Tokens>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var headers = [String:String]()
        return firstly {
            
            Alamofire.request("https://api.mobileeos.io/v1/ticker/price/\(code)/\(symbol)", method: .get, parameters: nil, headers: headers).responseData()
            //Alamofire.request("https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol="+symbol, method: .get, parameters: nil, headers: headers).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(Tokens.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func loadEosLastPrice()-> Promise<EosPrice>{
        
        
        
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return firstly {
            Alamofire.request("https://api.coinmarketcap.com/v2/ticker/1765/").responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(EosPrice.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    class func loadBPList()-> Promise<BPList>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var headers = [String:String]()
        headers["Accept"] = "application/json"
        
        let params:Parameters = ["json": true, "limit": 1000]
        return firstly {
            
            Alamofire.request("https://eos.greymass.com/v1/chain/get_producers", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(BPList.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func loadInfo()-> Promise<ChainInfo>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            Alamofire.request("https://eos.greymass.com/v1/chain/get_info", method: .post, parameters: nil, encoding: JSONEncoding.default).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(ChainInfo.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    class func loadBlock()-> Promise<ChainBlocks>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Promise { seal in
            Network.loadInfo().done{ chain in
                print(chain)
                let params:Parameters = ["block_num_or_id":chain.head_block_num]
                firstly {
                    Alamofire.request("https://eos.greymass.com/v1/chain/get_block", method: .post, parameters: params, encoding: JSONEncoding.default).responseData()
                    }.map(on: q) { data, rsp in
                        try JSONDecoder().decode(ChainBlock.self, from: data)
                    }.done{ blockInfo in
                        print(blockInfo)
                        let blockData = ChainBlocks(head_block_num: chain.head_block_num, ref_block_prefix: blockInfo.ref_block_prefix)
                        seal.fulfill(blockData)
                    }.catch{ error in
                        print(error.localizedDescription)
                        seal.reject(error)
                    }
            }
        }
    }
    
    
    class func pushTransaction(params: Dictionary<String, Any>)-> Promise<Transactions>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            Alamofire.request("https://eos.greymass.com/v1/chain/push_transaction", method: .post, parameters: params, encoding: JSONEncoding.default).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(Transactions.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    class func getAccountName(pubKey:String)-> Promise<AccountNames>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let params:Parameters = ["public_key":pubKey]
        return firstly {
            Alamofire.request("https://eos.greymass.com/v1/history/get_key_accounts", method: .post, parameters: params, encoding: JSONEncoding.default).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(AccountNames.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func getHistory()-> Promise<History>{
        let q = DispatchQueue.global()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        return firstly {
            Alamofire.request("https://api.mobileeos.io/v1/history", method: .get, parameters: nil, encoding: JSONEncoding.default).responseData()
            }.map(on: q) { data, rsp in
                try JSONDecoder().decode(History.self, from: data)
            }.ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
}
