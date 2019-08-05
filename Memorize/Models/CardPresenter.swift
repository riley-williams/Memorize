//
//  CardPresenter.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

class CardPresenter {
	var cards:[Card]
	private var completedCards:[Card] = []
	
	var currentCard:Card { get { cards[0] } }
	var areCardsRemaining:Bool { get { cards.count >= 1 } }
	
	init(_ cards:[Card]) {
		self.cards = cards
	}
	
	func updateCurrentCard(_ difficulty:CardStatistics.Difficulty) {
		currentCard.statistics.updateStats(difficulty)
		if difficulty != .wrong {
			completedCards.append(cards.removeFirst())
		} else {
			cards.append(cards.removeFirst())
		}
	}
	
	#if DEBUG
	
	static func testPresenter() -> CardPresenter {
		let testUser = User.testUser(name: "Tester")
		
		let presenter = CardPresenter(testUser.decks[0].cardsDue)
		
		return presenter
	}
	
	#endif
}
