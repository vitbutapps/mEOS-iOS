//
//  VBAccountView.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph
import PromiseKit

class VBAccountView: UIView, BEMSimpleLineGraphDataSource  {
    
    var rates: [CGFloat] = [CGFloat]()
    
    func numberOfPoints(inLineGraph graph: BEMSimpleLineGraphView) -> Int {
        return rates.count
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, valueForPointAt index: Int) -> CGFloat {
        return rates[index]
    }
    
    let kCONTENT_XIB_NAME = "AccountView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var eosGraphView: BEMSimpleLineGraphView!
    
    
    @IBOutlet weak var accounNameLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var stakedLabel: UILabel!
    @IBOutlet weak var unstakedLabel: UILabel!
    @IBOutlet weak var refundsLabel: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    
    @IBOutlet weak var stakedView: UIView!
    @IBOutlet weak var unstakedView: UIView!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var portfolioView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.backgroundColor = .clear
        contentView.fixInView(self)
        self.accounNameLabel.text = AccountData.data.accountName
    }
    
    
    func updateData(acc:AccountData){
        
        let totalBalance = acc.totalBalance.rounded(toPlaces: 4)
        let stakedBalance = (acc.staked/10000).rounded(toPlaces: 4)
        let unstakedBalance = ((acc.totalBalance - (acc.staked/10000))-acc.refund).rounded(toPlaces: 4)
        
        if(totalBalance <= 0){
            self.totalBalanceLabel.text = "0.00 EOS"
        }else{
            self.totalBalanceLabel.text = "\(totalBalance) EOS".spacer()
        }
        
        if(stakedBalance <= 0){
            self.stakedLabel.text = "0.00 EOS"
        }else{
            self.stakedLabel.text = "\(stakedBalance) EOS".spacer()
        }
        
        if(unstakedBalance <= 0){
            self.unstakedLabel.text = "0.00 EOS"
        }else{
            self.unstakedLabel.text = "\(unstakedBalance) EOS".spacer()
        }
        
        if(acc.refund <= 0){
            self.refundsLabel.text = "0.00 EOS"
        }else{
            self.refundsLabel.text = "\(acc.refund) EOS".spacer()
        }

       self.portfolioLabel.text = "$\((acc.totalBalance*acc.price).rounded(toPlaces: 2))".spacer()
        
        firstly{
            Network.loadEosLastPrice()
            }.done { lastPrice in
                if let dataPrice = lastPrice.data{
                    acc.price = dataPrice.quotes.USD["price"]!
                    self.portfolioLabel.text = "$\((acc.totalBalance*acc.price).rounded(toPlaces: 2))".spacer()
                }
            }.catch{ error in
                print(error.localizedDescription)
        }
        
        Network.getHistory().done{ HistData in
            self.rates = [CGFloat]()
            for EOS in HistData.EOS{
                if(EOS.count == 3){
                    self.rates.append(CGFloat(EOS[1]))
                }
            }
            
            self.eosGraphView.reloadGraph()
        }
    }
    

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
