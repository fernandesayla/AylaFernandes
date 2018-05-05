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
    var config = Settings.shared

    let formatter = NumberFormatter()
    
    func calculateProductRealValue(of product: Product) -> Double {
      
        
        var withTaxesValue: Double {
            return product.dollarPrice * (product.state?.tax)!/100
        }
        
         var finalValue = product.dollarPrice + withTaxesValue
        
        
        var withIofValue: Double {
            return (product.dollarPrice+withTaxesValue)  * config.iof/100
            
        }
        
        if product.paymentMethod {
            finalValue += withIofValue
        }
       
           
        return finalValue * config.dollarExchangeRate
    }
    
    func convertToDoble(_ string: String) -> Double{
        formatter.numberStyle = .decimal
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
    
    //  var shoppingValue: Double = 0
    
//    var shoppingValueInReal: Double{
//        return shoppingValue * dollar
//    }
//
//    var stateTaxValue : Double{
//        return shoppingValue * stateTAx/100
//
//    }
//    var iofValue: Double {
//        return shoppingValue * iof/100
//    }
//    func calculate(usingCreditCard: Bool) -> Double {
//        var finalValue = shoppingValue + stateTaxValue
//        if usingCreditCard {
//            finalValue += iofValue
//        }
//        return finalValue
//
//    }

    
    
    
}
