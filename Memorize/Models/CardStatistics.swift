//
//  CardStatistics.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

let masteryPeriod = TimeInterval(7257600) //60*60*24*7*12 12 weeks

class CardStatistics {
	var correctCount:Int = 0
	var incorrectCount:Int = 0
	var lastDifficulty:Float = 1
	var interval:TimeInterval = 0
	var dateLastShown:Date?
	
	var mastery:Float {
		get {
			return (interval >= masteryPeriod ? 1.0 : Float(interval/masteryPeriod))
		}
	}
	
	
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
