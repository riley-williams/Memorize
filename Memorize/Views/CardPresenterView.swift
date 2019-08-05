//
//  CardPresenterView.swift
//  Memorize
//
//  Created by Riley Williams on 7/30/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CardPresenterView: View {
	@ObservedObject var presenter:CardPresenter
	@GestureState var dragInProgress:Bool = false
	@State private var offset:CGSize = .zero
	@State var showingAnswer:Bool = false
	@State var dragSufficient:Bool = false
	
	let dismissOffset:CGFloat = 125 //distance from center to swipe answer
	let motionReduction:CGFloat = 0.7 //% reduction in motion after drag completion
	let unansweredReduction:CGFloat = 0.9 //% reduction in motion before answer is shown
	
	var body: some View {
		let drag = DragGesture(minimumDistance:0)
			.onChanged {
				var w = $0.translation.width
				if self.showingAnswer {
					if w < -self.dismissOffset {
						w = w - (w + self.dismissOffset)*self.motionReduction
						self.dragSufficient = true
					} else if w > self.dismissOffset {
						w = w - (w - self.dismissOffset)*self.motionReduction
						self.dragSufficient = true
					} else {
						self.dragSufficient = false
					}
				} else {
					w = w*(1-self.unansweredReduction)
					self.dragSufficient = false
				}
				self.offset = CGSize(width:w, height: 0)
		}
		.onEnded {
			if self.showingAnswer {
				if $0.translation.width < -self.dismissOffset {
					self.updateCard(difficulty: .wrong)
				} else if $0.translation.width > self.dismissOffset {
					self.updateCard(difficulty: .correct)
				}
			}
			self.dragSufficient = false
			self.offset = .zero
		}
		
		
		return VStack {
			ZStack {
				HStack {
					Image(systemName: (dragSufficient ? "checkmark.circle.fill" : "checkmark.circle"))
						.font(.system(size: 100, weight: .bold))
						.foregroundColor(showingAnswer ? (dragSufficient ? .green : .black) : .gray)
						.padding()
					Spacer()
					Image(systemName: (dragSufficient ? "x.circle.fill" : "x.circle"))
						.font(.system(size: 100, weight: .bold))
						.foregroundColor(showingAnswer ? (dragSufficient ? .red : .black) : .gray)
						.padding()
				}
				
				//current card
				CardView(card:presenter.currentCard, showingAnswer: $showingAnswer)
					.offset(x:offset.width)
					.gesture(drag)
					.animation(
						Animation.spring(dampingFraction: 0.5)
							.speed(2))
				
				Spacer()
				
			}.layoutPriority(1)
			
			AnswerView(responder: updateCard(difficulty:), showingAnswer: $showingAnswer)
		}
	}
	
	func updateCard(difficulty:CardStatistics.Difficulty) {
		presenter.updateCurrentCard(difficulty)
		self.showingAnswer = false
		self.dragSufficient = false
	}
}




struct AnswerView: View {
	var responder:(CardStatistics.Difficulty)->()
	@Binding var showingAnswer:Bool
	
	var body: some View {
		VStack {
			HStack {
				
				Image(systemName: "arrow.turn.up.left")
					.font(Font.headline.weight(.bold))
					.foregroundColor(showingAnswer ? .red : .gray)
					.padding(.leading)
				Text("Wrong")
					.font(.headline)
					.foregroundColor(showingAnswer ? .red : .gray)
				
				Spacer()
				
				Text("Correct")
					.font(.headline)
					.foregroundColor(showingAnswer ? .green : .gray)
				Image(systemName: "arrow.turn.up.right")
					.font(Font.headline.weight(.bold))
					.foregroundColor(showingAnswer ? .green : .gray)
					.padding(.trailing)
			}
			
			HStack {
				Button(action: { self.responder(.hard) }) {
					ZStack {
						Rectangle()
							.foregroundColor(showingAnswer ? .orange : .gray)
						Text("Hard")
							.font(.headline)
							.foregroundColor(.white)
					}
				}.disabled(!self.showingAnswer)
					.cornerRadius(15)
					.padding(.leading)
				
				
				
				Button(action: { self.responder(.easy) }) {
					ZStack {
						Rectangle()
							.foregroundColor(showingAnswer ? .blue : .gray)
						Text("Easy")
							.font(.headline)
							.foregroundColor(.white)
					}
				}.disabled(!self.showingAnswer)
					.cornerRadius(15)
					.padding(.trailing)
				
			}.frame(height: 50)
		}
	}
}


#if DEBUG
struct CardPresenterView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		let presenter = CardPresenter(testUser.decks[0].cardsDue)
		return CardPresenterView(presenter: presenter)
	}
}
#endif
