//
//  ItemDetailViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/20/21.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
	func itemDetailViewController(_ controllet: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

	weak var delegate: ItemDetailViewControllerDelegate?
	var itemToEdit: ChecklistItem?
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let item = itemToEdit {
			title = "Edit Item"
			textField.text = item.text
			doneBarButton.isEnabled = true
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}

	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return (nil)
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText = textField.text! as NSString
		let newText = oldText.replacingCharacters(in: range, with: string)
		doneBarButton.isEnabled = (newText.count > 0)
		return (true)
	}

	@IBAction func cancel() {
		delegate?.itemDetailViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		if let item = itemToEdit {
			item.text = textField.text!
			delegate?.itemDetailViewController(self, didFinishEditing: item)
		} else {
			let item = ChecklistItem()
			item.text = textField.text!
			item.checked = false
			delegate?.itemDetailViewController(self, didFinishAdding: item)
		}
	}
}
