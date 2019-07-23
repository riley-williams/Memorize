//
//  DeckDetailView.swift
//  Memorize
//
//  Created by Riley Williams on 7/23/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckDetailView: View {
	var deck:Deck
	
	var body: some View {
		Text(deck.name)
	}
}

#if DEBUG
struct DeckDetailView_Previews: PreviewProvider {
    static var previews: some View {
		let testUser = User.testUser(name: "Riley")
        return DeckDetailView(deck: testUser.decks[0])
    }
}
#endif
