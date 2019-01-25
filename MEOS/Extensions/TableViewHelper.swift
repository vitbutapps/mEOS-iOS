//
//  TableViewHelper.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {
    
    class func EmptyMessage(message:String, viewController:UIViewController , tableView: UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Helvetica", size: 20)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
    }
}
