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
	@State private var cardTranslation:CGFloat = 0
	@State private var isShowingAnswer:Bool = false
	
	var body: some View {
		VStack {
			CardView(card:cards[0], showingAnswer: $isShowingAnswer)
				.foregroundColor(dragInProgress ? .green : .white)
				.offset(x:cardTranslation)
				.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
					.updating($dragInProgress) { value, state, _ in
						state = true
						self.cardTranslation = value.translation.width
				}.onEnded { value in
					withAnimation(.easeIn) {
						self.cardTranslation = -400
					}
					
				})
			
			AnswerView()
		}
	}
}


struct CardView: View {
	var card: Card
	@Binding var showingAnswer: Bool
	var visibleFeatures: [TextFeature] {
		get { showingAnswer ? card.features : card.frontFeatures }
	}
	
	var body: some View {
		
		ZStack {
            RoundedRectangle(cornerRadius: 20)
				.border(Color.gray, width: 4)
				.foregroundColor(.white)
				.padding()
			
			VStack {
				ForEach(visibleFeatures) {
                    Text($0.text).padding(.all)
				}
			}
        }.onTapGesture {
			self.showingAnswer = !self.showingAnswer
		}
	}
	
}

struct AnswerView: View {
	var body: some View {
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
				
				Text("Correct")
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
				}.cornerRadius(15)
					.padding(.leading)
				
				Button(action: {}) {
					ZStack {
						Rectangle()
							.foregroundColor(.green)
						Text("Easy")
							.font(.headline)
							.foregroundColor(.white)
					}
				}.cornerRadius(15)
					.padding(.trailing)
				
			}.frame(height: 50)
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
