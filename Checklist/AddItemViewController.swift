//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/20/21.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
	func addItemViewControllerDidCancel(_ controller: AddItemViewController)
	func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

	weak var delegate: AddItemViewControllerDelegate?
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!

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
		delegate?.addItemViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		var item = ChecklistItem()
		item.text = textField.text!
		item.checked = false
		delegate?.addItemViewController(self, didFinishAdding: item)
	}
}
