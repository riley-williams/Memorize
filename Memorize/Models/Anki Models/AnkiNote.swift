//
//  AnkiNote.swift
//  Memorize
//
//  Created by Riley Williams on 8/9/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit
import SQLite

struct AnkiNote {
	var model:AnkiModel
	var fields:[String] = []
	var sfld:String
	
	/// Initializes a note. Note initialization will return nil if the model it requires is not provided
	/// - Parameter row: The database row for the note
	/// - Parameter models: Models available for displaying/converting note
	init?(_ row:Row, models:[String:AnkiModel]) {
		let flds = Expression<String>("flds")
		
		let components = row[flds].split(separator: "\u{001F}")
		for c in components {
			fields.append(String(c))
		}
		
		let sfld = Expression<String>("sfld")
		self.sfld = row[sfld]
		
		let mid = Expression<Int>("mid")
		let modelID = "\(row[mid])"
		if let model = models[modelID] {
			self.model = model
		} else {
			return nil
		}
	}
	
	var cards:[Card] {
		var cards:[Card] = []
		for template in model.templates {
			var features:[TextFeature] = []
			for f in model.fields {
				var side:Side = .back
				if template.questionFormat.contains("{{\(f.name)}}") {
					side = .front
				}
				
				if f.ordinal >= 0 && f.ordinal < fields.count {
					features.append(TextFeature(text: fields[f.ordinal], side: side))
				}
			}
			cards.append(Card(features: features))
		}
		return cards
	}
	
}
