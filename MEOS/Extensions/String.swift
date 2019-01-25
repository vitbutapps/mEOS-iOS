

import Foundation
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    func spacer() -> String{
        let drober = self.components(separatedBy: ".")
        if(drober.count <= 0){
            return self
        }
        
        if let regex = try? NSRegularExpression(pattern: "(\\d{1,3}(?=(?:\\d\\d\\d)+(?!\\d)))", options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: drober[0], options: .withTransparentBounds, range: NSMakeRange(0, drober[0].characters.count), withTemplate: "$1 ")
            if(drober.count > 1){
                return modString+"."+drober[1]
            }
            return modString
        }
        return self
    }
    
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
} 
