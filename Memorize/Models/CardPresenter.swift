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
	var currentCard:Card { get { cards.count > 0 ? cards[0] : Card.blank } }
	var areCardsRemaining:Bool { get { cards.count >= 1 } }
	
	let objectWillChange = PassthroughSubject<CardPresenter, Never>()
	
	
	init(_ cards:[Card]) {
		self.cards = cards
	}
	
	func updateCurrentCard(_ difficulty:CardStatistics.Difficulty) {
		if areCardsRemaining {
			currentCard.statistics.updateStats(difficulty)
			if difficulty != .wrong {
				completedCards.append(cards.removeFirst())
			} else {
				cards.append(cards.removeFirst())
			}
			objectWillChange.send(self)
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
