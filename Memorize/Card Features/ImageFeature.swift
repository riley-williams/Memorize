//
//  ImageFeature.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

class ImageFeature: CardFeature {
	var image:UIImage
	
	init(image:UIImage, side:Side) {
		self.image = image
		super.init()
		self.side = side
	}
}
