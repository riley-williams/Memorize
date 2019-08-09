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
		let unarchiveDirectory = documentsDirectory!.appendingPathComponent("Import4")
		//remove if it exists
		if FileManager.default.fileExists(atPath: unarchiveDirectory.absoluteString) {
			do {
				try FileManager.default.removeItem(atPath: unarchiveDirectory.absoluteString)
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
		if FileManager.default.fileExists(atPath: destination.absoluteString) {
			do {
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
			let json = try? JSONSerialization.jsonObject(with: configRow[models].data(using: .ascii)!, options: [])
			
			var deckModels:[String: AnkiDeckModel] = Dictionary()
			
			if let jsonModels = json as? [String : Any] {
				for (id, jsonModel) in jsonModels {
					deckModels[id] = AnkiDeckModel(json: jsonModel as! [String : Any])
				}
			}
			
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



class AnkiDeckModel {
	var css:String
	var did:Int
	var fields:[AnkiField]
	
	init?(json: [String:Any]) {
		css = json["css"] as? String ?? ""
		did = json["did"] as? Int ?? 0
		fields = []
		for field in json["flds"] as! [[String:Any]] {
			if let f = AnkiField(json: field) {
				fields.append(f)
			}
		}
	}
	
	var description:String {
		var dsc = "DeckModel ID \(did):"
		for field in fields {
			dsc.append(" \(field.description)")
		}
		return dsc
	}
}

class AnkiField {
	var name:String
	var ordinal:Int
	
	init?(json: [String:Any]) {
		name = json["name"] as? String ?? ""
		ordinal = json["ord"] as? Int ?? -1
	}
	
	var description:String {
		return "Field(\(ordinal):\(name))"
	}
}
