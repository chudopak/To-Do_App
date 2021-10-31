//
//  ViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/6/21.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
	
	private var _items: Array<ChecklistItem>
	var checklist: Checklist!
	
	required init?(coder aDecoder: NSCoder) {
		_items = [ChecklistItem]()
		super.init(coder: aDecoder)
		loadChecklistItems()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = checklist.name
		// Do any additional setup after loading the view.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (_items.count)
	}

	override func tableView(_ tableView:UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
		
		_configureText(cell: cell, with: _items[indexPath.row])
		_configureCheckmark(rowChecked: _items[indexPath.row].checked, cell: cell)
		return (cell)
	}
	
	private func _configureText(cell: UITableViewCell, with item: ChecklistItem) {
		let label = cell.viewWithTag(1000) as! UILabel

		label.text = item.text
	}
	
	private func _configureCheckmark(rowChecked: Bool, cell: UITableViewCell) {
		let label = cell.viewWithTag(1001) as! UILabel
		
		if (rowChecked == true) {
			label.text = "✔️"
		} else {
			label.text = ""
		}
	}
	
	private func _rowInteraction(cell: UITableViewCell, didSelectRowAt indexPath: IndexPath) {
		_items[indexPath.row].toggleChecked()
		_configureCheckmark(rowChecked: _items[indexPath.row].checked, cell: cell)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			_rowInteraction(cell: cell, didSelectRowAt: indexPath)
		}
		tableView.deselectRow(at: indexPath, animated: true)
		saveChecklistItems()
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		_items.remove(at: indexPath.row)
		let indexPaths = [indexPath]
		tableView.deleteRows(at: indexPaths, with: .automatic)
		saveChecklistItems()
	}
	
	func _addItem(item: ChecklistItem) {
		let newRowIndex = _items.count
		_items.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
	}
	
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
		_addItem(item: item)
		saveChecklistItems()
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controllet: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
		if let index = _items.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
			  _configureText(cell: cell, with: item)
			}
			saveChecklistItems()
		}
		dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	if (segue.identifier == "AddItem") {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! ItemDetailViewController
			controller.delegate = self
		} else if (segue.identifier == "EditItem") {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! ItemDetailViewController
			controller.delegate = self
			if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
				controller.itemToEdit = _items[indexPath.row]
			}
		}
	}
	
	func documentDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return (paths[0])
	}
	
	func dataFilePath() -> URL {
		return (documentDirectory().appendingPathComponent("Checklist.plist"))
	}
	
	func saveChecklistItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(_items)
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
				_items = try decoder.decode([ChecklistItem].self, from: data)
			} catch {
				print("Error decoding item array: \(error.localizedDescription)")
			}
		}
	}
}

