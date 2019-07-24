//
//  Card.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//
//	A card exists in a single deck
//

import UIKit

class Card {
	var features:[TextFeature]
	var statistics:CardStatistics = CardStatistics()
	
	var frontFeatures:[TextFeature] {
		get { features.filter { $0.side == .front } }
	}
	var backFeatures:[TextFeature] {
		get { features.filter { $0.side == .back } }
	}
	
	init(features:[TextFeature]) {
		self.features = features
	}
	
	
	
	#if DEBUG
	
	static func testCard() -> Card {
		let front = TextFeature(text: "Test Front", side: .front)
		let back = TextFeature(text: "Test Answer", side: .back)
		return Card(features: [front, back])
	}
	
	#endif
}
