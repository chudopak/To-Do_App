//
//  AllChecklistsViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/29/21.
//

import UIKit

class AllChecklistsViewController: UITableViewController, ListDetailViewControllerDelegate, ChecklistViewControllerDelegate {
	

	private var _lists: Array<Checklist>
	
	required init?(coder aDecoder: NSCoder) {
		_lists = [Checklist]()
		super.init(coder: aDecoder)
		loadChecklistItems()
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
		saveChecklistItems()
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
			controller.delegate = self
		} else if (segue.identifier == "AddChecklist") {
			_delegateToListDetailViewController(for: segue)
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
		saveChecklistItems()
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFnishEditing item: Checklist) {
		if let index = _lists.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.textLabel!.text = item.name
			}
		}
		saveChecklistItems()
		dismiss(animated: true, completion: nil)
	}
	
	private func _delegateToListDetailViewController(for segue: UIStoryboardSegue) {
		let navigationController = segue.destination as! UINavigationController
		let controller = navigationController.topViewController as! ListDetailViewController
		controller.delegate = self
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
			let data = try encoder.encode(_lists)
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
				_lists = try decoder.decode([Checklist].self, from: data)
			} catch {
				print("Error decoding item array: \(error.localizedDescription)")
			}
		}
	}
	
	func checklistViewControllerSaveItem() {
		saveChecklistItems()
	}
}
