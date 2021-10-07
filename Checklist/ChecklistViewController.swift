//
//  ViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/6/21.
//

import UIKit

struct RowData {
	var row0 = (text: "Walk the dog", checked: true)
	var row1 = (text: "Brush my teeth", checked: true)
	var row2 = (text: "Learn iOS development", checked: true)
	var row3 = (text: "Soccer practice", checked: true)
	var row4 = (text: "Eat ice cream", checked: true)
}

class ChecklistViewController: UITableViewController {

	//@IBOutlet weak func
	var rowData = RowData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (100)
	}

	override func tableView(_ tableView:UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
		
		let label = cell.viewWithTag(1000) as! UILabel
		if indexPath.row % 5 == 0 {
			label.text = rowData.row0.text
		} else if indexPath.row % 5 == 1 {
			label.text = rowData.row1.text
		} else if indexPath.row % 5 == 2 {
			label.text = rowData.row2.text
		} else if indexPath.row % 5 == 3 {
			label.text = rowData.row3.text
		} else if indexPath.row % 5 == 4 {
			label.text = rowData.row4.text
		}
		return (cell)
	}
	
	func _isChecked(rowChecked: Bool, cell: UITableViewCell) {
		if (rowChecked == true) {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if let cell = tableView.cellForRow(at: indexPath) {
//			var isChecked = false
//			if indexPath.row == 0 {
//				rowData.row0.checked = !rowData.row0.checked
//			  isChecked = rowData.row0.checked
//			} else if indexPath.row == 1 {
//				rowData.row1.checked = !rowData.row1.checked
//			  isChecked = rowData.row1.checked
//			} else if indexPath.row == 2 {
//				rowData.row2.checked = !rowData.row2.checked
//			  isChecked = rowData.row2.checked
//			} else if indexPath.row == 3 {
//				rowData.row3.checked = !rowData.row3.checked
//			  isChecked = rowData.row3.checked
//			} else if indexPath.row == 4 {
//				rowData.row4.checked = !rowData.row4.checked
//			  isChecked = rowData.row4.checked
//			}
//			if isChecked {
//			  cell.accessoryType = .checkmark
//		} else {
//			  cell.accessoryType = .none
//			}
//		}
//		  tableView.deselectRow(at: indexPath, animated: true)
		if let cell = tableView.cellForRow(at: indexPath) {
			if indexPath.row % 5 == 0 {
				_isChecked(rowChecked: rowData.row0.checked, cell: cell)
				rowData.row0.checked = !rowData.row0.checked
				print(rowData.row0.checked)
			} else if indexPath.row % 5 == 1 {
				_isChecked(rowChecked: rowData.row1.checked, cell: cell)
			} else if indexPath.row % 5 == 2 {
				_isChecked(rowChecked: rowData.row2.checked, cell: cell)
			} else if indexPath.row % 5 == 3 {
				_isChecked(rowChecked: rowData.row3.checked, cell: cell)
			} else if indexPath.row % 5 == 4 {
				_isChecked(rowChecked: rowData.row4.checked, cell: cell)
			}
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

