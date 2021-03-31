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
        case threeCard     = "three of a kind"
        case pair          = "one pair"
        case highCard      = "high card"

        var priority: Int {
            switch self {
            case .straightFlush: return 1
            case .flush:         return 2
            case .straight:      return 3
            case .threeCard:     return 4
            case .pair:          return 5
            case .highCard:      return 6
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

    var isThreeCard: Bool {
        let group = Dictionary(grouping: cards, by: { $0.rank })
        return group.values.map { $0.count }.max() == 3
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
        case .threeCard:
            return lhs.cards[0].priority == rhs.cards[0].priority
        case .pair:
            let lhit = lhs.hit(value: .pair)!
            let rhit = rhs.hit(value: .pair)!
            let lmiss = lhs.miss(value: .pair)!
            let rmiss = lhs.miss(value: .pair)!
            return lhit[0].priority == rhit[0].priority && lmiss[0].priority == rmiss[0].priority
        }
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.value == rhs.value {
            switch lhs.value {
            case .straightFlush, .straight:
                return compareHighest(lhs: lhs, rhs: rhs)
            case .flush, .highCard:
                return compareAll(lhs: lhs, rhs: rhs)
            case .threeCard:
                return lhs.cards[0].priority > rhs.cards[0].priority
            case .pair:
                let lhit = lhs.hit(value: .pair)!
                let rhit = rhs.hit(value: .pair)!
                let lmiss = lhs.miss(value: .pair)!
                let rmiss = rhs.miss(value: .pair)!
                if lhit[0].priority > rhit[0].priority {
                    return true
                } else if lhit[0].priority == rhit[0].priority {
                    return lmiss[0].priority > rmiss[0].priority
                } else {
                    return false
                }
            }
        }
        return lhs.priority > rhs.priority
    }

    private var _isFlush: Bool {
        let first = cards[0]
        return cards.allSatisfy({ $0.suit == first.suit })
    }

    private var _isStraight: Bool {
        var actual = cards.map { $0.priority }.sorted()
        if actual.first == 1 && actual.last == 13 {
            actual.removeFirst()
        }
        let expected = Array(actual[0]..<actual[0] + actual.count)
        return zip(actual, expected).allSatisfy({ $0.0 == $0.1 })
    }

    private func decide() -> Value {
        if isStraightFlush { return .straightFlush }
        if isFlush         { return .flush }
        if isStraight      { return .straight }
        if isThreeCard     { return .threeCard }
        if isHighCard      { return .highCard }
        if isPair          { return .pair }
        return .highCard
    }

    private func hit(value: Value) -> [Card]? {
        switch value {
        case .straightFlush, .straight, .flush, .threeCard:
            return cards
        case .pair:
            let group = Dictionary(grouping: cards, by: { $0.rank })
            return group.values.first { $0.count == 2 }!
        default:
            return nil
        }
    }

    private func miss(value: Value) -> [Card]? {
        switch value {
        case .straightFlush, .straight, .flush, .threeCard:
            return nil
        case .pair:
            let group = Dictionary(grouping: cards, by: { $0.rank })
            return group.values.first { $0.count == 1 }!
        default:
            return cards
        }
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
