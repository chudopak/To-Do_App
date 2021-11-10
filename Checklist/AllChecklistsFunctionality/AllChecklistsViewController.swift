//
//  AllChecklistsViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/29/21.
//

import UIKit

class AllChecklistsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

	var dataModel: DataModel!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.delegate = self
		let index = dataModel.indexOfSelectedRow
		if (index >= 0 && index < dataModel.lists.count) {
			let checklist = dataModel.lists[index]
			performSegue(withIdentifier: "ShowChecklist", sender: checklist)
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (dataModel.lists.count)
	}
	
	private func _getDetailTextLabel(index: Int) -> String {
		let count = dataModel.lists[index].countUncheckedItems()
		if (dataModel.lists[index].items.count == 0) {
			return ("(No Items)")
		} else if (count == 0) {
			return ("All Done!")
		}
		return ("\(count) remain")
	}

	private func _makeCell(for tableView: UITableView) -> UITableViewCell {
		let cellIdentifier = "Cell"
		if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
			return (cell)
		} else {
			return (UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier))
		}
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = _makeCell(for: tableView)
		cell.textLabel!.text = dataModel.lists[indexPath.row].name
		cell.detailTextLabel!.text = _getDetailTextLabel(index: indexPath.row)
		cell.textLabel!.font = UIFont.systemFont(ofSize: 18.0)
		cell.imageView!.image = UIImage(named: dataModel.lists[indexPath.row].iconName)
		cell.accessoryType = .detailDisclosureButton
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dataModel.indexOfSelectedRow = indexPath.row
		let checklist = dataModel.lists[indexPath.row]
		performSegue(withIdentifier: "ShowChecklist", sender: checklist)
	}
	
	private func _removeNotificationFromChecklistItems(for index: Int) {
		for item in dataModel.lists[index].items {
			item.removeNotification()
		}
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		_removeNotificationFromChecklistItems(for: indexPath.row)
		dataModel.lists.remove(at: indexPath.row)
		let indexPaths = [indexPath]
		tableView.deleteRows(at: indexPaths, with:.automatic)
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
		let controller = navigationController.topViewController as! ListDetailViewController
		controller.delegate = self
		let checklist = dataModel.lists[indexPath.row]
		controller.checklistToEdit = checklist
		present(navigationController, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "ShowChecklist") {
			let controller = segue.destination as! ChecklistViewController
			controller.checklist = (sender as! Checklist)
		} else if (segue.identifier == "AddChecklist") {
			_delegateToListDetailViewController(for: segue)
		}
	}
	
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFnishAdding item: Checklist) {
		let newRowIndex = dataModel.lists.count
		dataModel.lists.append(item)
		let indexPath = IndexPath(row: newRowIndex, section: 0)
		let indexPaths = [indexPath]
		tableView.insertRows(at: indexPaths, with: .automatic)
		dataModel.sortChecklistByAlphabet()
		tableView.reloadData()
		dismiss(animated: true, completion: nil)
	}
	
	func listDetailViewController(_ controller: ListDetailViewController, didFnishEditing item: Checklist) {
		if let index = dataModel.lists.firstIndex(of: item) {
			let indexPath = IndexPath(row: index, section: 0)
			if let cell = tableView.cellForRow(at: indexPath) {
				cell.textLabel!.text = item.name
			}
		}
		dataModel.sortChecklistByAlphabet()
		tableView.reloadData()
		dismiss(animated: true, completion: nil)
	}
	
	private func _delegateToListDetailViewController(for segue: UIStoryboardSegue) {
		let navigationController = segue.destination as! UINavigationController
		let controller = navigationController.topViewController as! ListDetailViewController
		controller.delegate = self
	}
	
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if (viewController === self) {
			dataModel.indexOfSelectedRow = -1
		}
	}
}
