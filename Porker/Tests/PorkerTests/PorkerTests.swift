import XCTest
@testable import Porker

final class PorkerTests: XCTestCase {
    func testCardNotation() {
        var card: Card

        card = Card(rank: .three, suit: .heart)
        XCTAssertEqual(card.notation, "3❤︎")

        card = Card(rank: .jack, suit: .spade)
        XCTAssertEqual(card.notation, "J♠︎")
    }

    func testHasSameSuit() {
        var card1: Card
        var card2: Card

        card1 = cardFrom("A❤︎")
        card2 = cardFrom("2❤︎")
        XCTAssertTrue(card1.hasSameSuit(card2))

        card1 = cardFrom("A♠︎")
        card2 = cardFrom("2❤︎")
        XCTAssertFalse(card1.hasSameSuit(card2))
    }

    func testHasSameRank() {
        var card1: Card
        var card2: Card

        card1 = cardFrom("A♠︎")
        card2 = cardFrom("A❤︎")
        XCTAssertTrue(card1.hasSameRank(card2))

        card1 = cardFrom("A♠︎")
        card2 = cardFrom("2❤︎")
        XCTAssertFalse(card1.hasSameRank(card2))
    }

    func testCardEqual() {
        XCTAssertEqual(cardFrom("A♠︎"), cardFrom("A♠︎"))

        XCTAssertNotEqual(cardFrom("A♠︎"), cardFrom("2♠︎"))
        XCTAssertNotEqual(cardFrom("A♠︎"), cardFrom("A❤︎"))
        XCTAssertNotEqual(cardFrom("A♠︎"), cardFrom("Q❤︎"))
    }

    func testHandNotation() {
        var hand: Hand

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertEqual(hand.notation, "straight flush: A❤︎ K❤︎")

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("3❤︎")])
        XCTAssertEqual(hand.notation, "flush: A❤︎ 3❤︎")

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("K♠︎")])
        XCTAssertEqual(hand.notation, "straight: A❤︎ K♠︎")

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("A♠︎")])
        XCTAssertEqual(hand.notation, "one pair: A❤︎ A♠︎")

        hand = Hand(cards: [cardFrom("J❤︎"), cardFrom("K♠︎")])
        XCTAssertEqual(hand.notation, "high card: J❤︎ K♠︎")
    }

    func testIsPair() {
        var hand: Hand

        hand = handFrom("one pair: A❤︎ A♠︎")
        XCTAssertTrue(hand.isPair)
        
        hand = handFrom("high card: J❤︎ K♠︎")
        XCTAssertFalse(hand.isPair)
    }

    func testIsFlush() {
        var hand: Hand

        hand = Hand(cards: [cardFrom("J❤︎"), cardFrom("K❤︎")])
        XCTAssertTrue(hand.isFlush)
        
        hand = Hand(cards: [cardFrom("J❤︎"), cardFrom("K♠︎")])
        XCTAssertFalse(hand.isFlush)

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertFalse(hand.isFlush)
    }

    func testIsHighCard() {
        var hand: Hand

        hand = Hand(cards: [cardFrom("J❤︎"), cardFrom("K♠︎")])
        XCTAssertTrue(hand.isHighCard)

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("A♠︎")])
        XCTAssertFalse(hand.isHighCard)

        hand = Hand(cards: [cardFrom("J❤︎"), cardFrom("K❤︎")])
        XCTAssertFalse(hand.isHighCard)
    }

    func testIsStraight() {
        var hand: Hand

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("K♠︎")])
        XCTAssertTrue(hand.isStraight)

        hand = Hand(cards: [cardFrom("2❤︎"), cardFrom("A♠︎")])
        XCTAssertTrue(hand.isStraight)

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("3♠︎")])
        XCTAssertFalse(hand.isStraight)
    }

    func testIsStraightFlush() {
        var hand: Hand

        hand = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertTrue(hand.isStraightFlush)

        hand = Hand(cards: [cardFrom("2❤︎"), cardFrom("A❤︎")])
        XCTAssertTrue(hand.isStraightFlush)
    }

    func testCompareHand() {
        var hand1: Hand
        var hand2: Hand

        hand1 = Hand(cards: [cardFrom("A❤︎"), cardFrom("3❤︎")])
        hand2 = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertTrue(hand1 < hand2)

        hand1 = Hand(cards: [cardFrom("A❤︎"), cardFrom("K♠︎")])
        hand2 = Hand(cards: [cardFrom("A❤︎"), cardFrom("3❤︎")])
        XCTAssertTrue(hand1 < hand2)
    }

    func testCompareSameHand() {
        var hand1: Hand
        var hand2: Hand

        hand1 = Hand(cards: [cardFrom("K♠︎"), cardFrom("Q♠︎")])
        hand2 = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertTrue(hand1 < hand2)

        hand1 = Hand(cards: [cardFrom("A♠︎"), cardFrom("2♠︎")])
        hand2 = Hand(cards: [cardFrom("A❤︎"), cardFrom("K❤︎")])
        XCTAssertTrue(hand1 < hand2)

        hand1 = Hand(cards: [cardFrom("A♠︎"), cardFrom("2♠︎")])
        hand2 = Hand(cards: [cardFrom("4❤︎"), cardFrom("3❤︎")])
        XCTAssertTrue(hand1 < hand2)
    }

    func cardFrom(_ str: String) -> Card {
        let rank = String(str.prefix(str.count - 1))
        let suit = String(str.suffix(1))
        return Card(rank: Card.Rank.init(rawValue: rank)!, suit: Card.Suit.init(rawValue: suit)!)
    }

    func handFrom(_ str: String) -> Hand {
        // hands: card1 card2 ...
        let result = str.split(separator: ":")
        let cards = result[1].split(separator: " ").map { cardFrom(String($0)) }
        let hand = Hand(cards: cards)
        assert(hand.notation == str)
        return hand
    }
}
