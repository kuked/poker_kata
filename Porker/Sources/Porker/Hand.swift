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

    var priority: Int {
        return value.priority
    }

    static func == (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.value != rhs.value { return false }
        switch lhs.value {
        case .straightFlush:
            let lmax = max(lhs.cards[0], lhs.cards[1])
            let rmax = max(rhs.cards[0], rhs.cards[1])
            let lmin = min(lhs.cards[0], lhs.cards[1])
            let rmin = min(rhs.cards[0], rhs.cards[1])
            return lmax == rmax && lmin == rmin
        case .straight:
            let lmax = max(lhs.cards[0].priority, lhs.cards[1].priority)
            let rmax = max(rhs.cards[0].priority, rhs.cards[1].priority)
            return lmax == rmax
        case .pair:
            return lhs.cards[0].priority == rhs.cards[0].priority
        default:
            return true
        }
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.value == rhs.value {
            switch lhs.value {
            case .straightFlush:
                return compareStraightFlush(lhs: lhs, rhs: rhs)
            case .straight:
                return compareStraight(lhs: lhs, rhs: rhs)
            case .pair:
                return lhs.cards[0].priority > rhs.cards[0].priority
            default:
                return true
            }
        }
        return lhs.priority > rhs.priority
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

    private static func compareStraightFlush(lhs: Hand, rhs: Hand) -> Bool {
        let lmax = max(lhs.cards[0].priority, lhs.cards[1].priority)
        let rmax = max(rhs.cards[0].priority, rhs.cards[1].priority)
        if lmax == rmax {
            let lmin = min(lhs.cards[0].priority, lhs.cards[1].priority)
            let rmin = min(rhs.cards[0].priority, rhs.cards[1].priority)
            return lmin > rmin
        }
        return lmax > rmax
    }

    private static func compareStraight(lhs: Hand, rhs: Hand) -> Bool {
        let lmax = max(lhs.cards[0].priority, lhs.cards[1].priority)
        let rmax = max(rhs.cards[0].priority, rhs.cards[1].priority)
        return lmax > rmax
    }
}
