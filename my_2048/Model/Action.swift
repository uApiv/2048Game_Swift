//
//  Action.swift
//  my_2048
//
//  Created by Pan Xingyuan on 2020/11/25.
//  Copyright © 2020 Pan Xingyuan. All rights reserved.
//

import Foundation

enum Action{
    case move(from: Position, to: Position)
    case upgrade(from: Position, to: Position, value: Int)
    case new(at: Position, value: Int)
    case success
    case failure
}
