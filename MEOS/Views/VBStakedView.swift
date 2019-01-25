//
//  VBStakedView.swift
//  MEOS
//
//  Created by Виталий on 20/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit

class VBStakedView: UIView {

    let kCONTENT_XIB_NAME = "StakedView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var ramIndicatorView: UIView!
    @IBOutlet weak var cpuIndicatorView: UIView!
    @IBOutlet weak var netIndicatorView: UIView!
    
    @IBOutlet weak var ramValueLabel: UILabel!
    @IBOutlet weak var cpuValueLabel: UILabel!
    @IBOutlet weak var netValueLabel: UILabel!
    
    @IBOutlet weak var ramProgressValue: NSLayoutConstraint!
    @IBOutlet weak var cpuProgressValue: NSLayoutConstraint!
    @IBOutlet weak var netProgressValue: NSLayoutConstraint!
    
    
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
        self.updateValue()
    }
    
    func updateValue(){
        let RAM = "\((AccountData.data.ram_usage/1024).rounded(toPlaces: 2))KB / \((AccountData.data.ram_quota/1024).rounded(toPlaces: 2))KB"
        self.ramValueLabel.text = RAM
        let ramPercentVal = ((AccountData.data.ram_usage/AccountData.data.ram_quota)).rounded(toPlaces: 4)
        
        
        if ramPercentVal > 1{
            self.ramProgressValue  = self.ramProgressValue.setMultiplier(multiplier: CGFloat(1))
        }else{
            self.ramProgressValue  = self.ramProgressValue.setMultiplier(multiplier: CGFloat(ramPercentVal))
        }
        
        let CPU_USAGE:Double = AccountData.data.cpu_limit["used"]!
        let CPU_MAX:Double = AccountData.data.cpu_limit["max"]!
        
        var CPU_MAX_MS = CPU_MAX/1000
        var CPU_MAX_MS_Val = "\(CPU_MAX_MS.rounded(toPlaces: 2))ms"
        
        if(CPU_MAX_MS > 1000){
            CPU_MAX_MS = CPU_MAX_MS/1000
            CPU_MAX_MS_Val = "\(CPU_MAX_MS.rounded(toPlaces: 2))sec"
        }
        
        var CPU_USAGE_MS = CPU_USAGE/1000
        var CPU_USAGE_MS_Val = "\(CPU_USAGE_MS.rounded(toPlaces: 2))ms"
        
        if(CPU_USAGE_MS > 1000){
            CPU_USAGE_MS = CPU_USAGE_MS/1000
            CPU_USAGE_MS_Val = "\(CPU_USAGE_MS.rounded(toPlaces: 2))sec"
        }
        
        
        let CPU = "\(CPU_USAGE_MS_Val) / \(CPU_MAX_MS_Val) (\((AccountData.data.cpu_weight/10000).rounded(toPlaces: 4)) EOS)"
        
        self.cpuValueLabel.text = CPU
        let cpuPercentVal = ((CPU_USAGE/CPU_MAX)).rounded(toPlaces: 4)
        if cpuPercentVal > 1{
            self.cpuProgressValue  = self.cpuProgressValue.setMultiplier(multiplier: CGFloat(1))
        }else{
            self.cpuProgressValue  = self.cpuProgressValue.setMultiplier(multiplier: CGFloat(cpuPercentVal))
        }
        
        
        
        let NET_USAGE:Double = AccountData.data.net_limit["used"]!
        let NET_MAX:Double = AccountData.data.net_limit["max"]!
        
        var NET_MAX_KB = NET_MAX/1024
        var NET_MAX_KB_Val = "\(NET_MAX_KB.rounded(toPlaces: 2))KB"
        
        if(NET_MAX_KB > 1024){
            NET_MAX_KB = NET_MAX_KB/1024
            NET_MAX_KB_Val = "\(NET_MAX_KB.rounded(toPlaces: 2))MB"
        }
        
        var NET_USAGE_KB = NET_USAGE/1024
        var NET_USAGE_KB_Val = "\(NET_USAGE_KB.rounded(toPlaces: 2))KB"
        
        if(NET_USAGE_KB > 1024){
            NET_USAGE_KB = NET_USAGE_KB/1024
            NET_USAGE_KB_Val = "\(NET_USAGE_KB.rounded(toPlaces: 2))MB"
        }
        
        
        let NET = "\(NET_USAGE_KB_Val) / \(NET_MAX_KB_Val) (\((AccountData.data.net_weight/10000).rounded(toPlaces: 4)) EOS)"
        self.netValueLabel.text = NET
        let netPercentVal = ((NET_USAGE/NET_MAX)).rounded(toPlaces: 4)
        self.netProgressValue  = self.netProgressValue.setMultiplier(multiplier: CGFloat(netPercentVal))
        if netPercentVal > 1{
            self.netProgressValue  = self.netProgressValue.setMultiplier(multiplier: CGFloat(1))
        }else{
            self.netProgressValue  = self.netProgressValue.setMultiplier(multiplier: CGFloat(netPercentVal))
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
