//
//  CardSession.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine

class StudySession : ObservableObject {
	@Published var cards:[Card]
	@Published var completedCards:[Card] = []
	var currentCard:Card { get { cards.count > 0 ? cards[0] : Card.blank } }
	var areCardsRemaining:Bool { get { endTime != nil ? false : cards.count >= 1 } }
	
	private var startTime:Date?
	private var endTime:Date?
	
	var time:TimeInterval {
		get {
			if startTime != nil {
				if endTime != nil {
					return endTime!.timeIntervalSince(startTime!)
				} else {
					return startTime!.timeIntervalSinceNow
				}
			} else {
				return 0
			}
		}
	}
	
	init(_ cards:[Card]) {
		self.cards = cards
	}
	
	func updateCurrentCard(_ difficulty:CardStatistics.Difficulty) {
		if areCardsRemaining {
			currentCard.statistics.updateStats(difficulty)
			if difficulty != .wrong {
				completedCards.append(cards.removeFirst())
				if !areCardsRemaining {
					finish()
				}
			} else {
				cards.append(cards.removeFirst())
			}
		}
	}
	
	func start() {
		if startTime == nil {
			startTime = Date()
		}
	}
	
	func finish() {
		if endTime == nil {
			endTime = Date()
		}
	}
	
	#if DEBUG
	
	static func testSession() -> StudySession {
		let testUser = User.testUser(name: "Tester")
		
		let session = StudySession(testUser.decks[0].cardsDue)
		
		return session
	}
	
	#endif
}
