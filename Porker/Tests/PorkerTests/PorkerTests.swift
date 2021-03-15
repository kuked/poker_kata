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

        card1 = Card(rank: .ace, suit: .heart)
        card2 = Card(rank: .two, suit: .heart)
        XCTAssertTrue(card1.hasSameSuit(card2))

        card1 = Card(rank: .ace, suit: .spade)
        card2 = Card(rank: .two, suit: .heart)
        XCTAssertFalse(card1.hasSameSuit(card2))
    }

    func testHasSameRank() {
        var card1: Card
        var card2: Card

        card1 = Card(rank: .ace, suit: .spade)
        card2 = Card(rank: .ace, suit: .heart)
        XCTAssertTrue(card1.hasSameRank(card2))

        card1 = Card(rank: .ace, suit: .spade)
        card2 = Card(rank: .two, suit: .heart)
        XCTAssertFalse(card1.hasSameRank(card2))
    }

    func testCardEqual() {
        XCTAssertEqual(Card(rank: .ace, suit: .spade), Card(rank: .ace, suit: .spade))

        XCTAssertNotEqual(Card(rank: .ace, suit: .spade), Card(rank: .two, suit: .spade))
        XCTAssertNotEqual(Card(rank: .ace, suit: .spade), Card(rank: .ace, suit: .heart))
        XCTAssertNotEqual(Card(rank: .ace, suit: .spade), Card(rank: .queen, suit: .heart))
    }
    
    func testIsPair() {
        var card1: Card
        var card2: Card
        var hand: Hand

        card1 = Card(rank: .ace, suit: .heart)
        card2 = Card(rank: .ace, suit: .spade)
        hand = Hand(cards: [card1, card2])
        XCTAssertTrue(hand.isPair)
        
        card1 = Card(rank: .jack, suit: .heart)
        card2 = Card(rank: .king, suit: .spade)
        hand = Hand(cards: [card1, card2])
        XCTAssertFalse(hand.isPair)
    }
    
    func testIsFlush() {
        var card1: Card
        var card2: Card
        var hand: Hand

        card1 = Card(rank: .jack, suit: .heart)
        card2 = Card(rank: .king, suit: .heart)
        hand = Hand(cards: [card1, card2])
        XCTAssertTrue(hand.isFlush)
        
        card1 = Card(rank: .jack, suit: .heart)
        card2 = Card(rank: .king, suit: .spade)
        hand = Hand(cards: [card1, card2])
        XCTAssertFalse(hand.isFlush)
    }
    
    func testIsHighCard() {
        var card1: Card
        var card2: Card
        var hand: Hand
        
        card1 = Card(rank: .jack, suit: .heart)
        card2 = Card(rank: .king, suit: .spade)
        hand = Hand(cards: [card1, card2])
        XCTAssertTrue(hand.isHighCard)

        card1 = Card(rank: .ace, suit: .heart)
        card2 = Card(rank: .ace, suit: .spade)
        hand = Hand(cards: [card1, card2])
        XCTAssertFalse(hand.isHighCard)
        
        card1 = Card(rank: .jack, suit: .heart)
        card2 = Card(rank: .king, suit: .heart)
        hand = Hand(cards: [card1, card2])
        XCTAssertFalse(hand.isHighCard)
    }
}
