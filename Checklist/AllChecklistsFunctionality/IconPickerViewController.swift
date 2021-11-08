//
//  IconPickerViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 11/8/21.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
	func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {

	weak var delegate: IconPickerViewControllerDelegate?
	let icons = [
		"No Icon",
		"Appointments",
		"Birthdays",
		"Chores",
		"Drinks",
		"Folder",
		"Groceries",
		"Inbox",
		"Photos",
		"Trips" ]
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (icons.count)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
		let iconName = icons[indexPath.row]
		
		cell.textLabel!.text = iconName
		cell.imageView!.image = UIImage(named: iconName)
		return (cell)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let delegateTo = delegate {
			delegateTo.iconPicker(self, didPick: icons[indexPath.row])
		}
	}
}
