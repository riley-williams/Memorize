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
	
	
	static let masteryPeriod = TimeInterval(7257600) //60*60*24*7*12 12 weeks
	var mastery:Float {
		get {
			return (interval >= CardStatistics.masteryPeriod ? 1.0 : Float(interval/CardStatistics.masteryPeriod))
		}
	}
	
	var isDue: Bool {
		get {
			if dateLastShown != nil {
				return dateLastShown!.addingTimeInterval(interval) <= Date()
			} else {
				return true
			}
		}
	}
	
	func updateStatsCorrect(_ difficulty:Float) {
		correctCount += 1
		dateLastShown = Date()
		//TODO: update statistics
	}
	
	func updateStatsIncorrect() {
		incorrectCount += 1
		//TODO: update statistics
	}
}
