//
//  StudySessionView.swift
//  Memorize
//
//  Created by Riley Williams on 8/5/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct StudySessionView: View {
	@ObservedObject var session:StudySession
	var body: some View {
		ZStack {
			if session.areCardsRemaining {
				CardPresenterView(session: session)
			} else {
				PostSessionStatisticsView(session: session)
			}
		}
	}
	
	init(cards:[Card]) {
		self.session = StudySession(cards)
		session.start()
	}
}

#if DEBUG
struct StudySessionView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Tester")
		return StudySessionView(cards: testUser.decks[2].cardsDue)
	}
}
#endif
