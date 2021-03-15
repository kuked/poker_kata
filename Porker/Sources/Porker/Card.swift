//
//  Card.swift
//  Porker
//
//  Created by kuked on 2021/03/13.
//

import Foundation

struct Card: Equatable {
    enum Rank: String {
        case ace   = "A"
        case two   = "2"
        case three = "3"
        case four  = "4"
        case five  = "5"
        case six   = "6"
        case seven = "7"
        case eight = "8"
        case nine  = "9"
        case ten   = "10"
        case jack  = "J"
        case queen = "Q"
        case king  = "K"

        var priority: Int {
            switch self {
            case .ace:   return 1
            case .king:  return 2
            case .queen: return 3
            case .jack:  return 4
            case .ten:   return 5
            case .nine:  return 6
            case .eight: return 7
            case .seven: return 8
            case .six:   return 9
            case .five:  return 10
            case .four:  return 11
            case .three: return 12
            case .two:   return 13
            }
        }
    }

    enum Suit: String {
        case spade   = "♠︎"
        case heart   = "❤︎"
        case club    = "♣︎"
        case diamond = "♦︎"
    }
    
    let rank: Rank
    let suit: Suit
    
    var notation: String {
        return rank.rawValue + suit.rawValue
    }
    
    func hasSameSuit(_ card: Card) -> Bool {
        return suit == card.suit
    }
    
    func hasSameRank(_ card: Card) -> Bool {
        return rank == card.rank
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hasSameRank(rhs) && lhs.hasSameSuit(rhs)
    }
}
