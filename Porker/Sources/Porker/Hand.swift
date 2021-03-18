//
//  Hand.swift
//  Porker
//
//  Created by kuked on 2021/03/13.
//

import Foundation

struct Hand: Equatable, Comparable {
    // FIX ME: I don't think Value is a good name.
    enum Value: String {
        case straightFlush = "straight flush"
        case flush         = "flush"
        case straight      = "straight"
        case pair          = "one pair"
        case highCard      = "high card"

        var priority: Int {
            switch self {
            case .straightFlush: return 1
            case .flush:         return 2
            case .straight:      return 3
            case .pair:          return 4
            case .highCard:      return 5
            }
        }
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

    static func == (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.value == rhs.value
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.value.priority > rhs.value.priority
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
