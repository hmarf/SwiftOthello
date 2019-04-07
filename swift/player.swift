//
//  player.swift
//  osero_test
//
//  Created by 岩崎孝佑 on 2019/04/04.
//  Copyright © 2019 Kosuke. All rights reserved.
//

import Foundation

class Player {
    
    func play(board: Board, stone: Int) -> (Int,Int) {
        return Random(available: board.available(stone: stone))
    }
    
    func Random(available: [[Int]]) -> (Int,Int) {
        let int = Int.random(in: 0..<available.count)
        return (available[int][0], available[int][1])
    }
}
