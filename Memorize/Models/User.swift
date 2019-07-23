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
		for i in 0..<5 {
			user.decks.append(Deck.testDeck(number: i))
		}
		
		return user
	}
	
	#endif
}
