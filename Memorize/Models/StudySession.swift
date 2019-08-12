//
//  CardSession.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine

/// Represents a study session
class StudySession : ObservableObject {
	@Published var cards:[Card]
	/// Array holding cards that have been answered correctly
	@Published var completedCards:[Card] = []
	/// The first card in the `cards` array, or a `Card.blank` if `cards` is empty
	var currentCard:Card { get { cards.count > 0 ? cards[0] : Card.blank } }
	var areCardsRemaining:Bool { get { endTime != nil ? false : cards.count >= 1 } }
	
	private var startTime:Date?
	private var endTime:Date?
	
	/// returns the amount of time the study session has been active.
	/// If endTime is nil, the current time is used
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
	
	/// Moves the current card into completedCards if it was answered correctly, and calls the appropriate methods on the current card to update it's stats
	/// - Parameter difficulty: _Required._ Difficulty of the current card
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
	
	/// Starts the study session timer
	/// If the timer has already started, it will not be reset
	func start() {
		if startTime == nil {
			startTime = Date()
		}
	}
	
	/// Ends the study session timer
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
