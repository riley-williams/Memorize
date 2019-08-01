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
		VStack() {
			
			HStack(alignment:.top) {
				DeckIcon(deck: deck, showsDue: false, width: 120)
					.padding([.leading, .trailing])
				
				VStack(alignment: .leading, spacing: 10) {
					Text(deck.name)
						.font(.headline)
						.bold()
                        .lineLimit(2)
                    
					HStack {
						ProgressBarView(size: .regular, progress: deck.mastery)
							.frame(width:100)
						Text("\(Int(deck.mastery * 100))%")
							.font(.headline)
                        Spacer()
					}
				}
				
			}
			
			Spacer()
			
			NavigationLink(destination: CardPresenterView(cards: deck.cardsDue)) {
				Text("Study")
				.font(.headline)
			}
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
