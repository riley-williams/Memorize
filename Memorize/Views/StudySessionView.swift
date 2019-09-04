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
		}.background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
	}
	
	func onAppear() -> some View
	{
		session.start()
		return self
	}
	
	init(cards:[Card]) {
		self.session = StudySession(cards)
	}
}

#if DEBUG
struct StudySessionView_Previews: PreviewProvider {
	static var previews: some View {
		let testUser = User.testUser(name: "Tester")
		return Group {
			StudySessionView(cards: testUser.decks[2].cardsDue)
			StudySessionView(cards: testUser.decks[2].cardsDue)
				.environment(\.colorScheme, .dark)
		}.environmentObject(testUser)
	}
}
#endif
