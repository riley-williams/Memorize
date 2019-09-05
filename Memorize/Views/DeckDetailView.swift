//
//  DeckDetailView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckDetailView: View {
	@EnvironmentObject var user:User
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
							.foregroundColor(.init(UIColor.label))
							.border(Color.gray, width: 1)
							
					} else {
						Text(deck.name)
							.font(.headline)
							.bold()
							.foregroundColor(.init(UIColor.label))
							.lineLimit(2)
					}
					HStack {
						ProgressBarView(size: .regular, progress: deck.mastery, color: .init(UIColor.systemBlue), isRounded: true)
							.frame(width:120)
						Text("\(Int(deck.mastery * 100))%")
							.font(.headline)
							.foregroundColor(.init(UIColor.label))
						Spacer()
					}
				}
				
			}.padding(.bottom)
			
			//description
			if isEditing {
				TextField("Description of \(deck.name)", text: $deck.description)
					.lineLimit(10)
					.foregroundColor(.init(UIColor.label))
					.layoutPriority(1)
					.border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
					.padding()
			} else {
				Text(deck.description)
					.foregroundColor(.init(UIColor.label))
					.lineLimit(10)
					.padding()
			}
			
			
			Spacer()
			
			NavigationLink(destination: StudySessionView(cards: deck.cardsDue)) {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(Color(UIColor.systemBlue))
					Text("Study")
						.font(.headline)
						.foregroundColor(.init(UIColor.label))
						
				}.frame(height:50)
				.padding()
			}
		}.background(Color.init(UIColor.systemBackground))
			.navigationBarTitle(Text(""), displayMode: .large)
			.navigationBarItems(trailing:
				Button(action: {
					withAnimation { self.isEditing.toggle() }
				}, label: {
					Text(isEditing ? "Done" : "Edit").foregroundColor(.init(UIColor.systemBlue))
				})
		).navigationBarBackButtonHidden(self.isEditing)
	}
}


#if DEBUG
struct DeckDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return Group {
			NavigationView {
				DeckDetailView(deck: testUser.decks[2])
			}
			NavigationView {
				DeckDetailView(deck: testUser.decks[2])
					
			}.environment(\.colorScheme, .dark)
		}.environmentObject(testUser)
	}
}

#endif
