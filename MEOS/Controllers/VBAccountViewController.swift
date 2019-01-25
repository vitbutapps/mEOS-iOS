//
//  VBMainViewController.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit
import RealmSwift

class VBAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var accountView: VBAccountView!
    
    var symbol_list = [TokenSymbols]()
    
    var cells = [VBTokenTableViewCell]()
    
    let refreshControl = UIRefreshControl()

    var realm = try! Realm()
    
    func getDBData() -> Promise<Results<TokensRealm>>  {
        return Promise { seal in
            seal.fulfill(realm.objects(TokensRealm.self).filter("owner = %@", AccountData.data.accountName))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer(layer: self.gradientView.layer)
        gradient.frame = view.bounds;
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [
            UIColor(red: 31/255.0, green: 40.0/255.0, blue: 51/255.0, alpha: 1.0).cgColor,
            UIColor(red: 17/255.0, green: 36/255.0, blue: 126/255.0, alpha: 1.0).cgColor,
            //UIColor(red: 53/255.0, green: 72.0/255.0, blue: 119/255.0, alpha: 1.0).cgColor,
            
            ] as [Any]
        
        self.gradientView.layer.addSublayer(gradient)
        
        
        self.accountView.updateData(acc: AccountData.data)
        
        refreshControl.addTarget(self, action: #selector(self.loadData), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 212/255, green: 232/255, blue: 63/255, alpha: 1.0)
        self.tableView.addSubview(self.refreshControl)
        
        self.getDBData().done{ Tokens in
            self.cells = [VBTokenTableViewCell]()
            for token in Tokens{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "tokensCell") as! VBTokenTableViewCell
                cell.tokenInfo.setToken(token: token)
                self.cells.append(cell)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }.ensure {
                self.loadData()
        }
        
        
        
        
        
    }
    
    
    @objc func loadData(){
        firstly{
            Network.loadAccount(accountName: AccountData.data.accountName)
            }.done { account in
                print(account)
                AccountData.updateInfo(account: account, completion: { acc in
                    self.accountView.updateData(acc: acc)
                })
            }.catch{ error in
                print(error.localizedDescription)
        }
        
        firstly{
            Network.loadTokensList()
            }.done { tokens in
                
                var tlDBArr = [TokensRealm]()
                for token in tokens.data.symbol_list{
                    let TOKENTMP = TokensRealm()
                    TOKENTMP.owner = AccountData.data.accountName
                    TOKENTMP.symbol =  token.symbol
                    TOKENTMP.code =  token.code
                    TOKENTMP.balance =  token.balance
                    tlDBArr.append(TOKENTMP)
                }
                
                try! self.realm.write {
                    self.realm.add(tlDBArr, update: true)
                }
                
                self.getDBData().done{ Tokens in
                    self.cells = [VBTokenTableViewCell]()
                    for token in Tokens{
                        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tokensCell") as! VBTokenTableViewCell
                        cell.tokenInfo.setToken(token: token)
                        self.cells.append(cell)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }

            }.catch{ error in
                self.refreshControl.endRefreshing()
                print(error.localizedDescription)
        }
    }
    

    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells.count > 1{
            cells.remove(at: 0)
            TableViewHelper.EmptyMessage(message: "", viewController: self, tableView: self.tableView)
            return cells.count
        }
        TableViewHelper.EmptyMessage(message: "Your EOS asset list is currently empty.", viewController: self, tableView: self.tableView)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = cells[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 41/255, green: 53/255, blue: 67/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.isHighlighted = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
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
