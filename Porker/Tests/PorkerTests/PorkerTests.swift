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

        hand = handFrom("flush: J❤︎ K❤︎")
        XCTAssertTrue(hand.isFlush)
        
        hand = handFrom("high card: J❤︎ K♠︎")
        XCTAssertFalse(hand.isFlush)

        hand = handFrom("straight flush: A❤︎ K❤︎")
        XCTAssertFalse(hand.isFlush)
    }

    func testIsHighCard() {
        var hand: Hand

        hand = handFrom("high card: J❤︎ K♠︎")
        XCTAssertTrue(hand.isHighCard)

        hand = handFrom("one pair: A❤︎ A♠︎")
        XCTAssertFalse(hand.isHighCard)

        hand = handFrom("flush: J❤︎ K❤︎")
        XCTAssertFalse(hand.isHighCard)
    }

    func testIsStraight() {
        var hand: Hand

        hand = handFrom("straight: A❤︎ K♠︎")
        XCTAssertTrue(hand.isStraight)

        hand = handFrom("straight: 2❤︎ A♠︎")
        XCTAssertTrue(hand.isStraight)

        hand = handFrom("high card: A❤︎ 3♠︎")
        XCTAssertFalse(hand.isStraight)
    }

    func testIsStraightFlush() {
        var hand: Hand

        hand = handFrom("straight flush: A❤︎ K❤︎")
        XCTAssertTrue(hand.isStraightFlush)

        hand = handFrom("straight flush: 2❤︎ A❤︎")
        XCTAssertTrue(hand.isStraightFlush)
    }

    func testCompareHand() {
        var hand1: Hand
        var hand2: Hand

        hand1 = handFrom("flush: A❤︎ 3❤︎")
        hand2 = handFrom("straight flush: A❤︎ K❤︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("straight: A❤︎ K♠︎")
        hand2 = handFrom("flush: A❤︎ 3❤︎")
        XCTAssertTrue(hand1 < hand2)
    }

    func testCompareStraightFlush() {
        var hand1: Hand
        var hand2: Hand

        hand1 = handFrom("straight flush: K♠︎ Q♠︎")
        hand2 = handFrom("straight flush: A❤︎ K❤︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("straight flush: A♠︎ 2♠︎")
        hand2 = handFrom("straight flush: A❤︎ K❤︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("straight flush: A♠︎ 2♠︎")
        hand2 = handFrom("straight flush: 4❤︎ 3❤︎")
        XCTAssertTrue(hand1 < hand2)
    }

    func testComparePair() {
        var hand1: Hand
        var hand2: Hand

        hand1 = handFrom("one pair: K❤︎ K♠︎")
        hand2 = handFrom("one pair: A❤︎ A♠︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("one pair: K❤︎ K♠︎")
        hand2 = handFrom("one pair: K♣︎ K♦︎")
        XCTAssertTrue(hand1 == hand2)
    }

    func testCompareStraight() {
        var hand1: Hand
        var hand2: Hand

        hand1 = handFrom("straight: K❤︎ Q♠︎")
        hand2 = handFrom("straight: A❤︎ K♠︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("straight: A❤︎ 2♠︎")
        hand2 = handFrom("straight: A♣︎ K♦︎")
        XCTAssertTrue(hand1 < hand2)

        hand1 = handFrom("straight: A❤︎ 2♠︎")
        hand2 = handFrom("straight: A♣︎ 2♦︎")
        XCTAssertTrue(hand1 == hand2)
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
