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
			
			HStack(alignment:.top) {
				DeckIcon(deck: deck, width: 120)
					.padding([.leading, .trailing])
				
				VStack(alignment: .leading, spacing: 10) {
					Text(deck.name)
						.font(.title)
						.bold()
						
					HStack {
						ProgressBarView(size: .regular, width: 100, progress: deck.mastery)
						Text("\(Int(deck.mastery * 100))%")
							.font(.headline)
					}
				}
				Spacer()
			}
			Spacer()
		}
	}
}


#if DEBUG
struct DeckDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return DeckDetailView(deck: testUser.decks[2])
	}
}
#endif
