//
//  Hand.swift
//  Porker
//
//  Created by kuked on 2021/03/13.
//

import Foundation

struct Hand {
    let cards: [Card]
    
    var isPair: Bool {
        return cards[0].hasSameRank(cards[1])
    }
    
    var isFlush: Bool {
        return cards[0].hasSameSuit(cards[1])
    }
    
    var isHighCard: Bool {
        return !(isPair || isFlush)
    }
}
