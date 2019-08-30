//
//  CreateNewDeckView.swift
//  Memorize
//
//  Created by Riley Williams on 8/28/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct CreateNewDeckView: View {
	@ObservedObject var newDeck:Deck = Deck(name:"")
	@EnvironmentObject var user:User
	@Binding var isPresented:Bool
	
	var body: some View {
		VStack {
			HStack {
				Button("Cancel") {
					self.isPresented = false
				}.padding()
				Spacer()
				Button("Done") {
					self.user.decks.append(self.newDeck)
					self.isPresented = false
					
				}.padding()
			}
			Text("New Deck")
				.font(.title)
				.bold()
			//Top half: icon, name, ...
			HStack(alignment:.top) {
				DeckIcon(deck: newDeck, showsDue: false, showsEditing: .constant(true), width: 120)
					.padding([.leading, .trailing])
				
				TextField("Deck name", text: $newDeck.name)
					.lineLimit(2)
					.border(Color.gray, width: 1)
					.padding(.trailing)
				
			}.padding(.bottom)
			
			//description
			
			TextField("Description", text: $newDeck.description)
				.lineLimit(10)
				.layoutPriority(1)
				.border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
				.padding()
			
			Spacer()
		}
	}
	
}

struct CreateNewDeckView_Previews: PreviewProvider {
	static var previews: some View {
		let user:User = User.testUser(name: "Tester")
		return CreateNewDeckHelperView().environmentObject(user)
	}
}

struct CreateNewDeckHelperView: View {
	@State var isPresented:Bool = false
	@EnvironmentObject var user:User
	
	var body: some View {
		VStack {
			Text("\(self.user.name)")
			
			Divider()
			
			ForEach(self.user.decks) { deck in
				Text("\(deck.name)")
			}
			
			Divider()
			
			Button("Show Add Deck") {
				self.isPresented.toggle()
			}
		}.sheet(isPresented: $isPresented) {
			CreateNewDeckView(isPresented: self.$isPresented).environmentObject(self.user)
		}
	}
	
}
