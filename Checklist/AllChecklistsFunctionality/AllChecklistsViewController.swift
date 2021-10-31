//
//  AllChecklistsViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/29/21.
//

import UIKit

class AllChecklistsViewController: UITableViewController, ListDetailViewControllerDelegate {

	private var _lists: Array<Checklist>
	
	required init?(coder aDecoder: NSCoder) {
		_lists = [Checklist]()
		super.init(coder: aDecoder)
		_lists.append(Checklist(name: "Test"))
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (_lists.count)
	}

	private func _makeCell(for tableView: UITableView) -> UITableViewCell {
		let cellIdentifier = "Cell"
		if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
			return (cell)
		} else {
			return (UITableViewCell(style: .default, reuseIdentifier: cellIdentifier))
		}
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = _makeCell(for: tableView)
		cell.textLabel!.text = _lists[indexPath.row].name
		cell.accessoryType = .detailDisclosureButton
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let checklist = _lists[indexPath.row]
		performSegue(withIdentifier: "ShowChecklist", sender: checklist)
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		_lists.remove(at: indexPath.row)
		let indexPaths = [indexPath]
		tableView.deleteRows(at: indexPaths, with:.automatic)
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
		let controller = navigationController.topViewController as! ListDetailViewController
		controller.delegate = self
		let checklist = _lists[indexPath.row]
		controller.checklistToEdit = checklist
		present(navigationController, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ShowChecklist") {
			let controller = segue.destination as! ChecklistViewController
			controller.checklist = (sender as! Checklist)
		} else if (segue.identifier == "AddChecklist") {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! ListDetailViewController
			controller.delegate = self
		} else if (segue.identifier == "EditChecklist") {
			let navigationController = segue.destination as! UINavigationController
			let controller = navigationController.topViewController as! ListDetailViewController
			controller.delegate = self
			if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
				controller.checklistToEdit = _lists[indexPath.row]
			}
		}
	}
	
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFnishAdding item: Checklist) {
		let newRowIndex = _lists.count
		_lists.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFnishEditing item: Checklist) {
		if let index = _lists.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.textLabel!.text = item.name
			}
		}
		dismiss(animated: true, completion: nil)
	}
}
