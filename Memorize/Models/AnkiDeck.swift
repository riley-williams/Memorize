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
	let fileManager = FileManager()
	
	let objectWillChange = PassthroughSubject<AnkiDeck, Never>()
	
	init() {
		progressDescription = "Copying to documents"
		let archiveURL = Bundle.main.url(forResource: "NATO_phonetic_alphabet", withExtension: "zip")!
		guard let archive = Archive(url: archiveURL, accessMode: .read) else { return }
		guard let entry = archive["collection.anki2"] else { return }
		
		//
		guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return }
		let databaseFile = documentsDirectory.appendingPathComponent("collection.sqlite3")
		
		progressDescription = "Extracting notes database"
		
		if FileManager.default.fileExists(atPath: databaseFile.relativePath) {
			do {
				try FileManager.default.removeItem(at: databaseFile)
			} catch {
				print("failed to delete item")
			}
		}
		
		do {
			try _ = archive.extract(entry, to: databaseFile)
			
			progressDescription = "Reading notes database"
			
			do {
				let db = try Connection(databaseFile.relativePath)
				
				progressDescription = "Converting notes database"
				
				let notes = Table("notes")
				let allNotes = Array(try db.prepare(notes))
				let id = Expression<Int64>("id")
				let flds = Expression<String>("flds")
				
				print("\(allNotes.count) rows")
				print("\(allNotes[0])")
				print("id:\(allNotes[0][id]) flds:\(allNotes[0][flds])")
			} catch {
				print("Failed to open database file")
			}
			
			
			
		} catch {
			print("extracting entry failed")
		}
		
		
		
	}
	
}
