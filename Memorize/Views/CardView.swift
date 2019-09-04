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
				.fill(Color(UIColor.secondarySystemBackground))
			RoundedRectangle(cornerRadius: 20)
				.stroke(Color(UIColor.systemFill), lineWidth: 3)
			
			VStack {
				ForEach(visibleFeatures) {
					Text($0.text).padding(.all)
						.foregroundColor(.init(UIColor.label))
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
		return Group {
			CardView(card:testUser.decks[0].cards[0], showingAnswer: .constant(false)).padding()
			CardView(card:testUser.decks[0].cards[0], showingAnswer: .constant(true)).padding()
				.environment(\.colorScheme, .dark)
		}.background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
    }
}
#endif
