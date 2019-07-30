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
	@State var showingAnswer: Bool = false
	var visibleFeatures: [TextFeature] {
		get { showingAnswer ? card.features : card.frontFeatures }
	}
	
	var body: some View {
		
		ZStack {
			Rectangle()
				.foregroundColor(.white)
				.border(Color.gray, width: 4, cornerRadius: 20)
				.padding(5)
			
			VStack {
				ForEach(visibleFeatures) {
					Text($0.text).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
				}
			}
		}.tapAction {
						self.showingAnswer = !self.showingAnswer
					}
	}

}


#if DEBUG
struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		
		let frontText = TextFeature(text: "Question", side: .front)
		let backText = TextFeature(text: "Answer", side: .back)
		let testCard = Card(features: [frontText, backText])
		
		return Group {
			CardView(card: testCard)
			
			CardView(card: testCard, showingAnswer: true)
		}
	}
}
#endif
