//
//  VBTokenCell.swift
//  MEOS
//
//  Created by Виталий on 18/12/2018.
//  Copyright © 2018 Vitaliy. All rights reserved.
//

import UIKit
import PromiseKit

class VBTokenCell: UIView {
    let kCONTENT_XIB_NAME = "TokenCell"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var codelabel: UILabel!
    
    @IBOutlet weak var portfolioLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
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
    
    var tokenInfo:TokenSymbols?
    
    func setToken(token: TokenSymbols){
        
        self.tokenInfo = token
        
        self.amountLabel.text = token.balance.spacer()
        self.symbolLabel.text = token.symbol.uppercased()
        self.codelabel.text = token.code
        
        self.portfolioLabel.text = "0.00"
        self.priceLabel.text = "USD (@ $0.0000)"
        
        firstly{
            Network.loadToken(symbol: token.symbol, code:token.code)
            }.done { tokens in
                
                let scale = 6
                var value1 = tokens.data.price*Decimal(string: "\(AccountData.data.price)")!
                var roundedValue1 = Decimal()
                var roundedValue2 = Decimal()
                
                if(tokens.data.price > 1){
                    NSDecimalRound(&roundedValue1, &value1, 2, NSDecimalNumber.RoundingMode.plain)
                }else{
                    NSDecimalRound(&roundedValue1, &value1, scale, NSDecimalNumber.RoundingMode.plain)
                }
                
                if let balance = Decimal(string: token.balance){
                    var price =  balance * (tokens.data.price * Decimal(string: "\(AccountData.data.price)")!)
                    NSDecimalRound(&roundedValue2, &price, 2, NSDecimalNumber.RoundingMode.plain)
                    self.portfolioLabel.text = "\(roundedValue2)".spacer()
                }
                
                self.priceLabel.text = "USD  (@ $\(roundedValue1))".spacer()
            }.catch{ error in
                self.portfolioLabel.text = "0.00"
                self.priceLabel.text = "USD  (@ $0.0000)"
                print(error.localizedDescription)
        }
    }
    
    func setToken(token: TokensRealm){
        self.amountLabel.text = token.balance.spacer()
        self.symbolLabel.text = token.symbol.uppercased()
        self.codelabel.text = token.code
        
        self.tokenInfo = TokenSymbols(symbol: token.symbol, code: token.code, balance: token.balance)
        
        
        self.portfolioLabel.text = "0.00"
        self.priceLabel.text = "USD (@ $0.0000)"
        
        
        if(token.symbol.uppercased() == "EOS"){
            firstly{
                Network.loadEosLastPrice()
                }.done { lastPrice in
                    if let dataPrice = lastPrice.data{
                        //acc.price = dataPrice.quotes.USD["price"]!
                        //self.portfolioLabel.text = "$\((acc.totalBalance*acc.price).rounded(toPlaces: 2))".spacer()
                        let scale = 6
                        var value1 = Decimal(string: "\(dataPrice.quotes.USD["price"]!)")!
                        var roundedValue1 = Decimal()
                        var roundedValue2 = Decimal()
                        
                        NSDecimalRound(&roundedValue1, &value1, 2, NSDecimalNumber.RoundingMode.plain)
                        
                        if let balance = Decimal(string: token.balance){
                            var price =  balance * (value1 * Decimal(string: "\(AccountData.data.price)")!)
                            NSDecimalRound(&roundedValue2, &price, 2, NSDecimalNumber.RoundingMode.plain)
                            self.portfolioLabel.text = "\(roundedValue2)".spacer()
                        }
                        
                        self.priceLabel.text = "USD  (@ $\(roundedValue1))".spacer()
                        
                    }
                }.catch{ error in
                    print(error.localizedDescription)
            }
            return
        }
        
        
        firstly{
            Network.loadToken(symbol: token.symbol, code:token.code)
            }.done { tokens in
                
                let scale = 6
                var value1 = tokens.data.price*Decimal(string: "\(AccountData.data.price)")!
                var roundedValue1 = Decimal()
                var roundedValue2 = Decimal()
                
                if(tokens.data.price > 1){
                    NSDecimalRound(&roundedValue1, &value1, 2, NSDecimalNumber.RoundingMode.plain)
                }else{
                    NSDecimalRound(&roundedValue1, &value1, scale, NSDecimalNumber.RoundingMode.plain)
                }
                
                if let balance = Decimal(string: token.balance){
                    var price =  balance * (tokens.data.price * Decimal(string: "\(AccountData.data.price)")!)
                    NSDecimalRound(&roundedValue2, &price, 2, NSDecimalNumber.RoundingMode.plain)
                    self.portfolioLabel.text = "\(roundedValue2)".spacer()
                }
                
                self.priceLabel.text = "USD  (@ $\(roundedValue1))".spacer()
            }.catch{ error in
                self.portfolioLabel.text = "0.00"
                self.priceLabel.text = "USD  (@ $0.0000)"
                print(error.localizedDescription)
        }
    }
    
    func getToken() -> TokenSymbols?{
        return self.tokenInfo
    }
    
}
