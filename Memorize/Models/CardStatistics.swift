//
//  CardStatistics.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

class CardStatistics {
	var correctCount:Int = 0
	var incorrectCount:Int = 0
	var lastDifficulty:Float = 1
	var interval:TimeInterval = 0
	var dateLastShown:Date?
	
	
	func updateStatsCorrect(_ difficulty:Float) {
		correctCount += 1
		dateLastShown = Date()
		#warning("update the time interval here")
	}
	
	func updateStatsIncorrect() {
		incorrectCount += 1
		#warning("update the time interval here")
	}
}
