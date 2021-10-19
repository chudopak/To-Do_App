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

struct RowData {
	var row0 = ChecklistItem(text: "Walk the dog", checked: true)
	var row1 = ChecklistItem(text: "Brush my teeth", checked: false)
	var row2 = ChecklistItem(text: "Learn iOS development", checked: true)
	var row3 = ChecklistItem(text: "Soccer practice", checked: false)
	var row4 = ChecklistItem(text: "Eat ice cream", checked: false)
}


