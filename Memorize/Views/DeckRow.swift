//
//  DeckRow.swift
//  Memorize
//
//  Created by Riley Williams on 9/2/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckRow: View {
	@ObservedObject var deck: Deck
	@EnvironmentObject var user: User
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				Rectangle()
					.foregroundColor(.init(UIColor.tertiarySystemBackground))
				Rectangle()
					.frame(width:geometry.size.width*CGFloat(self.deck.mastery), height: geometry.size.height)
					.foregroundColor(.init(UIColor.systemBlue))
				
			}.cornerRadius(15)
				.shadow(radius: 5)
			
			HStack(alignment: .center) {
				DeckIcon(deck:deck, showsEditing: .constant(false), width: 70)
					.padding()
				VStack(alignment: .leading, spacing: 0) {
					Text(deck.name)
						.font(.headline)
						.lineLimit(2)
						.foregroundColor(.init(UIColor.label))
				}
				Spacer()
			}
		}
	}
}

struct DeckRow_Previews: PreviewProvider {
	static var previews: some View {
		let user = User.testUser(name: "Riley")
		return Group {
			DeckView()
			DeckView()
				.colorScheme(.dark)
		}
		.environmentObject(user)
	}
}
