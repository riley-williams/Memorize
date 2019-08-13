//
//  AnkiDeckModels.swift
//  Memorize
//
//  Created by Riley Williams on 8/9/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

struct AnkiModel : Codable, CustomStringConvertible {
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

struct AnkiTemplate : Codable {
	var answerFormat:String
	var bafmt:String
	var bqfmt:String
	var name:String
	var ord:Int
	var questionFormat:String
	
	enum CodingKeys: String, CodingKey {
		case answerFormat = "afmt"
		case bafmt
		case bqfmt
		case name
		case ord
		case questionFormat = "qfmt"
		
	}
}

struct AnkiField : Codable, CustomStringConvertible {
	var name:String
	var ordinal:Int
	var media:[String]
	var font:String
	var rtl:Bool
	var size:Double
	var sticky:Bool
	
	
	enum CodingKeys: String, CodingKey {
		case name
		case ordinal = "ord"
		case media
		case font
		case rtl
		case size
		case sticky
		
	}
	
	var description:String {
		return "Field(\(ordinal):\(name))"
	}
}
