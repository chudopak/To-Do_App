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
	var iconName: String
	
	override init() {
		self.name = ""
		self.items = [ChecklistItem]()
		self.iconName = "No Icon"
		super.init()
	}
	
	init(name: String, items: [ChecklistItem]) {
		self.name = name
		self.items = items
		self.iconName = "No Icon"
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
