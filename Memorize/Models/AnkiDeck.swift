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

class AnkiDeck: ObservableObject {
	var unpackProgress:Float = 0 { didSet { objectWillChange.send(self) } }
	var progressDescription:String = "" { didSet { objectWillChange.send(self) } }
	
	let objectWillChange = PassthroughSubject<AnkiDeck, Never>()
	
	let unzipPercent = 0.3 //Progress after unzipping
	
	
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
		let archiveURL = Bundle.main.url(forResource: "NATO_phonetic_alphabet", withExtension: "zip")!
		
		
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
			let deckModels = try! decoder.decode([String:AnkiDeckModel].self, from: configRow[models].data(using: .ascii)!)
			
			for (id, model) in deckModels {
				print("\(id):\n\(model.description)")
			}
			
			let notesTable = Table("notes")
			let allNotes = Array(try db.prepare(notesTable))
			let id = Expression<Int64>("id")
			let flds = Expression<String>("flds")
			
			
			print("\(allNotes.count) rows")
			print("\(allNotes[0])")
			print("id:\(allNotes[0][id]) flds:\(allNotes[0][flds])")
			
			
			let deck = Deck(name: "Test")
			for note in allNotes {
				deck.cards.append(convertAnkiRowToCard(note))
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

struct AnkiTemplate : Codable {
	var afmt:String
	var bafmt:String
	var bqfmt:String
	var name:String
	var ord:Int
	var qfmt:String
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
