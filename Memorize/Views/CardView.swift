//
//  CardView.swift
//  Memorize
//
//  Created by Riley Williams on 8/3/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CardView: View {
	var card: Card
	@Binding var showingAnswer: Bool
	var visibleFeatures: [TextFeature] {
		get { showingAnswer ? card.features : card.frontFeatures }
	}
	
	var body: some View {
		
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.fill(Color.white)
				.padding()
			RoundedRectangle(cornerRadius: 20)
				.stroke(Color.gray, lineWidth: 3)
				.padding()
			
			VStack {
				ForEach(visibleFeatures) {
					Text($0.text).padding(.all)
						.foregroundColor(.black)
					.layoutPriority(2)
				}
			}
			
		}.onTapGesture {
			self.showingAnswer.toggle()
		}
		
	}
	
}

#if DEBUG
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return CardPresenterView(cards: testUser.decks[0].cardsDue)
    }
}
#endif
