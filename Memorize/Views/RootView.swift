//
//  RootView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct RootView: View {
	var user:User
	@State private var selection = 0
	
	var body: some View {
		TabbedView(selection: $selection) {
			DeckView(user: user)
				.tabItem {
					Image(systemName:"rectangle.stack")
					Text("Decks")
			}.tag(0)
			
			Text("Performance Information")
				.tabItem {
					Image(systemName:"gauge")
					Text("Stats")
			}.tag(1)
		}
		
	}
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Riley")
		return RootView(user: testUser)
	}
}
#endif
