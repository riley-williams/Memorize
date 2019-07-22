//
//  ImageFeature.swift
//  Memorize
//
//  Created by Riley Williams on 7/22/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

class ImageFeature {
	var image:UIImage
	var showOn:Side
	
	init(image:UIImage, showOn:Side) {
		self.image = image
		self.showOn = showOn
	}
}
