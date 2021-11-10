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
	
	private var _notFirstStart: Bool {
		get {
			return UserDefaults.standard.bool(forKey: "NotFirstStart")
		} set {
			UserDefaults.standard.set(newValue, forKey: "NotFirstStart")
			UserDefaults.standard.synchronize()
		}
	}

	init() {
		loadChecklistItems()
		registerDefaults()
		handleFirstTime()
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
		sortChecklistByAlphabet()
	}

	func registerDefaults() {
		if (lists.count <= indexOfSelectedRow) {
			indexOfSelectedRow = -1
		}
		if (UserDefaults.standard.integer(forKey: "ChecklistItemID") == 0) {
			UserDefaults.standard.set(0, forKey: "ChecklistItemID")
		}
	}
	
	func handleFirstTime() {
		if (lists.count != 0) {
			_notFirstStart = true
		}
		else if (_notFirstStart == false) {
			let startChecklistItem = [ChecklistItem(text: "Example Item", checked: false)]
			let startChecklist = Checklist(name: "Example Checklist", items: startChecklistItem)
			lists.append(startChecklist)
			
			indexOfSelectedRow = 0
			_notFirstStart = true
		}
	}
	
	func sortChecklistByAlphabet() {
		lists.sort(by: {list1, list2 in
					return list1.name.caseInsensitiveCompare(list2.name) == .orderedAscending})
	}
	
	class func nextChecklistItemID() -> Int {
		let userDefaults = UserDefaults.standard
		let itemID = userDefaults.integer(forKey: "ChecklistItemID")
		userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
		userDefaults.synchronize()
		return (itemID)
	}
}
