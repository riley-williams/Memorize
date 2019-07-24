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
	var width:Length
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
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius:height/2) //base
				.frame(width: width, height: height)
				.foregroundColor(.gray)
			
			//			RoundedRectangle(cornerRadius: height/8) //bar shadow
			//				.frame(width:width-progressHighlightOffset*2-progressOffset*2, height: height/4)
			//				.foregroundColor(.black)
			//				.offset(x: progressHighlightOffset+progressOffset, y: height-progressHighlightOffset-progressOffset-height/8)
			
			RoundedRectangle(cornerRadius: (height-progressOffset*2)/2) //bar
				.frame(width: interpolate(progress, a:height-progressOffset*2.0, b:width-progressOffset*2.0), height: height-progressOffset*2)
				.foregroundColor(.green)
				.offset(x: progressOffset, y: progressOffset)
			
			RoundedRectangle(cornerRadius: height/8) //bar highlight
				.frame(width: interpolate(progress, a: height/4, b: width-progressHighlightOffset*2-progressOffset*2), height: height/4)
				.foregroundColor(.white)
				.offset(x: progressHighlightOffset+progressOffset, y: progressHighlightOffset)
		}
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
				ProgressBarView(size:.small, width: 100)
					.frame(width:100)
				
				ProgressBarView(size:.small, width: 100, progress: 0.5)
					.frame(width:100)
				
				ProgressBarView(size:.small, width: 100, progress: 1.0)
					.frame(width:100)
				
			}.previewLayout(.fixed(width: 150, height: 100))
			
			VStack {
				ProgressBarView(size:.regular, width: 100)
					.frame(width:150)
				
				ProgressBarView(size:.regular, width: 150, progress: 0.5)
					.frame(width:150)
				
				ProgressBarView(size:.regular, width: 200, progress: 1.0)
					.frame(width:150)
				
			}.previewLayout(.fixed(width: 250, height: 100))
		}
	}
}
#endif
