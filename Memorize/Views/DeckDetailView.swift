//
//  DeckDetailView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckDetailView: View {
	@ObservedObject var deck:Deck
	@State var isEditing:Bool = false
	
	var body: some View {
		VStack {
			//Top half: icon, name, ...
			HStack(alignment:.top) {
				DeckIcon(deck: deck, showsDue: false, showsEditing: $isEditing, width: 120)
					.padding([.leading, .trailing])
				
				VStack(alignment: .leading, spacing: 10) {
					if isEditing {
						TextField("Deck name", text: $deck.name)
							.lineLimit(2)
							.border(Color.gray, width: 1)
							.padding(.trailing)
					} else {
						Text(deck.name)
							.font(.headline)
							.bold()
							.lineLimit(2)
					}
					HStack {
						ProgressBarView(size: .regular, progress: deck.mastery, color: .blue, isRounded: true)
						Text("\(Int(deck.mastery * 100))%")
							.font(.headline)
						Spacer()
					}
				}
				
			}.padding(.bottom)
			
			//description
			if isEditing {
				TextField("Description of \(deck.name)", text: $deck.description)
					.lineLimit(10)
					.layoutPriority(1)
					.border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
					.padding()
			} else {
				Text(deck.description)
					.lineLimit(10)
					.padding()
			}
			
			
			Spacer()
			
			NavigationLink(destination: StudySessionView(cards: deck.cardsDue)) {
				Text("Study")
					.font(.headline)
				.padding()
			}
		}
		.navigationBarTitle(Text(""), displayMode: .large)
		.navigationBarItems(trailing:
			Button(action: {
				withAnimation { self.isEditing.toggle() }
			}, label: {
				Text(isEditing ? "Done" : "Edit")
			})
		).navigationBarBackButtonHidden(self.isEditing)
	}
}


#if DEBUG
struct DeckDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return NavigationView {
			DeckDetailView(deck: testUser.decks[2]).environmentObject(testUser)
		}
	}
}
#endif
