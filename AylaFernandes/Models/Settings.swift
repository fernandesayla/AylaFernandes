//
//  Settings.swift
//  AylaFernandes
//
//  Created by Ayla Fernandes on 5/5/18.
//  Copyright © 2018 Ayla Fernandes. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String{
    case dollarExchangeRate = "dollarUD"
    case iof = "iofUD"
}

class Settings  {
    let defaults = UserDefaults.standard
    static var shared: Settings = Settings()
    
    var dollarExchangeRate : Double {
        get {
            
            return defaults.double(forKey:  UserDefaultsKeys.dollarExchangeRate.rawValue)
        }
        set{
            defaults.set(newValue, forKey: UserDefaultsKeys.dollarExchangeRate.rawValue)
        }
    }
    var iof: Double {
        get {
               return defaults.double(forKey: UserDefaultsKeys.iof.rawValue)
            
        }set{
            defaults.set(newValue, forKey: UserDefaultsKeys.iof.rawValue)
        }
    }
    private init(){
        
    }
}
