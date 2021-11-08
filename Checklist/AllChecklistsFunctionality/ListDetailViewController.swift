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

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {

	weak var delegate: ListDetailViewControllerDelegate?
	
	@IBOutlet var textField: UITextField!
	@IBOutlet var doneBarButton: UIBarButtonItem!
	@IBOutlet var iconImageView: UIImageView!
	
	var checklistToEdit: Checklist?
	
	var iconName = "Inbox"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let checklist = checklistToEdit {
			title = "Edit Checklist"
			textField.text = checklist.name
			doneBarButton.isEnabled = true
			iconName = checklist.iconName
		}
		iconImageView.image = UIImage(named: iconName)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if (indexPath.section == 1) {
			return (indexPath)
		} else {
			return (nil)
		}
	}
	
	func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
		self.iconName = iconName
		iconImageView.image = UIImage(named: iconName)
		let _ = navigationController?.popViewController(animated: true)
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
			list.iconName = iconName
			delegate?.listDetailViewController(self, didFnishEditing: list)
		} else {
			let list = Checklist(name: textField.text!, iconName: iconName)
			delegate?.listDetailViewController(self, didFnishAdding: list)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "PickIcon") {
			let controller = segue.destination as! IconPickerViewController
			controller.delegate = self
		}
	}
}
