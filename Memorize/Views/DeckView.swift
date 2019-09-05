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
			ContainerView()
				.environmentObject(user.rootContainer)
				.navigationBarItems(trailing: Button(action: {
					self.isShowingAddDecksMini.toggle()
					
				}) {
					Image(systemName: "plus").font(.headline)
				})
		}
		.popover(isPresented: $isShowingAddFromFiles) {
			AnkiImportDebugView().environmentObject(self.user)
		}
		.sheet(isPresented: $isShowingCreateNewDeck) {
			CreateNewDeckView(isPresented: self.$isShowingCreateNewDeck).environmentObject(self.user)
		}
		.actionSheet(isPresented: $isShowingAddDecksMini) {
			ActionSheet(title: Text("New deck"), message: nil, buttons:
				[.default(Text("New Deck"), action:
					{ self.isShowingCreateNewDeck = true }),
				 .default(Text("New Container"), action:
					{ self.user.rootContainer.items.append(Container("New Container")) }),
				 .default(Text("Add from files"), action:
					{ self.isShowingAddFromFiles = true }),
				 .cancel()]
			)
		}
	}
}


#if DEBUG
struct DeckView_Previews: PreviewProvider {
	
	static var previews: some View {
		let user = User.testUser(name: "Riley")
		return Group {
			DeckView()
				.environment(\.colorScheme, .light)
			DeckView()
				.environment(\.colorScheme, .dark)
			
			DeckView()
				.previewDevice("iPad Pro 11")
		}.environmentObject(user)
	}
}
#endif
