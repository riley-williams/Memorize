//
//  DeckIcon.swift
//  Memorize
//
//  Created by Riley Williams on 7/24/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

struct DeckIcon: View {
	var deck:Deck
	@State var showsDue:Bool = true
	var width:Length = 70
	private var radius:Length { get { 10.0*(width/70.0) } }
	private var separation:Length { get { 2.0*(width/70.0) } }
	private var offset:Length { get { 3 + width/70 } }
	private var height:Length { get { width*5.0/7.0 } }
	
	var body: some View {
		ZStack {
			//			RoundedRectangle(cornerRadius: radius)
			//				.frame(width: width, height: width*5.0/7.0, alignment: .center)
			//				.foregroundColor(.white)
			//				.offset(x: offset, y: -offset)
			//				.shadow(radius: 2)
			
			Image(uiImage:deck.icon)
				.resizable()
				.scaledToFill()
				.relativeSize(width: 2, height: 2)
				.frame(width: width, height: height)
				.drawingGroup(opaque: true) //fill background of transparent images
				.clipShape(RoundedRectangle(cornerRadius: radius - separation))
				.overlay(RoundedRectangle(cornerRadius: radius - separation).stroke(Color.white, lineWidth: 2))
				.offset(x: offset, y: -offset)
				.shadow(radius: 2)
			Image(uiImage:deck.icon)
				.resizable()
				.scaledToFill()
				.frame(width: width, height: height)
				.drawingGroup(opaque: true) //fill background of transparent images
				.clipShape(RoundedRectangle(cornerRadius: radius - separation))
				.overlay(RoundedRectangle(cornerRadius: radius - separation).stroke(Color.white, lineWidth: 2))
				.shadow(radius: 3)
			if deck.numCardsDue > 0 && showsDue {
				Text("\(deck.numCardsDue)")
					.foregroundColor(.white)
					.padding(.vertical, 0)
					.padding(.horizontal, 5)
					.background(
						RoundedRectangle(cornerRadius: 20)
							.foregroundColor(.red)
							.frame(minWidth:22))
					.shadow(radius: 4)
					.offset(x: width/2 + 4, y: -height/2-4)
			}
		}
	}
}

#if DEBUG
struct DeckIcon_Previews: PreviewProvider {
	static var previews: some View {
		let user = User.testUser(name: "Riley")
		return Group {
			DeckIcon(deck:user.decks[0], showsDue: false)
				.previewLayout(.fixed(width: 100, height: 100))
			DeckIcon(deck:user.decks[4], width: 70)
				.previewLayout(.fixed(width: 100, height: 100))
			DeckIcon(deck:user.decks[1], showsDue: false, width: 119)
				.previewLayout(.fixed(width: 200, height: 150))
			DeckIcon(deck:user.decks[3], width: 119)
				.previewLayout(.fixed(width: 200, height: 150))
		}
	}
}
#endif
