//
//  AnkiDeckModel.swift
//  Memorize
//
//  Created by Riley Williams on 8/9/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

struct AnkiModel : Codable {
//	var crowdAnkiUUID:String
	var css:String
	var deckID:Int
//	var modelID:String
	var fields:[AnkiField]
//	var latexPost:String
//	var latexPre:String
//	var mod:Int
	var name:String
//	var sortf:Int
//	var tags:[String]
	var templates:[AnkiTemplate]
//	var type:Int
//	var usn:Int
	
	enum CodingKeys: String, CodingKey {
//		case crowdAnkiUUID = "crowdanki_uuid"
		case css = "css"
		case deckID = "did"
//		case modelID = "id"
		case fields = "flds"
//		case latexPost
//		case latexPre
//		case mod
		case name
//		case sortf
//		case tags
		case templates = "tmpls"
//		case type
//		case usn
	}
	
	var description:String {
		var dsc = "DeckModel ID \(deckID):"
		for field in fields {
			dsc.append(" \(field.description)")
		}
		return dsc
	}
}
