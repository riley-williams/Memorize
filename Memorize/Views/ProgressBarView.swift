//
//  ProgressBarView.swift
//  Memorize
//
//  Created by Riley Williams on 7/24/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import SwiftUI

enum ProgressBarViewSize {
	case small
	case regular
}

struct ProgressBarView: View {
	var size:ProgressBarViewSize = .regular
	@State var progress:Float = 0.0
	
	private var height:Length {
		get {
			switch size {
				case .small:
					return 10
				case .regular:
					return 15
			}
		}
		
	}
	private var progressOffset:Length {
		get {
			switch size {
				case .small:
					return 1.5
				case .regular:
					return 2
			}
		}
		
	}
	private var progressHighlightOffset:Length {
		get {
			switch size {
				case .small:
					return 2
				case .regular:
					return 3
			}
		}
		
	}
	
	var body: some View {
		return GeometryReader { geometry in
			
			ZStack(alignment: .topLeading) {
				RoundedRectangle(cornerRadius:self.height/2) //base
					.frame(width: geometry.size.width, height: self.height)
					.foregroundColor(.gray)
				
				RoundedRectangle(cornerRadius: (self.height-self.progressOffset*2)/2) //bar
					.frame(width: self.interpolate(self.progress, a:self.height-self.progressOffset*2.0, b:geometry.size.width-self.progressOffset*2.0), height: self.height-self.progressOffset*2)
					.foregroundColor(.green)
					.offset(x: self.progressOffset, y: self.progressOffset)
				
				RoundedRectangle(cornerRadius: self.height/8) //bar highlight
					.frame(width: self.interpolate(self.progress, a: self.height/4, b: geometry.size.width-self.progressHighlightOffset*2-self.progressOffset*2), height: self.height/4)
					.foregroundColor(.white)
					.offset(x: self.progressHighlightOffset+self.progressOffset, y: self.progressHighlightOffset)
			}.frame(height:self.height)
		}.frame(height:self.height)
			.accessibility(label: Text("\(progress)% complete"))
	}
	
	private func interpolate(_ percent:Float, a:Length, b:Length) -> Length {
		return a + (b-a)*Length(percent)
	}
}

#if DEBUG
struct ProgressBarView_Previews: PreviewProvider {
	static var previews: some View {
		return Group {
			VStack {
				ProgressBarView(size:.small)
					.frame(width:100.0)
				
				ProgressBarView(size:.small, progress: 0.5)
					.frame(width:100.0)
				
				ProgressBarView(size:.small, progress: 1.0)
					.frame(width:100.0)
				
			}.previewLayout(.fixed(width: 150, height: 100))
			
			VStack {
				ProgressBarView(size:.regular)
					.frame(width:100)
				
				ProgressBarView(size:.regular, progress: 0.5)
					.frame(width:150)
				
				ProgressBarView(size:.regular, progress: 1.0)
					.frame(width:200)
				
			}.previewLayout(.fixed(width: 250, height: 100))
		}
	}
}
#endif
