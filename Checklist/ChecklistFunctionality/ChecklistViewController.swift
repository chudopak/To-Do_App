//
//  ViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/6/21.
//

import UIKit

protocol ChecklistViewControllerDelegate: AnyObject {
	func checklistViewControllerSaveItem()
}

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

	var checklist: Checklist!
	weak var delegate: ChecklistViewControllerDelegate?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = checklist.name
		// Do any additional setup after loading the view.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (checklist.items.count)
	}

	override func tableView(_ tableView:UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
		
		_configureText(cell: cell, with: checklist.items[indexPath.row])
		_configureCheckmark(rowChecked: checklist.items[indexPath.row].checked, cell: cell)
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
		checklist.items[indexPath.row].toggleChecked()
		_configureCheckmark(rowChecked: checklist.items[indexPath.row].checked, cell: cell)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			_rowInteraction(cell: cell, didSelectRowAt: indexPath)
		}
		delegate?.checklistViewControllerSaveItem()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		checklist.items.remove(at: indexPath.row)
		delegate?.checklistViewControllerSaveItem()
		let indexPaths = [indexPath]
		tableView.deleteRows(at: indexPaths, with: .automatic)
	}
	
	func _addItem(item: ChecklistItem) {
		let newRowIndex = checklist.items.count
		checklist.items.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
	}
	
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
		_addItem(item: item)
		delegate?.checklistViewControllerSaveItem()
		dismiss(animated: true, completion: nil)
	}
	
	func itemDetailViewController(_ controllet: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
		if let index = checklist.items.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
			  _configureText(cell: cell, with: item)
			}
		}
		delegate?.checklistViewControllerSaveItem()
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
				controller.itemToEdit = checklist.items[indexPath.row]
			}
		}
	}
}

