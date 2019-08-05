//
//  StudySessionView.swift
//  Memorize
//
//  Created by Riley Williams on 8/5/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct StudySessionView: View {
	@ObservedObject var presenter:CardPresenter
	var body: some View {
		ZStack {
			if presenter.areCardsRemaining {
				CardPresenterView(presenter: presenter)
			} else {
				PostSessionStatisticsView(presenter: presenter)
			}
		}
	}
	
	init(cards:[Card]) {
		self.presenter = CardPresenter(cards)
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
