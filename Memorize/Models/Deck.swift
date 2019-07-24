//
//  Deck.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit
import SwiftUI

class Deck : Identifiable {
	var name:String
	var description:String = ""
	var icon:UIImage?
	var cards:[Card] = []
	
	var mastery:Float {
		get {
			return cards.reduce(0) {
				$0 + $1.statistics.mastery
			} / Float(cards.count)
		}
	}
	
	init(name:String) {
		self.name = name
	}
	
	
	
	#if DEBUG
	
	static func testDeck(number:Int) -> Deck {
		let deck:Deck = Deck(name: "Test Deck \(number)")
		deck.description = "This is a short description of what cards are in\(deck.name)."
		for _ in 0..<5 {
			deck.cards.append(Card.testCard())
		}
		return deck
	}
	
	#endif
}
