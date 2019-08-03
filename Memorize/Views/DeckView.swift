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
		ZStack {
			ZStack(alignment: .topLeading) {
				GeometryReader { geometry in
					RoundedRectangle(cornerRadius: 15)
						.foregroundColor(.white)
					Rectangle()
						.frame(width:geometry.size.width*CGFloat(self.deck.mastery))
						.foregroundColor(.blue)
				}
				
			}.cornerRadius(15)
			.shadow(radius: 5)
				.padding(.vertical, 5)
			
			
			HStack(alignment: .center) {
				DeckIcon(deck:deck, width: 70)
					.padding()
				VStack(alignment: .leading, spacing: 0) {
					Text(deck.name)
						.font(.headline)
						.lineLimit(2)
				}
				Spacer()
			}
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
