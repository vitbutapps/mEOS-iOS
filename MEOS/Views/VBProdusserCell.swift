//
//  VBProdusserCell.swift
//  MEOS
//
//  Created by Виталий on 19/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit

class VBProdusserCell: UIView {
    
    let kCONTENT_XIB_NAME = "ProdusserCell"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressValue: NSLayoutConstraint!
    
    
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
        //contentView.backgroundColor = .clear
        contentView.fixInView(self)
    }
    
    func setValue(BP: BPRealm) {
        
        if BP.voted {
            self.starImage.image = UIImage(named: "StarActive")
        }else{
            self.starImage.image = UIImage(named: "StarInactive")
        }
        
        self.ownerLabel.text = BP.owner
        self.urlLabel.text = BP.url
        
        if let total_votes = Decimal(string: BP.total_votes){
            if let total_producer_vote_weight = Decimal(string: AccountData.data.totalProducerVoteWeight){
                var precentValue = (total_votes/total_producer_vote_weight)*100
                
                var percent = Decimal()
                NSDecimalRound(&percent, &precentValue, 2, NSDecimalNumber.RoundingMode.plain)
                self.percentLabel.text = "\(percent) %"
                let precentViewValue = (4/100)*percent
                self.progressValue = self.progressValue.setMultiplier(multiplier: CGFloat((precentViewValue as NSDecimalNumber).floatValue))
                //self.progressValue.constant = 10
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
