//
//  ViewController.swift
//  MEOS
//
//  Created by Виталий on 14/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AccountData().complition == true){
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "VBMainTabViewController") as! VBMainTabViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = setViewController
        }else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "OnBoard", bundle: nil)
            let setViewController = mainStoryboard.instantiateViewController(withIdentifier: "VBOnboardNavController")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = setViewController
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

