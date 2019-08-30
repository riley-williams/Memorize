//
//  TestUIView.swift
//  Memorize
//
//  Created by Riley Williams on 8/17/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct TestUIView: View {
	@State var showPopover = false
	@State var showModal = false
	@State var selection:Int?
	
    var body: some View {
		VStack {
			ForEach(1..<5) { i in
				NavigationLink(destination: Text("Destination 1"), tag: i, selection: self.$selection) {
					ZStack {
						Text("Pressable? \(i)")
						Rectangle()
					}
				}
			}
			
			Button("Press me") {
				self.selection = 1
			}
			
			Spacer()
			
		}
    }
}

#if DEBUG
struct TestUIView_Previews: PreviewProvider {
    static var previews: some View {
        TestUIView()
    }
}
#endif
