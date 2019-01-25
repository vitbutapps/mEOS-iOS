//
//  VBTransferViewController.swift
//  MEOS
//
//  Created by Виталий on 21/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import SCLAlertView
import QRCodeReader
import AVFoundation
import PromiseKit

class VBTransferViewController: UIViewController, SelectAssetDelegate, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var selectAssetsBtn: UIButton!
    
    static var lastInstance:VBTransferViewController!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedTokenSymbol = "EOS"
    var selectedTokenCode = "eosio.token"
    
    @IBOutlet weak var originalAccountLabel: UITextField!
    @IBOutlet weak var destinationAccountLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var memoField: UITextView!
    
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VBTransferViewController.lastInstance = self
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
        
        self.originalAccountLabel.text = AccountData.data.accountName
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func scanAccountName(_ sender: Any) {
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result != nil{
                VBTransferViewController.lastInstance.destinationAccountLabel.text = result!.value
            }
        }
        
        present(readerVC, animated: true, completion: nil)
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result)
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
             VBTransferViewController.lastInstance.destinationAccountLabel.text = result.value
        }
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        //if let cameraName = newCaptureDevice.device.localizedName {
        //    print("Switching capturing to: \(cameraName)")
        //}
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendTransaction(_ sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Done") {
            let loadView = SCLAlertView(appearance: appearance).showWait("Sending transaction", subTitle: "Please wait!")
            self.sendTransaction().done{ txID in
                let succesMess = SCLAlertView()
                succesMess.addButton("Show Transaction") {
                    if let url = URL(string: "https://eosflare.io/tx/\(txID)"){
                        UIApplication.shared.open(url)
                    }

                }
                succesMess.addButton("Copy TxID") {
                    UIPasteboard.general.string = txID
                }
                succesMess.showSuccess("Success transaction", subTitle: "The transaction has been successfully sent!\n TxID: \(txID)")
                }.catch{ error in
                    SCLAlertView().showError("Error", subTitle: error.localizedDescription)
                }.finally {
                    loadView.close()
            }
        }
        
        alertView.addButton("Cancel") {
            
        }
        
        let tokenSend = String(format: "%.4f %@", Double(self.quantityLabel.text!)!, self.selectedTokenSymbol)
        
        alertView.showWarning("To complete the transaction?", subTitle: "Are you sure you want to translate \(tokenSend) to user \(self.destinationAccountLabel.text!)?")
        
        
        self.cleareDigital()
            
    }
    
    func sendTransaction() -> Promise<String>{
        return Promise{ seal in
            Network.loadBlock().done{ data in
                let sendfrom = AccountData.data.accountName;
                
                let runtoken = self.selectedTokenCode;
                let tokenfun = "transfer";
                
                let message = EOSAction()
                message.account = EOSAccountName(name: runtoken)
                message.name = EOSAccountName(name: tokenfun)
                
                message.authorization.add(EOSAccountPermission(string: sendfrom, permission: "active"))
                
                
                
                print(String(format: "%.4f %@", Double(self.quantityLabel.text!)!, self.selectedTokenSymbol))
                let mdata = EOSTxMessageData()
                mdata.from = EOSAccountName(name: AccountData.data.accountName)
                mdata.to = EOSAccountName(name: self.destinationAccountLabel.text!)
                mdata.amount = EOSAsset(string: String(format: "%.4f %@", Double(self.quantityLabel.text!)!, self.selectedTokenSymbol))
                mdata.data = self.memoField.text.data(using: .utf8)
                message.data = mdata
                
                
                
                TransactionsCreator.sign(head_block_num: data.head_block_num, ref_block_prefix: data.ref_block_prefix, messages: [message]).done { txID in
                    print(txID)
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
    
    
    @IBAction func setSendedQuantity(_ sender: UITextField) {
        if let text = sender.text{
            if text != ""{
                let swiftyString = text.replacingOccurrences(of: ",", with: ".")
                sender.text = swiftyString
            }
        }
    }
    
    func cleareDigital(){
        if let quantity = self.quantityLabel.text{
            if quantity != ""{
                let swiftyString = quantity.replacingOccurrences(of: ",", with: ".")
                
                if let bandw = Double(swiftyString){
                    self.quantityLabel.text = "\(bandw)"
                }else{
                    self.quantityLabel.text = "0.00"
                }
                
            }
        }
    }
    
    func selectedAsset(token: TokenSymbols) {
        self.selectedTokenSymbol = token.symbol
        self.selectedTokenCode = token.code
        self.selectAssetsBtn.setTitle(token.symbol, for: .normal)
    }
    
    @IBAction func selectAssetsAction(_ sender: UIButton) {

        if let selectAssetController = UIStoryboard(name: "Modal", bundle: nil).instantiateViewController(withIdentifier: "VBSelectAssetsViewController") as? VBSelectAssetsViewController{
            var halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: selectAssetController)
            selectAssetController.modalPresentationStyle = .custom
            selectAssetController.transitioningDelegate = halfModalTransitioningDelegate
            selectAssetController.delegate = self
            self.present(selectAssetController, animated: true, completion: nil)
            
        }
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
