//
//  Deck.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

class Deck : Identifiable {
	var name:String
	var description:String = ""
	var icon:UIImage = #imageLiteral(resourceName: "Default")
	var cards:[Card] = []
	
	var mastery:Float {
		get { cards.reduce(0) { $0 + $1.statistics.mastery } / Float(cards.count) }
	}
	var cardsDue:[Card] {
		get { cards.filter { card in card.statistics.isDue } }
	}
	var numCardsDue:Int {
		get { cards.reduce(0) { result, card in result + (card.statistics.isDue ? 1 : 0) } }
	}
	
	init(name:String) {
		self.name = name
	}
	

	
	#if DEBUG
	
	static func testDeck(name:String, percentMastery:Float, numCards:Int) -> Deck {
		let deck:Deck = Deck(name: name)
		deck.description = "This is a short description of what cards are in\(deck.name)."
		for i in 0..<numCards {
			let c = Card.testCard(number: i)
			c.statistics.interval = TimeInterval(percentMastery * Float(CardStatistics.masteryPeriod))
			deck.cards.append(c)
		}
		return deck
	}
	
	#endif
}
