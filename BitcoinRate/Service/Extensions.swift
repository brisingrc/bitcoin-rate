//
//  Extensions.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/17/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

extension Date {
    
    func isSameMonth(_ dic: [String:Any]) {
        
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
//    findByMonth() {
//    
//    }
}
