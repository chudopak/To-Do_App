//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/9/21.
//

import Foundation

class ChecklistItem: NSObject, Codable {
	var text: String
	var checked: Bool
	
	var dueDate = Date()
	var shouldRemind = false
	var itemID: Int

	override init() {
		text = ""
		checked = false
	}
	init(text: String, checked: Bool) {
		self.text = text
		self.checked = checked
	}
	
	func toggleChecked () {
		checked = !checked
	}
}

