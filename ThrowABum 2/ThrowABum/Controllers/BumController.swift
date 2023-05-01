//
//  BumController.swift
//  ThrowABum
//
//  Created by Yuriy Yakimenko on 08.04.2023.
//

import Foundation

class BumController {
    
   class func readItems() -> [Bum] {
        
        var bums = [Bum]()
        
        if let path = Bundle.main.path(forResource: "Items", ofType: "plist"), let plistArray = NSArray(contentsOfFile: path) as? [[String: Any]] {
            for dic in plistArray {
                let bum = Bum(dic as NSDictionary)
                bums.append(bum)
            }
        }
        return bums
    }    
  class func saveSelectedBum(_ index: Int) {
        UserDefaults.standard.set(index, forKey: "selectedBum")
        UserDefaults.standard.synchronize()
    }
   class func getSaveBumIndex() -> Int {
   return UserDefaults.standard.integer(forKey: "selectedBum")
    }
}
