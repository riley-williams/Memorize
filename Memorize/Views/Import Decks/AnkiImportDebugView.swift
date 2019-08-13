//
//  AnkiImportDebugView.swift
//  Memorize
//
//  Created by Riley Williams on 8/13/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI
import Combine

struct AnkiImportDebugView: View {
	@EnvironmentObject var user:User
	var decks:[TestAnki]
	
	
    var body: some View {
		NavigationView {
			List(decks) { d in
				NavigationLink(destination: SelectAnkiTemplatesView(deckFile: Bundle.main.url(forResource: d.file, withExtension: "")!)) {
					Text(d.name)
				}
			}.navigationBarTitle("Test Decks")
		}
    }
	
	
	
	init() {
		let testDecks = [
			"Nato Alphabet" : "NATO_phonetic_alphabet.zip",
			"Greek 23000" : "Greek_23000_wtf.zip",
			"Ultimate Geography" : "Ultimate_Geography.zip",
			"Greek Sentences w/ audio" : "6000_Greek_sentences_sorted_by_difficulty_with_audio.zip",
			"GSBC Greek Vocab" : "GBSC_2015_Greek_Vocab__Grammar.zip",
			"Modern Greek" : "Modern_Greek.zip"]
		
		decks = testDecks.map() { (key, value) in
			return TestAnki(name: key, file: value)
		}
	}
}

#if DEBUG
struct AnkiImportDebugView_Previews: PreviewProvider {
    static var previews: some View {
		let user = User.testUser(name: "Tester")
		return AnkiImportDebugView().environmentObject(user)
    }
}
#endif



class TestAnki: Identifiable, ObservableObject {
	var name:String
	var file:String
	
	internal init(name: String, file: String) {
		self.name = name
		self.file = file
	}
	
}
