//
//  Checklist.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/29/21.
//

import UIKit

class Checklist: NSObject, Codable {
	var name: String
	var items: Array<ChecklistItem>
	
	override init() {
		self.name = ""
		self.items = [ChecklistItem]()
		super.init()
	}
	
	init(name: String, items: [ChecklistItem]) {
		self.name = name
		self.items = items
	}
	
	func countUncheckedItems() -> Int {
		var count = 0
		for item in items {
			if (item.checked == false) {
				count += 1
			}
		}
		return (count)
	}
}
