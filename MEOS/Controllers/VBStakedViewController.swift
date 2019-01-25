//
//  VBStakedViewController.swift
//  MEOS
//
//  Created by Виталий on 20/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit
import SCLAlertView

class VBStakedViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var stakedView: VBStakedView!
    
    @IBOutlet weak var cpuStakedField: UITextField!
    @IBOutlet weak var netStakedField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let gradient = CAGradientLayer(layer: self.gradientView.layer)
        gradient.frame = view.bounds;
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [
            UIColor(red: 31/255.0, green: 40.0/255.0, blue: 51/255.0, alpha: 1.0).cgColor,
            UIColor(red: 17/255.0, green: 36/255.0, blue: 126/255.0, alpha: 1.0).cgColor,
            ] as [Any]
        
        self.gradientView.layer.addSublayer(gradient)
        
        
        if let SDBBW = AccountData.data.selfDelegatedBandwidth["net_weight"] {
            netStakedField.text = "\((SDBBW/10000).rounded(toPlaces: 4))"
        }
        
        if let SDBCW = AccountData.data.selfDelegatedBandwidth["cpu_weight"] {
            cpuStakedField.text = "\((SDBCW/10000).rounded(toPlaces: 4))"
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setStakedEOSAction(_ sender: Any) {
        //self.updateStakedIfo()
        self.cleareDigital()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Cancel") {
            
        }
        alertView.addButton("Done") {
            self.updateStakedIfo()
        }
        alertView.showWarning("The balances enshrined EOS", subTitle: "Are you sure you want to change the values of Stacked?")
    }
    
    
    @IBAction func setEosStakedCpu(_ sender: UITextField) {
        if let text = sender.text{
            if text != ""{
                let swiftyString = text.replacingOccurrences(of: ",", with: ".")
                sender.text = swiftyString
                
                if let cpu = Double(swiftyString){
                    if(cpu > 0){
                        if let bandw = Double(self.netStakedField.text!){
                            if(bandw > 0){
                                //self.confirmButton.isEnabled = true
                                return
                            }
                        }
                    }
                }
            }
        }
        
        //self.confirmButton.isEnabled = false
    }
    
    @IBAction func setEosStakedBandw(_ sender: UITextField) {
        if let text = sender.text{
            if text != ""{
                let swiftyString = text.replacingOccurrences(of: ",", with: ".")
                sender.text = swiftyString
                if let bandw = Double(swiftyString){
                    if(bandw > 0){
                        if let cpu = Double(self.cpuStakedField.text!){
                            if(cpu > 0){
                                //self.confirmButton.isEnabled = true
                                return
                            }
                        }
                    }
                }
            }
        }
        //self.confirmButton.isEnabled = false
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        
        self.cleareDigital()
    }
    
    
    func cleareDigital(){
        if let setEosStakedCpu = cpuStakedField.text{
            if setEosStakedCpu != ""{
                let swiftyString = setEosStakedCpu.replacingOccurrences(of: ",", with: ".")
                
                if let bandw = Double(swiftyString){
                    cpuStakedField.text = "\(bandw)"
                }else{
                    cpuStakedField.text = "0.00"
                }
            }
        }
        
        if let setEosStakedNet = netStakedField.text{
            if setEosStakedNet != ""{
                let swiftyString = setEosStakedNet.replacingOccurrences(of: ",", with: ".")
                
                if let bandw = Double(swiftyString){
                    netStakedField.text = "\(bandw)"
                }else{
                    netStakedField.text = "0.00"
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.stakedView.updateValue()
    }
    
    func messageData(tokenfun:String, sendfrom: String, CPU_STAKED: Double, BAND_STAKED: Double) -> EOSAction/*EOSMessageData*/{
        let message = EOSAction()
        
        let CPU_STAKED_STR = String(format: "%.4f", CPU_STAKED)
        let BAND_STAKED_STR = String(format: "%.4f", BAND_STAKED)

        let mdata = EOSDelegatebwMessageData()
        mdata.from = EOSAccountName(name: AccountData.data.accountName)
        mdata.receiver = EOSAccountName(name: AccountData.data.accountName)
        mdata.stakeCpuQuantity = EOSAsset(string: "\(CPU_STAKED_STR) EOS")
        mdata.stakeNetQuantity = EOSAsset(string: "\(BAND_STAKED_STR) EOS")
        message.data = mdata

        message.account = EOSAccountName(name: "eosio")
        message.name = EOSAccountName(name: tokenfun)
        message.authorization.add(EOSAccountPermission(string: sendfrom, permission: "active"))
        return message
    }
    
    func generateMessage(cpuStaked: Double, netStaked: Double, sendfrom: String) -> [EOSAction]{
        var messages = [EOSAction]()
        var CPU_STAKED:Double = 0.0
        var BAND_STAKED:Double = 0.0
        
        CPU_STAKED = cpuStaked - (AccountData.data.selfDelegatedBandwidth["cpu_weight"]!/10000)
        BAND_STAKED = netStaked - (AccountData.data.selfDelegatedBandwidth["net_weight"]!/10000)
        
        if(CPU_STAKED < 0 && BAND_STAKED == 0){
            CPU_STAKED = (AccountData.data.selfDelegatedBandwidth["cpu_weight"]!/10000) - cpuStaked
            messages.append(messageData(tokenfun:"undelegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: 0))
        }else if(CPU_STAKED < 0 && BAND_STAKED < 0){
            CPU_STAKED = (AccountData.data.selfDelegatedBandwidth["cpu_weight"]!/10000) - cpuStaked
            BAND_STAKED = (AccountData.data.selfDelegatedBandwidth["net_weight"]!/10000) - netStaked
            messages.append(messageData(tokenfun:"undelegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: BAND_STAKED))
        }else if(CPU_STAKED < 0 && BAND_STAKED > 0){
            CPU_STAKED = (AccountData.data.selfDelegatedBandwidth["cpu_weight"]!/10000) - cpuStaked
            messages.append(messageData(tokenfun:"undelegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: 0))
            messages.append(messageData(tokenfun:"delegatebw", sendfrom: sendfrom, CPU_STAKED: 0, BAND_STAKED: BAND_STAKED))
        }else if(CPU_STAKED > 0 && BAND_STAKED < 0){
            BAND_STAKED = (AccountData.data.selfDelegatedBandwidth["net_weight"]!/10000) - netStaked
            messages.append(messageData(tokenfun:"undelegatebw", sendfrom: sendfrom, CPU_STAKED: 0, BAND_STAKED: BAND_STAKED))
            messages.append(messageData(tokenfun:"delegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: 0))
        }else if(CPU_STAKED > 0 && BAND_STAKED > 0){
            messages.append(messageData(tokenfun:"delegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: BAND_STAKED))
        }else if(CPU_STAKED > 0 && BAND_STAKED == 0){
            messages.append(messageData(tokenfun:"delegatebw", sendfrom: sendfrom, CPU_STAKED: CPU_STAKED, BAND_STAKED: 0))
        }else if(CPU_STAKED == 0 && BAND_STAKED > 0){
            messages.append(messageData(tokenfun:"delegatebw", sendfrom: sendfrom, CPU_STAKED: 0, BAND_STAKED: BAND_STAKED))
        }else if(CPU_STAKED == 0 && BAND_STAKED < 0){
            BAND_STAKED = (AccountData.data.selfDelegatedBandwidth["net_weight"]!/10000) - netStaked
            messages.append(messageData(tokenfun:"undelegatebw", sendfrom: sendfrom, CPU_STAKED: 0, BAND_STAKED: BAND_STAKED))
        }
        
        
        return messages
    }
    

    func updateStakedIfo(){
        firstly{
            Network.loadBlock()
            }.done{ data in

                let sendfrom = AccountData.data.accountName;
                
                var messages = [EOSAction]()
                
                if let cpus = Double(self.cpuStakedField.text!){
                    if let bandw = Double(self.netStakedField.text!){
                        messages = self.generateMessage(cpuStaked: cpus, netStaked: bandw, sendfrom: sendfrom)
                    }
                }
                
                TransactionsCreator.sign(head_block_num: data.head_block_num, ref_block_prefix: data.ref_block_prefix, messages: messages).done { txID in
                    SCLAlertView().showInfo("The transaction is sent", subTitle: "txId: \(txID)")
                    firstly{
                        Network.loadAccount(accountName: AccountData.data.accountName)
                        }.done { account in
                            print(account)
                            AccountData.updateInfo(account: account, completion: { acc in
                                print(account)
                            })
                        }
                    }.catch{ error in
                        SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                        print(error.localizedDescription)
                }
            }.catch{ error in
                print(error.localizedDescription)
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
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
