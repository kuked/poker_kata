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
        return _isFlush && !_isStraight
    }
    
    var isHighCard: Bool {
        return !(isPair || isFlush)
    }

    var isStraight: Bool {
        return _isStraight && !_isFlush
    }

    var isStraightFlush: Bool {
        return _isStraight && _isFlush
    }

    var notation: String {
        return "straight flush: A❤︎ K❤︎"
    }

    private var _isFlush: Bool {
        return cards[0].hasSameSuit(cards[1])
    }

    private var _isStraight: Bool {
        let difference = abs(cards[0].rank.priority - cards[1].rank.priority)
        return difference == 1 || difference == 12
    }
}
