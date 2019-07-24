//
//  DeckView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckView: View {
	var user:User
	
	var body: some View {
		NavigationView {
			List(user.decks) { deck in
				NavigationLink(destination:DeckDetailView(deck: deck)) {
					DeckRow(deck:deck)
				}
			}
			.navigationBarTitle(Text("Decks"))
		}
		
	}
}


struct DeckRow: View {
	var deck: Deck
	
	var body: some View {
		HStack() {
			DeckIcon(deck:deck, width: 70)
			
			VStack(alignment: .leading) {
				Text(deck.name)
					.font(.headline)
				Text("\(Int(deck.mastery*100))%")
					.font(.subheadline)
			}.padding()
			
			Spacer()
		}
	}
}


#if DEBUG
struct DeckView_Previews: PreviewProvider {
	
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return Group {
			DeckView(user:testUser)
			
			DeckRow(deck: testUser.decks[0])
				.previewLayout(.fixed(width: 300, height: 70))
		}
	}
}
#endif
