//
//  CardPresenterView.swift
//  Memorize
//
//  Created by Riley Williams on 7/30/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CardPresenterView: View {
	var cards:[Card]
	@GestureState var dragInProgress:Bool = false
	@State var cardTranslation:CGSize = CGSize.zero
	var body: some View {
		VStack {
			CardView(card:cards[0])
				.foregroundColor(dragInProgress ? .green : .white)
				.offset(cardTranslation)
				.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).updating($dragInProgress) { value, state, _ in
					state = true
					self.cardTranslation = value.translation
				})
			
			VStack {
				HStack {
					
					Image(systemName: "arrow.turn.up.left")
						.font(Font.headline.weight(.bold))
						.foregroundColor(.red)
						.padding(.leading)
					Text("Wrong")
						.font(.headline)
						.foregroundColor(.red)
					
					Spacer()
					
					Text("Average")
						.font(.headline)
						.foregroundColor(.blue)
					Image(systemName: "arrow.turn.up.right")
						.font(Font.headline.weight(.bold))
						.foregroundColor(.blue)
						.padding(.trailing)
				}
				
				HStack {
					Button(action: {}) {
						ZStack {
							Rectangle()
								.foregroundColor(.orange)
							Text("Hard")
								.font(.headline)
								.foregroundColor(.white)
						}
					}
					
					Button(action: {}) {
						ZStack {
							Rectangle()
								.foregroundColor(.green)
							Text("Easy")
								.font(.headline)
								.foregroundColor(.white)
						}
					}
					
				}.frame(height: 50)
			}
		}
	}
}

#if DEBUG
struct CardPresenterView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return CardPresenterView(cards: testUser.decks[0].cards)
	}
}
#endif
