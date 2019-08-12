//
//  AnkiDeck.swift
//  Memorize
//
//  Created by Riley Williams on 8/7/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine
import ZIPFoundation
import SQLite

/// Import Anki decks
class AnkiImporter: ObservableObject {
	@Published var unpackProgress:Float = 0
	@Published var progressDescription:String = "" // { didSet { print(self.progressDescription) } }
	
	let unzipPercent = 0.3 //Progress after unzipping
	
	
	/// Attempts to create a new folder for importing Anki decks.
	/// Removes the existing folder.
	func createOrOverwriteArchiveDirectory() -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		let unarchiveDirectory = documentsDirectory!.appendingPathComponent("Import")
		//remove if it exists
		if FileManager.default.fileExists(atPath: unarchiveDirectory.relativePath) {
			do {
				print("removing existing import directory")
				try FileManager.default.removeItem(atPath: unarchiveDirectory.relativePath)
			} catch {
				assertionFailure("Unable to remove existing directory")
			}
		}
		//create a new one
		try? FileManager.default.createDirectory(at: unarchiveDirectory, withIntermediateDirectories: false, attributes: nil)
		return unarchiveDirectory
	}
	
	func extractFromArchive(_ archive:Archive, fileNamed file:String, to destination:URL) {
		guard let entry = archive[file] else { return }
		
		//remove database file if one already exists. This should never fail unless a previous step fails
		if FileManager.default.fileExists(atPath: destination.relativePath) {
			do {
				print("removing existing file: \(destination.relativePath)")
				try FileManager.default.removeItem(at: destination)
			} catch {
				assertionFailure("Failed to remove existing collection file")
			}
		}
		do {
			try _ = archive.extract(entry, to: destination)
		} catch {
			assertionFailure("Failed to extract \(file) from archive")
		}
	}
	
	
	func convert(_ completion:(Deck)->()) {
		//prepare a directory to keep everything in
		progressDescription = "Preparing"
		let unarchiveDirectory = createOrOverwriteArchiveDirectory()
		
		
		//get a URL to the deck to import
		progressDescription = "Making a local copy"
		//do that here
		//Cheat below for faster testing
		let archiveURL = Bundle.main.url(forResource: "Modern_Greek", withExtension: "zip")!
		
		
		//Unzip just the notes database
		progressDescription = "Extracting notes database"
		guard let archive = Archive(url: archiveURL, accessMode: .read) else { return }
		
		//path where the file will be saved
		let databaseFile = unarchiveDirectory.appendingPathComponent("collection.sqlite3")
		extractFromArchive(archive, fileNamed: "collection.anki2", to: databaseFile)
		
		
		progressDescription = "Reading notes database"
		
		do {
			let db = try Connection(databaseFile.relativePath)
			
			progressDescription = "Converting notes database"
			
			//get card models
			let colTable = Table("col")
			let configRow = try db.pluck(colTable)!
			let models = Expression<String>("models")
			
			let decoder = JSONDecoder()
			let deckModels = try! decoder.decode([String:AnkiModel].self, from: configRow[models].data(using: .utf8)!)
			
			for (id, model) in deckModels {
				print("\(id):\n\(model.description)")
			}
			
			let notesTable = Table("notes")
			let allNotes = Array(try db.prepare(notesTable))
			
			
			let deck = Deck(name: "Test")
			for note in allNotes {
				deck.cards += AnkiNote(note, models: deckModels).cards
			}
			
			progressDescription = "\(deck.cards.count) cards imported!"
			completion(deck)
			
		} catch {
			print("Failed to open database file")
		}
		
	}
	
	func convertAnkiRowToCard(_ row:Row) -> Card {
		let flds = Expression<String>("flds")
		let components = row[flds].split(separator: "\u{001F}")
		
		var features:[TextFeature] = []
		features.append(TextFeature(text: String(components[0]), side: .front))
		features.append(TextFeature(text: String(components[1]), side: .back))
		
		return Card(features: features)
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

struct AnkiField : Codable {
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

/*
//Used for decoding integer values that may sometimes appear as an int or a string
//converts ints to strings and always encodes to a string regardless of original type
struct SometimesString {
	var value:String
}

extension SometimesString : Codable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		do {
			//try to decode as an integer
			self = try .init(value: "\(container.decode(Int64.self))")
		} catch DecodingError.typeMismatch {
			//if that fails, try to decode as a string
			do {
				self = try .init(value: container.decode(String.self))
			} catch DecodingError.typeMismatch {
				//It's neither. uh oh.
				throw DecodingError.typeMismatch(SometimesString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Content was neither decodable as a String nor an Int"))
			}
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self)
	}
}
*/
