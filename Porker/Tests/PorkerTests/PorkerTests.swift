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

        card1 = fromString("A❤︎")
        card2 = fromString("2❤︎")
        XCTAssertTrue(card1.hasSameSuit(card2))

        card1 = fromString("A♠︎")
        card2 = fromString("2❤︎")
        XCTAssertFalse(card1.hasSameSuit(card2))
    }

    func testHasSameRank() {
        var card1: Card
        var card2: Card

        card1 = fromString("A♠︎")
        card2 = fromString("A❤︎")
        XCTAssertTrue(card1.hasSameRank(card2))

        card1 = fromString("A♠︎")
        card2 = fromString("2❤︎")
        XCTAssertFalse(card1.hasSameRank(card2))
    }

    func testCardEqual() {
        XCTAssertEqual(fromString("A♠︎"), fromString("A♠︎"))

        XCTAssertNotEqual(fromString("A♠︎"), fromString("2♠︎"))
        XCTAssertNotEqual(fromString("A♠︎"), fromString("A❤︎"))
        XCTAssertNotEqual(fromString("A♠︎"), fromString("Q❤︎"))
    }
    
    func testIsPair() {
        var hand: Hand

        hand = Hand(cards: [fromString("A❤︎"), fromString("A♠︎")])
        XCTAssertTrue(hand.isPair)
        
        hand = Hand(cards: [fromString("J❤︎"), fromString("K♠︎")])
        XCTAssertFalse(hand.isPair)
    }
    
    func testIsFlush() {
        var hand: Hand

        hand = Hand(cards: [fromString("J❤︎"), fromString("K❤︎")])
        XCTAssertTrue(hand.isFlush)
        
        hand = Hand(cards: [fromString("J❤︎"), fromString("K♠︎")])
        XCTAssertFalse(hand.isFlush)

        hand = Hand(cards: [fromString("A❤︎"), fromString("K❤︎")])
        XCTAssertFalse(hand.isFlush)
    }
    
    func testIsHighCard() {
        var hand: Hand

        hand = Hand(cards: [fromString("J❤︎"), fromString("K♠︎")])
        XCTAssertTrue(hand.isHighCard)

        hand = Hand(cards: [fromString("A❤︎"), fromString("A♠︎")])
        XCTAssertFalse(hand.isHighCard)

        hand = Hand(cards: [fromString("J❤︎"), fromString("K❤︎")])
        XCTAssertFalse(hand.isHighCard)
    }

    func testIsStraight() {
        var hand: Hand

        hand = Hand(cards: [fromString("A❤︎"), fromString("K♠︎")])
        XCTAssertTrue(hand.isStraight)

        hand = Hand(cards: [fromString("2❤︎"), fromString("A♠︎")])
        XCTAssertTrue(hand.isStraight)

        hand = Hand(cards: [fromString("A❤︎"), fromString("3♠︎")])
        XCTAssertFalse(hand.isStraight)
    }

    func testIsStraightFlush() {
        var hand: Hand

        hand = Hand(cards: [fromString("A❤︎"), fromString("K❤︎")])
        XCTAssertTrue(hand.isStraightFlush)

        hand = Hand(cards: [fromString("2❤︎"), fromString("A❤︎")])
        XCTAssertTrue(hand.isStraightFlush)
    }

    func testHandNotation() {
        var hand: Hand

        hand = Hand(cards: [fromString("A❤︎"), fromString("K❤︎")])
        XCTAssertEqual(hand.notation, "straight flush: A❤︎ K❤︎")

        hand = Hand(cards: [fromString("A❤︎"), fromString("3❤︎")])
        XCTAssertEqual(hand.notation, "flush: A❤︎ 3❤︎")

        hand = Hand(cards: [fromString("A❤︎"), fromString("K♠︎")])
        XCTAssertEqual(hand.notation, "straight: A❤︎ K♠︎")

        hand = Hand(cards: [fromString("A❤︎"), fromString("A♠︎")])
        XCTAssertEqual(hand.notation, "one pair: A❤︎ A♠︎")

        hand = Hand(cards: [fromString("J❤︎"), fromString("K♠︎")])
        XCTAssertEqual(hand.notation, "high card: J❤︎ K♠︎")
    }

    func fromString(_ str: String) -> Card {
        let rank = String(str.prefix(str.count - 1))
        let suit = String(str.suffix(1))
        return Card(rank: Card.Rank.init(rawValue: rank)!, suit: Card.Suit.init(rawValue: suit)!)
    }
}
