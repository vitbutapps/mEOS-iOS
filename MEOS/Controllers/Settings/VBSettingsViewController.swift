//
//  VBSettingsViewController.swift
//  MEOS
//
//  Created by Виталий on 24/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import SCLAlertView

class VBSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        //if(indexPath.row == 0){
        //    cell = tableView.dequeueReusableCell(withIdentifier: "networkCell", for: indexPath)
        //    cell.accessoryType = .disclosureIndicator
        //}else
        if(indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "privacyCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)//tableView.dequeueReusableCell(withIdentifier: "privacyCell", for: indexPath)
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = UIColor.red
            //cell.accessoryType = .disclosureIndicator
        }
        
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 41/255, green: 53/255, blue: 67/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        cell.isHighlighted = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if(indexPath.row == 0){
            if let selectAssetController = UIStoryboard(name: "Modal", bundle: nil).instantiateViewController(withIdentifier: "VBNetworksViewController") as? VBNetworksViewController{
                var halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: selectAssetController)
                selectAssetController.modalPresentationStyle = .custom
                selectAssetController.transitioningDelegate = halfModalTransitioningDelegate
                //selectAssetController.delegate = self
                self.present(selectAssetController, animated: true, completion: nil)
                
            }
        }*/
        if(indexPath.row == 1){
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("I'm sure") {
                AccountData.signOut {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = setViewController
                }
            }
            alertView.addButton("Cancel") {
                
            }
            alertView.showError("Warning", subTitle: "All account data will be erased from your phone. Are you sure you want to sign out?")
            
            
        }
    }
    

    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        let gradient = CAGradientLayer(layer: self.gradientView.layer)
        gradient.frame = view.bounds;
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.colors = [
            UIColor(red: 31/255.0, green: 40.0/255.0, blue: 51/255.0, alpha: 1.0).cgColor,
            UIColor(red: 17/255.0, green: 36/255.0, blue: 126/255.0, alpha: 1.0).cgColor,
            ] as [Any]
        
        self.gradientView.layer.addSublayer(gradient)
        // Do any additional setup after loading the view.
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
