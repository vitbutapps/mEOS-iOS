//
//  VBSelectAssetsViewController.swift
//  MEOS
//
//  Created by Виталий on 22/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit
import RealmSwift

protocol SelectAssetDelegate {
    func selectedAsset(token:TokenSymbols)
}


class VBSelectAssetsViewController: UIViewController, HalfModalPresentable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var cells = [VBTokenTableViewCell]()
    var realm = try! Realm()
    
    var delegate:SelectAssetDelegate?
    
    func getDBData() -> Promise<Results<TokensRealm>>  {
        return Promise { seal in
            seal.fulfill(realm.objects(TokensRealm.self).filter("owner = %@", AccountData.data.accountName))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDBData().done{ Tokens in
            self.cells = [VBTokenTableViewCell]()

            for token in Tokens{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "tokensCell") as! VBTokenTableViewCell
                cell.tokenInfo.setToken(token: token)
                self.cells.append(cell)
            }
            self.tableView.reloadData()
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells.count > 1{
            //cells.remove(at: 0)
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
        
        return cell//cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        
        if let token = cell.tokenInfo.tokenInfo{
            self.delegate?.selectedAsset(token: token)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    @IBAction func maximizeButtonTapped(sender: AnyObject) {
        maximizeToFullScreen()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
}
