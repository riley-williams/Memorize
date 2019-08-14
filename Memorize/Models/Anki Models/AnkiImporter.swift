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
	//	@Published var unpackProgress:Float = 0
	@Published var progressDescription:String = "Waiting to start import"
	@Published var cardsImported:Int = 0
	@Published var cardsSkipped:Int = 0
	private var archiveURL:URL
	private var db:Connection?
	var models:[String: AnkiModel] = [:]
	@Published var didCreateDatabaseConnection:Bool = false
	
	init(_ url:URL) {
		archiveURL = url
	}
	
	
	/// Attempts to create a new folder for importing Anki decks.
	/// Removes the existing folder.
	/// Returns the URL for the new empty import folder
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
	
	/// Extracts a single file from an Archive
	/// - Parameter archive: The `Archive` object to extract files from
	/// - Parameter file: The file to extract
	/// - Parameter destination: The destination file
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
	
	/// Converts all models & templates in the database
	/// - Parameter completion: passes the converted deck upon finishing conversion
	func convertNoOptions(_ completion:(Deck)->()) {
		extractDatabase()
		if self.db != nil {
			extractDatabaseModels()
			convertNotes() { deck in
				completion(deck)
			}
		}
	}
	
	/// Extracts the database file from an Anki package and creates a connection
	func extractDatabase() {
		//prepare a directory to keep everything in
		progressDescription = "Preparing"
		let unarchiveDirectory = createOrOverwriteArchiveDirectory()
		
		
		//get a URL to the deck to import
		progressDescription = "Making a local copy"
		//do that here
		//TODO: make a local copy?
		
		
		//Unzip just the notes database
		progressDescription = "Extracting notes database"
		guard let archive = Archive(url: archiveURL, accessMode: .read) else {
			progressDescription = "Failed to extract notes database"
			return
		}
		
		//path where the file will be saved
		let databaseFile = unarchiveDirectory.appendingPathComponent("collection.sqlite3")
		extractFromArchive(archive, fileNamed: "collection.anki2", to: databaseFile)
		
		
		progressDescription = "Reading notes database"
		
		do {
			self.db = try Connection(databaseFile.relativePath)
			self.didCreateDatabaseConnection = true
		} catch {
			print("Failed to open database file")
		}
		
	}
	
	/// Extracts the models from the database
	func extractDatabaseModels() {
		if db != nil {
			do {
				progressDescription = "Extracting models"
				
				//get card models
				let colTable = Table("col")
				let configRow = try db!.pluck(colTable)!
				let models = Expression<String>("models")
				
				let decoder = JSONDecoder()
				self.models = try! decoder.decode([String:AnkiModel].self, from: configRow[models].data(using: .utf8)!)
				
			} catch {
				progressDescription = "Failed to extract models"
			}
		} else {
			progressDescription = "Database connection does not exist"
		}
	}
	
	
	/// Converts the notes in the database based on the model file passed in
	/// - Parameter completion: Passes the converted Deck to a completion
	func convertNotes(_ completion:(Deck)->()) {
		if db != nil {
			do {
				progressDescription = "Converting notes database"
				
				//get cards
				let notesTable = Table("notes")
				let allNotes = Array(try db!.prepare(notesTable))
				
				//convert cards
				let deck = Deck(name: "Test")
				for note in allNotes {
					deck.cards += AnkiNote(note, models: self.models)?.cards ?? []
				}
				
				progressDescription = "\(deck.cards.count) cards imported!"
				completion(deck)
			} catch {
				progressDescription = "An error occured while converting the notes"
			}
		}
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
