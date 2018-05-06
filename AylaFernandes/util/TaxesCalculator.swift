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
        var total = product.dollarPrice
        let taxesValue = product.dollarPrice * ((product.state?.tax)!/100)
        let iofValue = (product.dollarPrice + taxesValue) * (config.iof/100)
        total += taxesValue
        if product.paymentMethod {
            total += iofValue
        }
        return total * config.dollarExchangeRate
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
    
  
    
}
