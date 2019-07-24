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
				ZStack {
					RoundedRectangle(cornerRadius: 18)
						.frame(width: 119, height: 85, alignment: .center)
						.foregroundColor(.gray)
						.offset(x: 5, y: -5)
					Image(uiImage:deck.icon!)
						.resizable()
						.scaledToFill()
						.frame(width: 119, height: 85)
						.clipShape(RoundedRectangle(cornerRadius: 15))
						.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 3))
				}.padding(.leading)
					.padding(.trailing)
				
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
