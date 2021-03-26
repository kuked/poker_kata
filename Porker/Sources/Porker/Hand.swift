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
        let group = Dictionary(grouping: cards, by: { $0.rank })
        return group.values.map { $0.count }.max() == 2
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
        let notations = cards.map { $0.notation }.joined(separator: " ")
        return "\(value.rawValue): \(notations)"
    }

    var priority: Int {
        return value.priority
    }

    var highest: Card {
        if value == .straightFlush || value == .straight {
            if cards.contains(where: { $0.rank == .two}) {
                return cards.first(where: { $0.rank == .two })!
            }
        }
        return cards.max { a, b in a < b }!
    }

    var lowest: Card {
        return cards.min { a, b in a < b }!
    }

    static func == (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.value != rhs.value { return false }
        switch lhs.value {
        case .straightFlush, .straight:
            return lhs.highest == rhs.highest
        case .flush, .highCard:
            return lhs.highest == rhs.highest && lhs.lowest == rhs.lowest
        case .pair:
            return lhs.cards[0].priority == rhs.cards[0].priority
        }
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.value == rhs.value {
            switch lhs.value {
            case .straightFlush, .straight:
                return compareHighest(lhs: lhs, rhs: rhs)
            case .flush, .highCard:
                return compareAll(lhs: lhs, rhs: rhs)
            case .pair:
                return lhs.cards[0].priority > rhs.cards[0].priority
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

    private static func compareHighest(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.highest < rhs.highest
    }

    private static func compareAll(lhs: Hand, rhs: Hand) -> Bool {
        let lmax = lhs.highest
        let rmax = rhs.highest
        if lmax == rmax {
            let lmin = lhs.lowest
            let rmin = rhs.lowest
            return lmin < rmin
        }
        return lmax < rmax
    }
}
