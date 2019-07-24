//
//  DeckDetailView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckDetailView: View {
	var deck:Deck
	
	var body: some View {
		VStack(alignment:.leading) {
			DeckStatisticsView(deck: deck)
			
			HStack(alignment:.top) {
				DeckIcon(deck: deck, width: 120)
					.padding([.leading, .trailing])
				
				VStack(alignment: .leading) {
					Text(deck.name)
						.font(.title)
						.bold()
					Text("\(Int(deck.mastery * 100))%")
						.font(.headline)
				}
				Spacer()
			}
			Spacer()
		}
	}
}

struct DeckStatisticsView: View {
	var deck:Deck
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("2 Cards Due")
			Text("Studied 1 hr")
		}
	}
}


#if DEBUG
struct DeckDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return DeckDetailView(deck: testUser.decks[0])
	}
}
#endif
