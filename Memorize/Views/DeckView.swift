//
//  DeckView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckView: View {
	@EnvironmentObject var user:User
	@State var isShowingAddDecksMini:Bool = false
	@State var isShowingAddFromFiles:Bool = false
	@State var isShowingCreateNewDeck:Bool = false
	
	var body: some View {
		
		NavigationView {
			ZStack {
				ScrollView {
					ForEach(user.decks) { deck in
						NavigationLink(destination:DeckDetailView(deck: deck)) {
							DeckRow(deck:deck).padding(.horizontal)
						}.buttonStyle(PlainButtonStyle())
					}
					
				}.navigationBarTitle(Text("Decks"))
					.navigationBarItems(trailing: Button(action: {
						self.isShowingAddDecksMini.toggle()
						
					}) {
						Text("Add")
					})
			}
		}
		.popover(isPresented: $isShowingAddFromFiles) {
			AnkiImportDebugView().environmentObject(self.user)
		}
		.sheet(isPresented: $isShowingCreateNewDeck) {
			CreateNewDeckView(isPresented: self.$isShowingCreateNewDeck).environmentObject(self.user)
		}
		.actionSheet(isPresented: $isShowingAddDecksMini) {
			ActionSheet(title: Text("New deck"), message: nil, buttons:
				[.default(Text("Create"), action: { self.isShowingCreateNewDeck = true }),
				 .default(Text("Add from files"), action: { self.isShowingAddFromFiles = true }),
				 .cancel()]
			)
		}
	}
}


struct DeckRow: View {
	@ObservedObject var deck: Deck
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				Rectangle()
					.foregroundColor(.white)
				Rectangle()
					.frame(width:geometry.size.width*CGFloat(self.deck.mastery))
					.foregroundColor(.blue)
			}.cornerRadius(15)
				.shadow(radius: 5)
			
			HStack(alignment: .center) {
				DeckIcon(deck:deck, showsEditing: .constant(false), width: 70)
					.foregroundColor(.black)
					.padding()
				VStack(alignment: .leading, spacing: 0) {
					Text(deck.name)
						.font(.headline)
						.lineLimit(2)
						.foregroundColor(.black)
				}
				Spacer()
			}
		}
	}
}


#if DEBUG
struct DeckView_Previews: PreviewProvider {
	
	static var previews: some View {
		let user = User.testUser(name: "Riley")
		return Group {
			DeckView().environmentObject(user)
			
			DeckRow(deck: user.decks[0])
				.previewLayout(.fixed(width: 300, height: 70))
			
		}
	}
}
#endif
