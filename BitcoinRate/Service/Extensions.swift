//
//  Extensions.swift
//  BitcoinRate
//
//  Created by Тима Егембердиев on 6/17/19.
//  Copyright © 2019 BitcoinRate. All rights reserved.
//

import Foundation

extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    var last7days: [Int] {
        return (1...7).map {
            adding(days: -$0).day
        }
    }
    func near(days: Int) -> [Int] {
        return days == 0 ? [day] : (1...abs(days)).map {
            adding(days: $0 * (days < 0 ? -1 : 1) ).day
        }
    }
}
