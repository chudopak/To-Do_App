//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/9/21.
//

import Foundation

struct ChecklistItem {
	var text: String
	var checked: Bool

	init() {
		text = ""
		checked = false
	}
	init(text: String, checked: Bool) {
		self.text = text
		self.checked = checked
	}
	
	mutating func toggleChecked () {
		checked = !checked
	}
}

