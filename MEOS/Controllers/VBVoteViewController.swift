//
//  VBVoteViewController.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit
import RealmSwift

class VBVoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var gradientView: UIView!

    @IBOutlet weak var BPButton: UIButton!
    @IBOutlet weak var VOTEDButton: UIButton!
    
    @IBOutlet weak var totalVotedLabel: UILabel!
    
    var isBP = true
    
    var bpLineView: UIView!
    var VotedLineView: UIView!
    
    var countVoted = 0
    
    var realm = try! Realm()
    
    var BlockBproduccers:Results<BPRealm>?
    
    
    func getDBData(_ keyword: String = "") -> Promise<Results<BPRealm>>  {
        return Promise { seal in
            
            if(keyword == ""){
                if(!isBP){
                    seal.fulfill(realm.objects(BPRealm.self).filter("is_active > 0 AND voted = true"))
                    return
                }else{
                    seal.fulfill(realm.objects(BPRealm.self).filter("is_active > 0"))
                    return
                }
                
            }else{
                if(!isBP){
                    seal.fulfill(realm.objects(BPRealm.self).filter("is_active > 0 AND owner CONTAINS %@ AND voted = true", keyword.lowercased()))
                    return
                }else{
                    seal.fulfill(realm.objects(BPRealm.self).filter("is_active > 0 AND owner CONTAINS %@", keyword.lowercased()))
                    return
                }
            }
        }
    }

    func updateCounter(){
        self.countVoted = AccountData.data.producers.count
        self.totalVotedLabel.text = "\(self.countVoted)/30 total votes cast"
    }
    
    
    func getDBInfo(_ keywords: String = ""){
        firstly{
            getDBData(keywords)
            }.done{ data in
                self.BlockBproduccers = data
                self.tableView.reloadData()
            }.catch{ error in
                print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.searchBar.delegate = self
        
        self.isBP = true
        
        
        self.getDBInfo()
        
        self.bpLineView = UIView(frame: CGRect(x: 0, y: 30, width: BPButton.frame.size.width, height: 4))
        self.VotedLineView = UIView(frame: CGRect(x: 0, y: 30, width: BPButton.frame.size.width, height: 4))
        
        self.bpLineView.backgroundColor=UIColor(red: 82/255, green: 96/255, blue: 147/255, alpha: 1)
        self.VotedLineView.backgroundColor=UIColor(red: 82/255, green: 96/255, blue: 147/255, alpha: 1)
        
        BPButton.addSubview(bpLineView)
        
        let gradient = CAGradientLayer(layer: self.gradientView.layer)
        gradient.frame = view.bounds;
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [
            UIColor(red: 31/255.0, green: 40.0/255.0, blue: 51/255.0, alpha: 1.0).cgColor,
            UIColor(red: 17/255.0, green: 36/255.0, blue: 126/255.0, alpha: 1.0).cgColor,
            ] as [Any]
        
        self.gradientView.layer.addSublayer(gradient)
        
        self.updateCounter()
        
        firstly{
            Network.loadBPList()
            }.done { bpList in
                var bpDBArr = [BPRealm]()
                for BP in bpList.rows{
                    let BPTMP = BPRealm()
                    BPTMP.owner = BP.owner
                    BPTMP.total_votes =  BP.total_votes
                    BPTMP.producer_key =  BP.producer_key
                    BPTMP.is_active =  BP.is_active
                    BPTMP.url =  BP.url
                    BPTMP.unpaid_blocks = BP.unpaid_blocks
                    //print(AccountData.data.producers)
                    if AccountData.data.producers.contains(where: {$0 == BP.owner}) {
                        BPTMP.voted = true
                    } else {
                       BPTMP.voted = false
                    }
                    
                    bpDBArr.append(BPTMP)
                }
                AccountData.data.totalProducerVoteWeight = bpList.total_producer_vote_weight
                
                try! self.realm.write {
                    self.realm.add(bpDBArr, update: true)
                }
            }.ensure {
                firstly{
                    self.getDBData()
                    }.done{ data in
                        self.BlockBproduccers = data
                        self.tableView.reloadData()
                }
            }
            .catch{ error in
                print(error.localizedDescription)
        }
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let BP = self.BlockBproduccers{
            return BP.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VBVoteTableViewCell", for: indexPath) as! VBVoteTableViewCell
        if let BP = self.BlockBproduccers{
            cell.mainView.setValue(BP: BP[indexPath.row])
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 18/255, green: 45/255, blue: 88/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.isHighlighted = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VBVoteTableViewCell", for: indexPath) as! VBVoteTableViewCell
        if let BP = self.BlockBproduccers{
            let bpstmp = BP[indexPath.row]
                
            try! self.realm.write {
                
                if(bpstmp.voted){
                    
                    if let index = AccountData.data.producers.index(where: {$0 == bpstmp.owner}){
                        AccountData.data.producers.remove(at: index)
                    }
                    
                    bpstmp.voted = false
                }else{
                    bpstmp.voted = true
                    AccountData.data.producers.append(bpstmp.owner)
                }
            }
            
            cell.mainView.setValue(BP: bpstmp)
        }
        tableView.reloadData()
        self.updateCounter()
        updateVoteInfo()
    }
    
    
    func updateVoteInfo(){
        firstly{
            pushVotting()
            }.done{ mess in
                print(mess)
            }.catch{ error in
                print(error.localizedDescription) 
        }
    }
    
    func pushVotting() -> Promise<String>  {
        return Promise { seal in
            let expiration = UInt32(Date().timeIntervalSince1970 + 60 * 60);
            firstly{
                Network.loadBlock()
                }.done{ data in
                    
                    
                    let sendfrom = AccountData.data.accountName;
                    
                    let proxy = "";
                    let runtoken = "eosio";
                    let tokenfun = "voteproducer";
                    
                    let message = EOSAction()
                    message.account = EOSAccountName(name: runtoken)
                    message.name = EOSAccountName(name: tokenfun)
                    message.authorization.add(EOSAccountPermission(string: sendfrom, permission: "active"))
                    
                    let mdata = EOSVoteProducerMessageData()
                    mdata.voter = EOSAccountName(name: sendfrom)
                    mdata.proxy = EOSAccountName(name: proxy)
                    
                    for producer in AccountData.data.producers{
                        if(producer != ""){
                            mdata.producers.add(EOSAccountName(name: producer))
                        }
                    }
                    
                    message.data = mdata
                    
                     TransactionsCreator.sign(head_block_num: data.head_block_num, ref_block_prefix: data.ref_block_prefix, messages: [message]).done { txID in
                        seal.fulfill(txID)
                        }.catch{ error in
                            print(error.localizedDescription)
                            seal.reject(error)
                    }
                }.catch{ error in
                    print(error.localizedDescription)
                    seal.reject(NSError(domain: "error", code: 100, userInfo: nil))
            }
        }
    }
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getDBInfo(searchText)
    }
    
    @IBAction func showBPList(_ sender: UIButton) {
        
        if(self.isBP == true){
            return
        }
        VotedLineView.removeFromSuperview()
        
        BPButton.addSubview(bpLineView)
        
        self.isBP = true
        
        self.getDBInfo()
    }
    
    @IBAction func showVotedList(_ sender: UIButton) {
        if(self.isBP != true){
            return
        }
        bpLineView.removeFromSuperview()
        VOTEDButton.addSubview(VotedLineView)
        
        self.isBP = false
        self.getDBInfo()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
