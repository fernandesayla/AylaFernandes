//
//  TaxCalculator.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 5/4/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import UIKit

class TaxesCalculator {
    static let shared = TaxesCalculator()
    
    var dollar: Double = 3.5
    var iof: Double = 6.38
    var stateTAx: Double = 7.0
    var shoppingValue: Double = 0.0
    
    
    var shoppingValueInReal: Double{
        return shoppingValue * dollar
    }
    
    var stateTaxValue : Double{
        return shoppingValue * stateTAx/100
        
    }
    var iofValue: Double {
        return shoppingValue * iof/100
    }
    func calculate(usingCreditCard: Bool) -> Double {
        var finalValue = shoppingValue + stateTaxValue
        if usingCreditCard {
            finalValue += iofValue
        }
        return finalValue
        
    }
    let formatter = NumberFormatter()
    
    func convertToDoble(_ string: String) -> Double{
        formatter.numberStyle = .none
        return formatter.number(from: string)!.doubleValue
    }
    func getFormattedValue(of value: Double, with currency: String) -> String {
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter.string(for: value)!
    }
    
    
    private init(){
        formatter.usesGroupingSeparator = true
    }
    
}
