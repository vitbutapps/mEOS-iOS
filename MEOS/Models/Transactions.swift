//
//  Transactions.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import PromiseKit

struct Transactions: Decodable {
    let transaction_id: String?
    let error: TransactionError?
}


struct TransactionError: Decodable {
    let code: Int64
    let name: String
    let what: String
}


class TransactionsCreator{
    
    class func sign(head_block_num: UInt32, ref_block_prefix: UInt64, messages: [EOSAction]) -> Promise<String>  {
        return Promise { seal in
            let expiration = UInt32(Date().timeIntervalSince1970 + 60 * 60);
            guard let pk = try? PrivateKey(keyString: AccountData.data.privateKey) else {
                seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
                return
            }
            
            let pubsKey = PublicKey(privateKey: pk!)
            let ecKey = EosECKey(key: pk!.data, pub: pubsKey.data)
            
            let transaction = EOSTransaction()
            transaction.chainID = "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906".hexToData()! as NSData
            transaction.blockNum = head_block_num
            transaction.blockPrefix = ref_block_prefix
            transaction.netUsageWords = 0
            transaction.kcpuUsage = 0
            transaction.delaySec = 0
            transaction.expiration = expiration
            
            //let sendfrom = AccountData.data.accountName;
            for message in messages{
                transaction.actions.add(message)
            }
            
            if let sign = ecKey?.sign(transaction.getSignHash()){
                transaction.signature.add(sign.encoding(true))
            }else{
                seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
                return
            }
            
            if let jsonData = transaction.toJson(){
                var jsons:Dictionary<String, Any>!
                do{
                    jsons = try JSONSerialization.jsonObject(with: TransactionsCreator.json(from: jsonData)!.data(using: .utf8)!, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, Any>
                    if jsons != nil{
                        Network.pushTransaction(params: jsons).done{ answer in
                            if let error = answer.error{
                                seal.reject(NSError(domain: error.name, code: Int(error.code), userInfo: [NSLocalizedDescriptionKey: error.what]))
                                return
                            }else if let txID = answer.transaction_id{
                                seal.fulfill(txID)
                                return
                            }
                        }
                    }else{
                        seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
                        return
                    }
                    
                }catch{
                    seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
                    return
                }
                
            }else{
                seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
            }
            
            
        }
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}
