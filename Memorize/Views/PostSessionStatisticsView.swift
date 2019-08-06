//
//  PostSessionStatisticsView.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct PostSessionStatisticsView: View {
	var session:StudySession
	
    var body: some View {
		VStack {
			Text("Time: \(session.time)")
			Text("Cards: \(session.completedCards.count)")
		}
		
    }
}

#if DEBUG
struct PostSessionStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
		let testSession = StudySession.testSession()
		return PostSessionStatisticsView(session: testSession)
    }
}
#endif
