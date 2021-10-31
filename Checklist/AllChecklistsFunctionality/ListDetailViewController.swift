//
//  ListDetailViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/30/21.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
	func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
	func listDetailViewController(_ controller: ListDetailViewController, didFnishAdding item: Checklist)
	func listDetailViewController(_ controller: ListDetailViewController, didFnishEditing item: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {

	weak var delegate: ListDetailViewControllerDelegate?
	
	@IBOutlet var textField: UITextField!
	@IBOutlet var doneBarButton: UIBarButtonItem!

	var checklistToEdit: Checklist?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let checklist = checklistToEdit {
			title = "Edit Checklist"
			textField.text = checklist.name
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
		delegate?.listDetailViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		if let list = checklistToEdit {
			list.name = textField.text!
			delegate?.listDetailViewController(self, didFnishEditing: list)
		} else {
			let list = Checklist(name: "")
			list.name = textField.text!
			delegate?.listDetailViewController(self, didFnishAdding: list)
		}
	}
}
