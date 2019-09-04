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
    @State var color:Color = .yellow
    @State var isRounded:Bool = true
    
    private var height:CGFloat {
        get {
            switch size {
            case .small:
                return 10
            case .regular:
                return 15
            }
        }
        
    }

    var body: some View {
        return GeometryReader { geometry in
            
            ZStack(alignment: .topLeading) {
                //under
                RoundedRectangle(cornerRadius:(self.isRounded ? self.height/2 : 0))
                    .frame(width: geometry.size.width, height: self.height)
                    .foregroundColor(.init(UIColor.secondarySystemFill))
                
                //over

                    Rectangle()
                    .frame(width: self.interpolate(self.progress, a:self.height, b:geometry.size.width), height: self.height)
                    .foregroundColor(self.color)
                
            }
            .frame(height:self.height)
            .cornerRadius(self.isRounded ? self.height / 2 : 0)
            
        }.frame(height:self.height)
            .accessibility(label: Text("\(progress)% complete"))
    }
    
    private func interpolate(_ percent:Float, a:CGFloat, b:CGFloat) -> CGFloat {
        return a + (b-a)*CGFloat(percent)
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
            
            VStack {
                ProgressBarView(size:.regular, isRounded: false)
                    .frame(width:100)
                
				ProgressBarView(size:.regular, progress: 0.5, color: .init(UIColor.systemBlue), isRounded: true)
                    .frame(width:150)
                
                ProgressBarView(size:.regular, progress: 1.0, color: .init(UIColor.systemRed), isRounded: false)
                    .frame(width:200)
                
			}.background(Rectangle().foregroundColor(.init(UIColor.systemBackground)))
			.previewLayout(.fixed(width: 250, height: 100))
				.environment(\.colorScheme, .dark)
        }
    }
}
#endif
