//
//  Checklist.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/29/21.
//

import UIKit

class Checklist: NSObject {
	var name: String
	
	override init() {
		name = ""
	}
	
	init(name: String) {
		self.name = name
	}
}
