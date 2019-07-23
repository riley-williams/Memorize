//
//  CardView.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CardView: View {
	var card: Card
	var currentSide: Side = .front
	
	var body: some View {
		if currentSide == .front {
			return VStack {
				ForEach(card.frontFeatures) {
					Text($0.text).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
				}
			}
		} else {
			return VStack {
				ForEach(card.features) {
					Text($0.text).padding(.all)
				}
			}
		}
		
	}
	
	init(_ card:Card) {
		self.card = card
	}
}


#if DEBUG
struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		
		let frontText = TextFeature(text: "Question", side: .front)
		let backText = TextFeature(text: "Answer", side: .back)
		let testCard = Card(features: [frontText, backText])
		
		var view = CardView(testCard)
		view.currentSide = .back
		
		return view
	}
}
#endif
