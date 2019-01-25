//
//  AccountData.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class AccountData{
    
    static var data:AccountData{
        get{
            return AccountData()
        }
    }
    
    var totalBalance:Double{
        get{
            return self.core_liquid_balance+(self.staked/10000)+self.refund
        }
    }
    
    var complition: Bool {
        get {
            
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.bool(forKey: "complition")
        }
        set {
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "complition")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    var privateKey:String{
        get {
            if let privKey = UserDefaults.standard.string(forKey: "privateKey"){
                return privKey
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "privateKey")
            UserDefaults.standard.synchronize()
        }
    }
    var publicKey:String{
        get {
            if let pubKey = UserDefaults.init(suiteName: "group.com.vitbut.meos")?.string(forKey: "publicKey"){
                return pubKey
            }
            return ""
        }
        set {
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "publicKey")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    var accountName:String{
        get {
            if let accName = UserDefaults.init(suiteName: "group.com.vitbut.meos")?.string(forKey: "accountName"){
                return accName
            }
            return ""
        }
        set {
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "accountName")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var totalProducerVoteWeight:String{
        get {
            if let total_producer_vote_weight = UserDefaults.standard.string(forKey: "total_producer_vote_weight"){
                return total_producer_vote_weight
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "total_producer_vote_weight")
            UserDefaults.standard.synchronize()
        }
    }
    
    var passCode:String{
        get {
            if let pCode = UserDefaults.standard.string(forKey: "passCode"){
                return pCode
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "passCode")
            UserDefaults.standard.synchronize()
        }
    }
    
    var core_liquid_balance:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "core_liquid_balance")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "core_liquid_balance")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var ram_quota:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "ram_quota")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "ram_quota")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var ram_usage:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "ram_usage")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "ram_usage")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var net_weight:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "net_weight")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "net_weight")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var cpu_weight:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "cpu_weight")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "cpu_weight")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var created:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "created")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "created")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var price:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "price")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "price")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var privileged:Bool{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.bool(forKey: "privileged")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "privileged")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var staked:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "staked")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "staked")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var refund:Double{
        get{
            return UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "refund")
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue, forKey: "refund")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    
    var selfDelegatedBandwidth:[String:Double]{
        get{
            
            var SDB = ["net_weight": 0.0, "cpu_weight":0.0]
            //SDB["from"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "self_delegated_bandwidth_from")
            //SDB["to"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "self_delegated_bandwidth_to")
            SDB["net_weight"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "self_delegated_bandwidth_net_weight")
            SDB["cpu_weight"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "self_delegated_bandwidth_cpu_weight")
            return SDB
        }
        set{
            //UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["from"], forKey: "self_delegated_bandwidth_from")
            //UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["to"], forKey: "self_delegated_bandwidth_to")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["net_weight"], forKey: "self_delegated_bandwidth_net_weight")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["cpu_weight"], forKey: "self_delegated_bandwidth_cpu_weight")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    
    var net_limit:[String:Double]{
        get{
            
            var netLimit = ["used": 0.0, "available": 0.0, "max": 0.0]
            netLimit["used"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "net_limit_used")
            netLimit["available"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "net_limit_available")
            netLimit["max"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "net_limit_max")
            return netLimit
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["used"], forKey: "net_limit_used")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["available"], forKey: "net_limit_available")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["max"], forKey: "net_limit_max")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var cpu_limit:[String:Double]{
        get{
            var cpuLimit = ["used": 0.0, "available": 0.0, "max": 0.0]
            cpuLimit["used"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "cpu_limit_used")
            cpuLimit["available"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "cpu_limit_available")
            cpuLimit["max"] = UserDefaults.init(suiteName: "group.com.vitbut.meos")!.double(forKey: "cpu_limit_max")
            return cpuLimit
        }
        set{
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["used"], forKey: "cpu_limit_used")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["available"], forKey: "cpu_limit_available")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(newValue["max"], forKey: "cpu_limit_max")
            UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        }
    }
    
    var producers:[String]{
        get{
            if let producersTMP = UserDefaults.standard.string(forKey: "producers"){
                return producersTMP.components(separatedBy: "|")
            }
            return []
        }
        set{
            let imploded = newValue.joined(separator: "|")
            UserDefaults.standard.set(imploded, forKey: "producers")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func updateInfo(account: Account, completion : @escaping(_ accountSelf:AccountData) -> Void){
        
        self.data.privileged = account.privileged
        
        let created = account.created
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from:created){
            self.data.created = date.timeIntervalSince1970
        }
        
        let clb = account.core_liquid_balance
        let clbArr = clb.components(separatedBy: " ")
        if let bal = Double(clbArr[0]){
            self.data.core_liquid_balance = bal
        }
        
        self.data.ram_quota = account.ram_quota
        self.data.net_weight = account.net_weight
        self.data.cpu_weight = account.cpu_weight
        self.data.net_limit = ["used":account.net_limit.used, "max":account.net_limit.max, "available":account.net_limit.available]
        self.data.cpu_limit = ["used":account.cpu_limit.used, "max":account.cpu_limit.max, "available":account.cpu_limit.available]
        self.data.ram_usage = account.ram_usage
        self.data.producers = account.voter_info.producers
        self.data.staked = account.voter_info.staked
        
        //account.self_delegated_bandwidth.cpu_weight
        //account.self_delegated_bandwidth.net_weight
        
        var SDB = ["net_weight": 0.0, "cpu_weight":0.0]
        
        let SDBCW = account.self_delegated_bandwidth.cpu_weight
        let SDBCWArr = SDBCW.components(separatedBy: " ")
        if let bal = Double(SDBCWArr[0]){
            SDB["cpu_weight"] = bal*10000
        }
        
        let SDBBW = account.self_delegated_bandwidth.net_weight
        let SDBBWArr = SDBBW.components(separatedBy: " ")
        if let bal = Double(SDBBWArr[0]){
            SDB["net_weight"] = bal*10000
        }
        
        self.data.selfDelegatedBandwidth = SDB
        
        if let refaundRequest = account.refund_request{
            let refNet = refaundRequest.net_amount
            let refNetArr = refNet.components(separatedBy: " ")
            if let netRefBal = Double(refNetArr[0]){
                var refund = netRefBal
                let refCpu = refaundRequest.cpu_amount
                let refCpuArr = refCpu.components(separatedBy: " ")
                if let cpuRefBal = Double(refCpuArr[0]){
                    refund += cpuRefBal
                    print(refund)
                    self.data.refund = refund
                }
            }
        }else{
            self.data.refund = 0
        }
        completion(self.data)
    }
    
    class func  signOut(completion : @escaping() -> Void){
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set("", forKey: "privateKey")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set("", forKey: "publicKey")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set("", forKey: "accountName")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set("", forKey: "passCode")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "core_liquid_balance")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "ram_quota")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "ram_usage")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "net_weight")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_weight")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "created")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(false, forKey: "privileged")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(false, forKey: "complition")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "staked")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "net_limit_used")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "net_limit_available")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "net_limit_max")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_used")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_available")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_max")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_used")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_available")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set(0.0, forKey: "cpu_limit_max")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.set("", forKey: "moreProd")
        UserDefaults.init(suiteName: "group.com.vitbut.meos")?.synchronize()
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(TokensRealm.self))
        }
        
        completion()
    }

}
