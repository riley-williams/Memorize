//
//  AddDecksView.swift
//  Memorize
//
//  Created by Riley Williams on 8/6/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct AddDecksView: View {
	@EnvironmentObject var user:User
	@State var isShowingCreateDeck = false
	@State var newDeckTitle:String = ""
	@State var isShowingModalPopover = false
	
	var body: some View {
		HStack(alignment:.top) {
			Spacer()
			VStack(alignment:.leading) {
				if !isShowingCreateDeck {
					Group {
						Button(action: {
							withAnimation {
								self.isShowingCreateDeck = true
							}
						}) {
							HStack {
								Image(systemName: "plus.rectangle.on.rectangle")
								Text("Create new")
							}
						}
						Divider()
						NavigationLink(destination:AnkiImportDebugView()) {
							HStack {
								Image(systemName: "folder.badge.plus")
								Text("Add from files")
							}
						}
					}.foregroundColor(.blue)
					
				} else {
					
					Button(action: {
						withAnimation {
							self.isShowingCreateDeck = false
						}
					}) {
						HStack {
							Image(systemName: "chevron.left")
								.font(.headline)
								.foregroundColor(.blue)
							Text("New Deck")
								.font(.headline)
								.foregroundColor(.black)
						}
					}
					
					TextField("Name", text: $newDeckTitle) {
						_ = self.user.newDeck(name: self.newDeckTitle)
						self.isShowingCreateDeck = false
					}
						
					
					Button(action: {
						_ = self.user.newDeck(name: self.newDeckTitle)
						self.isShowingCreateDeck = false
					}) {
						Text("Create")
							.foregroundColor(self.newDeckTitle.count == 0 ? .gray : .blue)
							.padding(.horizontal)
					}.disabled(self.newDeckTitle.count == 0)
					
				}
			}.padding()
				.background(Rectangle().foregroundColor(.white))
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.shadow(radius: 15)
		}.padding()
	}
}

#if DEBUG
struct AddDecksView_Previews: PreviewProvider {
	static var previews: some View {
		AddDecksView().environmentObject(User.testUser(name: "Tester"))
	}
}
#endif
