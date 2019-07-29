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
		HStack(alignment: .center) {
			DeckIcon(deck:deck, width: 70)
			
			VStack(alignment: .leading, spacing: 0) {
				Text(deck.name)
					.font(.headline)
				HStack(alignment: .center) {
					ProgressBarView(size: .small, progress: deck.mastery)
						.frame(width: 75)
					Text("\(Int(deck.mastery*100))%")
						.font(.subheadline)
				}
				
			}.padding(.leading)
			Spacer()
		}.frame(height: 70)
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
