//
//  AnkiDeckModel.swift
//  Memorize
//
//  Created by Riley Williams on 8/9/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

struct AnkiDeckModel : Codable {
	var css:String
	var deckID:Int
	var modelID:String
	var fields:[AnkiField]
	var templates:[AnkiTemplate]
	
	enum CodingKeys: String, CodingKey {
		case css = "css"
		case deckID = "did"
		case fields = "flds"
		case modelID = "id"
		case templates = "tmpls"
	}
	
	var description:String {
		var dsc = "DeckModel ID \(deckID):"
		for field in fields {
			dsc.append(" \(field.description)")
		}
		return dsc
	}
}
