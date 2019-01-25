//
//  VBEnterViewController.swift
//  MEOS
//
//  Created by Виталий on 02/01/2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit
import QRCodeReader
import SCLAlertView
import PromiseKit

class VBEnterViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var privateKeyField: UITextView!
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var previewView: QRCodeReaderView!{
        didSet {
            previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
        }
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView        = true
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.privateKeyField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationController?.navigationBar.topItem?.title = ""
        let gradient = CAGradientLayer(layer: self.gradientView.layer)
        gradient.frame = view.bounds;
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [
            UIColor(red: 17/255.0, green: 36/255.0, blue: 126/255.0, alpha: 1.0).cgColor,
            UIColor(red: 31/255.0, green: 40.0/255.0, blue: 51/255.0, alpha: 1.0).cgColor,
            
            ] as [Any]
        
        self.gradientView.layer.addSublayer(gradient)
        
        guard checkScanPermissions(), !reader.isRunning else { return }
        
        reader.didFindCode = { result in
            
            var privateKEY = result.value
            
            if(privateKEY.count == 64 || privateKEY.count == 66){
                
                if(privateKEY.count == 66){
                    let prKeys = privateKEY
                    let testKey = prKeys[2..<prKeys.count]
                    privateKEY = testKey
                }
                guard let ppk = try? PrivateKey.init(enclave: SecureEnclave(rawValue: "K1")!, data: privateKEY.hexToData()) else {
                    SCLAlertView().showError("Oops!", subTitle: "Invalid key")
                    return
                }
                
                self.privateChecker(ppk.wif())
            }else if(privateKEY.count == 51 && privateKEY.prefix(1) == "5"){
                self.privateKeyField.text = privateKEY
                self.privateChecker(privateKEY)
            }else{
                SCLAlertView().showError("Authorization error", subTitle: "The QR code you scanned is invalid. Please check your details and try again")
            }
        }
        
        reader.startScanning()
        
        SCLAlertView().showInfo("Login methods", subTitle: "You can use your EOS private key or Ethereum private key to log in to the app.")
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var privateKEY = textView.text!
        
        if(privateKEY.count == 64 || privateKEY.count == 66){
            if(privateKEY.count == 66){
                let prKeys = privateKEY
                let testKey = prKeys[2..<prKeys.count]
                privateKEY = testKey
            }
            guard let ppk = try? PrivateKey.init(enclave: SecureEnclave(rawValue: "K1")!, data: privateKEY.hexToData()) else {
                SCLAlertView().showError("Oops!", subTitle: "Invalid key")
                return
            }
            
            self.privateChecker(ppk.wif())
        }else if(privateKEY.count == 51 && privateKEY.prefix(1) == "5"){
            self.privateKeyField.text = privateKEY
            self.privateChecker(privateKEY)
        }else{
            self.loginButton.isEnabled = false
        }
    }
    
    func privateChecker(_ privateText:String){
        if(privateText == ""){
            return
        }
        
       
        guard let pk = try? PrivateKey(keyString: privateText) else {
            self.publicKeyLabel.text = "Your EOS public key?"
            self.accountNameLabel.text = "Your EOS account name?"
            self.reader.startScanning()
            //self.cheking = false
            return
        }
        
        let pubKey = PublicKey(privateKey: pk!).wif()
        self.privateKeyField.text = privateText
        self.publicKeyLabel.text = pubKey
        
        AccountData().privateKey = privateText
        AccountData().publicKey = pubKey
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertViewLoading = SCLAlertView(appearance: appearance)
        alertViewLoading.showWait("Loading", subTitle: "Please wait")
        Network.getAccountName(pubKey: pubKey).done{ account in
            alertViewLoading.hideView()
            let accountNames = account.account_names
            
            if(accountNames.count == 0){
                SCLAlertView().showError("Oops!", subTitle: "Nothing found :(")
                self.reader.startScanning()
                self.readerVC.startScanning()
                return
            }
            
           
            let alertView = SCLAlertView(appearance: appearance)

            for accName in accountNames{
                alertView.addButton(accName) {
                    self.accountNameLabel.text = "Your EOS account name: \(accName)"
                    AccountData().accountName = accName
                    self.loginButton.isEnabled = true
                    
                    alertView.dismiss(animated: true, completion: nil)

                }
            }
            alertView.showInfo("Successfully", subTitle: "Select an account to manage")
            
        }.catch{ error in
            SCLAlertView().showError("Oops!", subTitle: "Nothing found :(")
            self.reader.startScanning()
            self.readerVC.startScanning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.topItem?.title = "Privacy Policy"
    }
    
    
    
    @IBAction func startApp(_ sender: Any) {
        AccountData().complition = true
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "VBMainTabViewController") as! VBMainTabViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = setViewController
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
    }
    
    /*
    // MARK: - Navigation
     VBMainTabViewController
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
