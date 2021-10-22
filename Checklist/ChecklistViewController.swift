//
//  ViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/6/21.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
	
	private var _items: Array<ChecklistItem>
	
	required init?(coder aDecoder: NSCoder) {
		_items = [ChecklistItem]()
		
		_items.append(ChecklistItem(text: "Walk the dog", checked: true))
		_items.append(ChecklistItem(text: "Brush my teeth", checked: false))
		_items.append(ChecklistItem(text: "Learn iOS development", checked: false))
		_items.append(ChecklistItem(text: "Soccer practice", checked: false))
		_items.append(ChecklistItem(text: "Eat ice cream", checked: false))

		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (_items.count)
	}

	override func tableView(_ tableView:UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
		
		let label = cell.viewWithTag(1000) as! UILabel

		label.text = _items[indexPath.row].text
		_isChecked(rowChecked: _items[indexPath.row].checked, cell: cell)
		return (cell)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "AddItem") {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! AddItemViewController
			controller.delegate = self
		}
	}
	
	private func _isChecked(rowChecked: Bool, cell: UITableViewCell) {
		if (rowChecked == true) {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
	}
	
	private func _rowInteraction(cell: UITableViewCell, didSelectRowAt indexPath: IndexPath) {
		_items[indexPath.row].toggleChecked()
		_isChecked(rowChecked: _items[indexPath.row].checked, cell: cell)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			_rowInteraction(cell: cell, didSelectRowAt: indexPath)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
	  _items.remove(at: indexPath.row)
	  let indexPaths = [indexPath]
	  tableView.deleteRows(at: indexPaths, with: .automatic)
	}
	
	func _addItem(item: ChecklistItem) {
		let newRowIndex = _items.count
		_items.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
	}
	
	func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
		dismiss(animated: true, completion: nil)
//		print("Cancel")
	}
	
	func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
		_addItem(item: item)
		dismiss(animated: true, completion: nil)
//		print("done")
	}
	
}

