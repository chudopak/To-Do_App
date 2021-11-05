//
//  DataModel.swift
//  Checklist
//
//  Created by Stepan Kirillov on 11/3/21.
//

import Foundation

class DataModel {
	var lists = [Checklist]()
	var indexOfSelectedRow: Int {
		get {
			return UserDefaults.standard.integer(forKey: "ChecklistItem")
		} set (rowNumber) {
			UserDefaults.standard.set(rowNumber, forKey: "ChecklistItem")
			UserDefaults.standard.synchronize()
		}
	}

	init() {
		loadChecklistItems()
		registerDefaults()
	}
	
	func documentDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return (paths[0])
	}
	
	func dataFilePath() -> URL {
		return (documentDirectory().appendingPathComponent("Checklists.plist"))
	}
	
	func saveChecklistItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(lists)
			try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
		} catch {
			print("Error encoding item array: \(error.localizedDescription)")
		}
	}
	
	func loadChecklistItems() {
		let path = dataFilePath()
		if let data = try? Data(contentsOf: path) {
			let decoder = PropertyListDecoder()
			do {
				lists = try decoder.decode([Checklist].self, from: data)
			} catch {
				print("Error decoding item array: \(error.localizedDescription)")
			}
		}
	}

	func registerDefaults() {
		if (lists.count <= indexOfSelectedRow) {
			indexOfSelectedRow = -1
		}
	}
}
