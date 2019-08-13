//
//  SelectAnkiTemplatesView.swift
//  Memorize
//
//  Created by Riley Williams on 8/13/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct SelectAnkiTemplatesView: View {
	var importer:AnkiImporter
	@State var showingAnswer:Bool = false
	
    var body: some View {
		
		Text("a")
    }
	
	init(deckFile:URL) {
		importer = AnkiImporter(deckFile)
	}
}

#if DEBUG
struct SelectAnkiTemplatesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAnkiTemplatesView(deckFile: Bundle.main.url(forResource: "Ultimate_Geography", withExtension: "zip")!)
    }
}
#endif
