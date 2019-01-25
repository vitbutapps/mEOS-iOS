//
//  VBNetworksViewController.swift
//  MEOS
//
//  Created by Виталий on 24/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit

class VBNetworksViewController: UIViewController, HalfModalPresentable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    let networkName = ["Greymass", "CryptoLions", "EosAzia", "EosNewYork"]
    let networkUrl = ["http://eos.greymass.com", "http://bp.cryptolions.io", "http://api1.eosasia.one", "http://api.eosnewyork.io"]
    

    var delegate:SelectAssetDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.getDBData().done{ Tokens in
            self.cells = [VBTokenTableViewCell]()
            
            for token in Tokens{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "netCell") as! VBTokenTableViewCell
                cell.tokenInfo.setToken(token: token)
                self.cells.append(cell)
            }
            self.tableView.reloadData()
        }*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.networkName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "netCell") as! VBNetowrksTableViewCell
        
        cell.netName.text = self.networkName[indexPath.row]
        cell.netURL.text = self.networkUrl[indexPath.row]
        
        /*let cell = cells[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 41/255, green: 53/255, blue: 67/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.isHighlighted = false*/
        
        return cell//cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let cell = cells[indexPath.row]
        
        if let token = cell.tokenInfo.tokenInfo{
            self.delegate?.selectedAsset(token: token)
            dismiss(animated: true, completion: nil)
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
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
