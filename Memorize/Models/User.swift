//
//  User.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine

class User : ObservableObject {
	var Q:Float = 1 //User Q factor. Estimates ability to memorize
	@Published var name:String
	@Published var rootContainer:Container = Container("All")
	@Published var decks:[Deck]
	

	init(name:String) {
		self.name = name
		self.decks = []
	}
	
	/// Convenience for `.append(Deck(name:))`
	/// - Parameter name: _Required._ Name of the new deck
	func newDeck(name _:String) -> Deck {
		let newDeck = Deck(name: name)
		self.decks.append(newDeck)
		return newDeck
	}
	
	/// Convenience for `.append(Deck(name:))`
	/// - Parameter name: _Required._ Name of the new deck
	/// - Parameter description: _Required._ Name of the new deck
	func newDeck(_ name:String, description:String) -> Deck {
		let newDeck = Deck(name: name)
		newDeck.description = description
		self.decks.append(newDeck)
		return newDeck
	}
	
}


#if DEBUG

extension User {
	static func testUser(name:String) -> User {
		let user = User(name:name)
		
		let greekContainer = Container("Greek")
		user.rootContainer.items.append(greekContainer)
		
		//Preview code relies on these
		let greek = Deck.testDeck(name: "Greek", percentMastery: 0.77, numCards: 5)
		greek.icon = #imageLiteral(resourceName: "Greek")
		greekContainer.items.append(greek)
		
		let states = Deck.testDeck(name: "States", percentMastery: 1.0, numCards: 20)
		states.icon = #imageLiteral(resourceName: "States")
		user.rootContainer.items.append(states)
		
		let mythology = Deck.testDeck(name: "Greek Mythology", percentMastery: 0.2, numCards: 1)
		mythology.icon = #imageLiteral(resourceName: "Mythology")
		greekContainer.items.append(mythology)
		
		let anatomy = Deck.testDeck(name: "Anatomy", percentMastery: 0.0, numCards: 175)
		anatomy.icon = #imageLiteral(resourceName: "Heart")
		user.rootContainer.items.append(anatomy)
		
		let numbers = Deck.testDeck(name: "This is a stupid long name a user would give a deck to break the UI there really should be no reason to have a deck like this", percentMastery: 0.5, numCards: 2500)
		user.rootContainer.items.append(numbers)
		
		return user
	}
}

#endif

