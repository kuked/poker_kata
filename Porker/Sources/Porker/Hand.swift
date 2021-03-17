//
//  Hand.swift
//  Porker
//
//  Created by kuked on 2021/03/13.
//

import Foundation

struct Hand {
    // FIX ME: I don't think Value is a good name.
    enum Value: String {
        case straightFlush = "straight flush"
        case flush         = "flush"
        case straight      = "straight"
        case pair          = "one pair"
        case highCard      = "high card"
    }

    let cards: [Card]
    // FIX ME: I want to use let instead of var.
    var value: Value = .highCard

    init(cards: [Card]) {
        self.cards = cards
        self.value = decide()
    }

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
        return "\(value.rawValue): \(cards[0].notation) \(cards[1].notation)"
    }

    private var _isFlush: Bool {
        return cards[0].hasSameSuit(cards[1])
    }

    private var _isStraight: Bool {
        let difference = abs(cards[0].rank.priority - cards[1].rank.priority)
        return difference == 1 || difference == 12
    }

    private func decide() -> Value {
        if isStraightFlush { return .straightFlush }
        if isFlush         { return .flush }
        if isStraight      { return .straight }
        if isHighCard      { return .highCard }
        if isPair          { return .pair }
        return .highCard
    }
}
