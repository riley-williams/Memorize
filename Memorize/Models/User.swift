//
//  User.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

class User {
	var Q:Float = 1 //User Q factor. Estimates ability to memorize
	var name:String
	var decks:[Deck] = []
	
	init(name:String) {
		self.name = name
	}
	
	
	#if DEBUG
	
	static func testUser(name:String) -> User {
		let user = User(name:name)
		
		//Preview code relies on these
		let greek = Deck.testDeck(name: "Greek", percentMastery: 0.77)
		greek.icon = #imageLiteral(resourceName: "Greek")
		user.decks.append(greek)
		
		let states = Deck.testDeck(name: "States", percentMastery: 1.0)
		states.icon = #imageLiteral(resourceName: "States")
		user.decks.append(states)
		
		let mythology = Deck.testDeck(name: "Greek Mythology", percentMastery: 0.2)
		mythology.icon = #imageLiteral(resourceName: "Mythology")
		user.decks.append(mythology)
		
		let anatomy = Deck.testDeck(name: "Anatomy", percentMastery: 0.0)
		anatomy.icon = #imageLiteral(resourceName: "Heart")
		user.decks.append(anatomy)
		
		let numbers = Deck.testDeck(name: "Numbers", percentMastery: 0.5)
		user.decks.append(numbers)
		
		return user
	}
	
	#endif
}
