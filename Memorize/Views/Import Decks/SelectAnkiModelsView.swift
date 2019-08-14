//
//  SelectAnkiModelsView.swift
//  Memorize
//
//  Created by Riley Williams on 8/14/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct SelectAnkiModelsView: View {
	@ObservedObject var importer:AnkiImporter
	var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
	
	init(deckFile:URL) {
		importer = AnkiImporter(deckFile)
	}
}

#if DEBUG
struct SelectAnkiModelsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAnkiModelsView(deckFile: Bundle.main.url(forResource: "Ultimate_Geography", withExtension: "zip")!)
    }
}
#endif
