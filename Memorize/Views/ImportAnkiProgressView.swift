//
//  ImportAnkiView.swift
//  Memorize
//
//  Created by Riley Williams on 8/7/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct ImportAnkiProgressView: View {
	@ObservedObject var ankiDeck:AnkiDeck = AnkiDeck()
	@EnvironmentObject var user:User
	
	
	var body: some View {
		VStack {
			Text("\(ankiDeck.progressDescription)")
			
			Button(action: {
				self.ankiDeck.convert() { deck in
					self.user.decks.append(deck)
				}
			}) {
				Text("Start Import")
			}
		}
	}
}

#if DEBUG
struct ImportAnkiProgressView_Previews: PreviewProvider {
	static var previews: some View {
		ImportAnkiProgressView().environmentObject(User.testUser(name: "Tester"))
	}
}
#endif
