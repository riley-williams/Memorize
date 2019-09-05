//
//  ContainerView.swift
//  Memorize
//
//  Created by Riley Williams on 9/5/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct ContainerView: View {
	@EnvironmentObject var container:Container
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing:10) {
				ForEach(container.items) { item in
					
					if item is Deck {
						NavigationLink(destination:DeckDetailView(deck: item as! Deck)) {
							DeckRow(deck:item as! Deck)
						}
					} else if item is Container {
						NavigationLink(destination: ContainerView()
							.environmentObject(item as! Container)) {
								ContainerRow(container: item as! Container)
						}
					}
				}.buttonStyle(PlainButtonStyle())
					.padding(.horizontal)
			}
		}.navigationBarTitle(Text(container.name))
	}
}


struct ContainerView_Previews: PreviewProvider {
	static var previews: some View {
		let user = User.testUser(name: "Test")
		
		return Group {
			NavigationView {
				ContainerView()
			}
			NavigationView {
				ContainerView()
			}.environment(\.colorScheme, .dark)
		}
		.environmentObject(user)
		.environmentObject(user.rootContainer)
	}
}

struct ContainerRow: View {
	var container:Container
	@State var isOpened:Bool = false
	var body: some View {
		ZStack {
			//background
			RoundedRectangle(cornerRadius: 15).foregroundColor(Color(UIColor.secondarySystemBackground))
			
			HStack(spacing:20) {
				ContainerIcon(container: container)
				VStack(alignment: .leading) {
					Text(container.name)
						.lineLimit(1)
						.font(.headline)
					Text("\(container.recursiveCount) decks")
						.font(.subheadline)
				}
				Spacer()
			}.padding()
			
		}
	}
}

struct ContainerIcon: View {
	var container:Container
	
	private let shadowRadius:CGFloat = 3
	private let iconWidth:CGFloat = 60
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.foregroundColor(.clear)
				.frame(width:70, height: 50)
			if container.items.count >= 3 {
				DeckIcon(deck: container.items[0] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
					.offset(x: 5, y: 5)
				DeckIcon(deck: container.items[1] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
				DeckIcon(deck: container.items[2] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
					.offset(x: -5, y: -5)
			} else if container.items.count == 2 {
				DeckIcon(deck: container.items[0] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
					.offset(x: 2.5, y: 2.5)
				DeckIcon(deck: container.items[1] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
					.offset(x: -2.5, y: -2.5)
			} else if container.items.count == 1 {
				DeckIcon(deck: container.items[0] as! Deck, showsDue: false, showsEditing: .constant(false), width: iconWidth)
					.shadow(radius: shadowRadius)
			} else {
				RoundedRectangle(cornerRadius: 8)
					.foregroundColor(Color(UIColor.tertiarySystemBackground))
					.frame(width:70, height: 50)
			}
		}
	}
}

