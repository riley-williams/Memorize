//
//  CardPresenterView.swift
//  Memorize
//
//  Created by Riley Williams on 7/30/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CardPresenterView: View {
	@ObservedObject var session:StudySession
	@GestureState var dragInProgress:Bool = false
	@State private var offset:CGSize = .zero
	@State var showingAnswer:Bool = false
	@State var dragSufficient:Bool = false
	
	
	let dismissOffset:CGFloat = 115			//distance from center to swipe answer
	let motionReduction:CGFloat = 0.7		//% reduction in motion after drag completion
	let unansweredReduction:CGFloat = 0.9	//% reduction in motion before answer is shown
	let finalMarkOpacity:Double = 0.9		//maximum X and check mark opacity
	
	
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
				
				
				//current card
				CardView(card:session.currentCard, showingAnswer: $showingAnswer)
				.overlay(
					VStack {
						HStack{
							Image(systemName: (dragSufficient ? "checkmark.circle.fill" : "checkmark.circle"))
								.font(.system(size: 100, weight: .bold))
								.foregroundColor(.green)
								.opacity(mapClamp(Double(self.offset.width), a1: 0, a2: Double(dismissOffset), b1: 0, b2: finalMarkOpacity))
								.padding()
							Spacer()
							Image(systemName: (dragSufficient ? "x.circle.fill" : "x.circle"))
								.font(.system(size: 100, weight: .bold))
								.foregroundColor(.red)
								.opacity(mapClamp(Double(-self.offset.width), a1: 0, a2: Double(dismissOffset), b1: 0, b2: finalMarkOpacity))
								.padding()
						}.padding()
						Spacer()
					}).padding()
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
	
	func mapClamp(_ x:Double, a1:Double, a2:Double, b1:Double, b2:Double) -> Double {
		if x < a1 {
			return b1
		}
		if x > a2 {
			return b2
		}
		return b1 + (x-a1)/(a2-a1)*(b2-b1)
	}
	
	func updateCard(difficulty:CardStatistics.Difficulty) {
		session.updateCurrentCard(difficulty)
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
		let session = StudySession(testUser.decks[0].cardsDue)
		return CardPresenterView(session: session)
	}
}
#endif
