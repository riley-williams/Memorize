//
//  PostSessionStatisticsView.swift
//  Memorize
//
//  Created by Riley Williams on 8/4/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct PostSessionStatisticsView: View {
	var presenter:CardPresenter
	
    var body: some View {
        Text("Post Session Statistics View")
    }
}

#if DEBUG
struct PostSessionStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
		let testPresenter = CardPresenter.testPresenter()
        
		return PostSessionStatisticsView(presenter: testPresenter)
    }
}
#endif
