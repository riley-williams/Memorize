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
    @State var barColor:Color = .yellow
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
    private var progressOffset:CGFloat {
        get {
            switch size {
            case .small:
                return 1.5
            case .regular:
                return 2
            }
        }
        
    }
    private var progressHighlightOffset:CGFloat {
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
                //under
                RoundedRectangle(cornerRadius:(self.isRounded ? self.height/2 : 0))
                    .frame(width: geometry.size.width, height: self.height)
                    .foregroundColor(.gray)
                
                //over

                    Rectangle()
                    .frame(width: self.interpolate(self.progress, a:self.height, b:geometry.size.width), height: self.height)
                    .foregroundColor(self.barColor)
                
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
                
                ProgressBarView(size:.regular, progress: 0.5, isRounded: false)
                    .frame(width:150)
                
                ProgressBarView(size:.regular, progress: 1.0, isRounded: false)
                    .frame(width:200)
                
            }.previewLayout(.fixed(width: 250, height: 100))
        }
    }
}
#endif
