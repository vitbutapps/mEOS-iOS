//
//  VBMainTabViewController.swift
//  MEOS
//
//  Created by Виталий on 17/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit

class VBMainTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.tintColor = UIColor(hexString: "#FFFC00")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountViewController = storyboard.instantiateViewController(withIdentifier: "VBAccountViewController") as! VBAccountViewController
        let vottingViewController = storyboard.instantiateViewController(withIdentifier: "VBVoteViewController")    as! VBVoteViewController
        let stakedViewController = storyboard.instantiateViewController(withIdentifier: "VBStakedViewController")   as! VBStakedViewController
        let transferViewController = storyboard.instantiateViewController(withIdentifier: "VBTransferViewController") as! VBTransferViewController
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "VBSettingsNavViewController") as! VBSettingsNavViewController

        
        
        let icon1 = UITabBarItem(title: "Account", image: UIImage(named: "accountTabIconUnselected.png"), selectedImage: UIImage(named: "accountTabIconSelected.png"))
        accountViewController.tabBarItem = icon1
        
        let icon2 = UITabBarItem(title: "Vote", image: UIImage(named: "votingUnselected.png"), selectedImage: UIImage(named: "votingSelected.png"))
        vottingViewController.tabBarItem = icon2
        
        let icon3 = UITabBarItem(title: "Update Staked", image: UIImage(named: "updateStakedUnselected.png"), selectedImage: UIImage(named: "updateStakedSelected.png"))
        stakedViewController.tabBarItem = icon3
        
        let icon4 = UITabBarItem(title: "Transfer", image: UIImage(named: "transferUnselected.png"), selectedImage: UIImage(named: "transferSelected.png"))
        transferViewController.tabBarItem = icon4
        
        let icon5 = UITabBarItem(title: "Settings", image: UIImage(named: "settingsUnselected.png"), selectedImage: UIImage(named: "settingsSelected.png"))
        settingsViewController.tabBarItem = icon5
        
        
        
        let controllers = [accountViewController, vottingViewController, stakedViewController, transferViewController, settingsViewController]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        self.hideKeyboardWhenTappedAround()
        
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
