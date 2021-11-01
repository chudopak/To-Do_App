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
		name = ""
		items = [ChecklistItem]()
	}
	
	init(name: String, items: [ChecklistItem]) {
		self.name = name
		self.items = items
	}
}
