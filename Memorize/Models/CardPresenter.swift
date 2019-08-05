//
//  CardPresenter.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine

class CardPresenter : ObservableObject {
	var cards:[Card]
	private var completedCards:[Card] = []
	let objectWillChange = PassthroughSubject<CardPresenter, Never>()
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
		objectWillChange.send(self)
	}
	
	#if DEBUG
	
	static func testPresenter() -> CardPresenter {
		let testUser = User.testUser(name: "Tester")
		
		let presenter = CardPresenter(testUser.decks[0].cardsDue)
		
		return presenter
	}
	
	#endif
}
