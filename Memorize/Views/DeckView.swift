//
//  DeckView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckView: View {
	@EnvironmentObject var user:User
	@State var isShowingAddDecks:Bool = false
	
	var body: some View {
		ZStack {
			NavigationView {
				ScrollView {
					ForEach(user.decks) { deck in
						NavigationLink(destination:DeckDetailView(deck: deck)) {
								DeckRow(deck:deck).padding(.horizontal)
						}.buttonStyle(PlainButtonStyle())
					}
					
				}.navigationBarTitle(Text("Decks"))
					.navigationBarItems(trailing: Button(action: {
						self.isShowingAddDecks.toggle()
					}) {
						Text("Add")
					})
			}
			
			if isShowingAddDecks {
				VStack {
					AddDecksView().offset(CGSize(width: 0, height: 50))
					ImportAnkiProgressView()
					Spacer()
				}
			}
		}
	}
}


struct DeckRow: View {
	var deck: Deck
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				Rectangle()
					.foregroundColor(.white)
				Rectangle()
					.frame(width:geometry.size.width*CGFloat(self.deck.mastery))
					.foregroundColor(.blue)
			}.cornerRadius(15)
				.shadow(radius: 5)
			
			HStack(alignment: .center) {
				DeckIcon(deck:deck, width: 70)
					.foregroundColor(.black)
					.padding()
				VStack(alignment: .leading, spacing: 0) {
					Text(deck.name)
						.font(.headline)
						.lineLimit(2)
						.foregroundColor(.black)
				}
				Spacer()
			}
		}
	}
}


#if DEBUG
struct DeckView_Previews: PreviewProvider {
	
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return Group {
			DeckView().environmentObject(testUser)
			
			DeckRow(deck: testUser.decks[0])
				.previewLayout(.fixed(width: 300, height: 70))
			
		}
	}
}
#endif
