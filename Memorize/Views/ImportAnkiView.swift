//
//  ImportAnkiView.swift
//  Memorize
//
//  Created by Riley Williams on 8/7/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct ImportAnkiView: View {
	@ObservedObject var ankiDeck:AnkiDeck = AnkiDeck()
	
    var body: some View {
		Text("\(ankiDeck.progressDescription)")
    }
}

#if DEBUG
struct ImportAnkiView_Previews: PreviewProvider {
    static var previews: some View {
        ImportAnkiView()
    }
}
#endif
