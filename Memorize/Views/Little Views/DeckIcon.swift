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
	var width:CGFloat = 70
	private var radius:CGFloat { get { 10.0*(width/70.0) } }
	private var separation:CGFloat { get { 2.0*(width/70.0) } }
	private var offset:CGFloat { get { 3 + width/70 } }
	private var height:CGFloat { get { width*5.0/7.0 } }
	
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
				.frame(width: width*2, height: height*2)
				.drawingGroup(opaque: true) //fill background of transparent images
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(radius - separation)
                .overlay(RoundedRectangle(cornerRadius: radius - separation).stroke(Color.white, lineWidth: 2.0))
                
				.offset(x: offset, y: -offset)
                .shadow(radius: 2.0)
			Image(uiImage:deck.icon)
				.resizable()
				.scaledToFill()
				.frame(width: width, height: height)
				.drawingGroup(opaque: true) //fill background of transparent images
				.cornerRadius(radius - separation)
                .overlay(RoundedRectangle(cornerRadius: radius - separation).stroke(Color.white, lineWidth: 2.0))
                .shadow(radius: 3.0)
                
			if deck.numCardsDue > 0 && showsDue {
				Text("\(deck.numCardsDue)")
					.foregroundColor(.white)
					.padding(.vertical, 0)
                    .padding(.horizontal, 5)
					.background(
                        RoundedRectangle(cornerRadius: 20.0)
							.foregroundColor(.red)
							.frame(minWidth:22))
					.shadow(radius: 4)
                    .offset(x: width/2.0 + 4.0, y: -height/2.0-4.0)
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
				.previewLayout(.fixed(width: 200, height: 200))
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
