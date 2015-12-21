//
//  shuffle.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/06.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle(count: Int) {
        for _ in 0..<count {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

extension NSMutableArray {
    func shuffle(count: Int) {
        for i in 0..<count {
            let nElements: Int = count - i
            let n: Int = Int(arc4random_uniform(UInt32(nElements))) + i
            self.exchangeObjectAtIndex(i, withObjectAtIndex: n)
        }
    }
    
}