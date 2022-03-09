//
//  Card.swift
//  my_2048
//
//  Created by Pan Xingyuan on 2020/11/25.
//  Copyright © 2020 Pan Xingyuan. All rights reserved.
//

import Foundation

class Card {
    
    private var value=0
    
    init(value: Int = 0) {
        self.value = value
    }
    
    func getValue() -> Int {
        return value
    }
    
    func upgrade() -> Int {
        value *= 2
        return value
    }
    
}
