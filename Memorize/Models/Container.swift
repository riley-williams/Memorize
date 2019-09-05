//
//  Container.swift
//  Memorize
//
//  Created by Riley Williams on 9/5/19.
//  Copyright © 2019 Riley Williams. All rights reserved.
//

import UIKit

class Containerizable: Identifiable {
	
}

class Container: Containerizable, ObservableObject {
	@Published var name:String = ""
	@Published var items:[Containerizable] = []
	
	var recursiveCount:Int { get {
		var total = 0
		for item in self.items {
			if let i = item as? Container {
				total += i.recursiveCount
			} else {
				total += 1
			}
		}
		return total
		}
	}
	
	init(_ name:String) {
		self.name = name
	}
	
	func firstN(_ n:Int) -> [Containerizable] {
		var items:[Containerizable] = []
		var count = n
		if self.items.count < n {
			count = self.items.count
		}
		for i in 0..<count {
			items.append(self.items[i])
		}
		return items
	}
	
	
}
