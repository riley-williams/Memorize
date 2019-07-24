//
//  TextFeature.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit
import SwiftUI

class TextFeature: CardFeature, Identifiable {
	var text:String
	
	init(text:String, side:Side) {
		self.text = text
		super.init()
		self.side = side
	}
}
