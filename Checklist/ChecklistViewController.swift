//
//  ViewController.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/6/21.
//

import UIKit

struct RowData {
	var row0 = (text: "Walk the dog", checked: false)
	var row1 = (text: "Brush my teeth", checked: false)
	var row2 = (text: "Learn iOS development", checked: false)
	var row3 = (text: "Soccer practice", checked: false)
	var row4 = (text: "Eat ice cream", checked: false)
}

class ChecklistViewController: UITableViewController {

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
			_isChecked(rowChecked: rowData.row0.checked, cell: cell)
		} else if indexPath.row % 5 == 1 {
			label.text = rowData.row1.text
			_isChecked(rowChecked: rowData.row1.checked, cell: cell)
		} else if indexPath.row % 5 == 2 {
			label.text = rowData.row2.text
			_isChecked(rowChecked: rowData.row2.checked, cell: cell)
		} else if indexPath.row % 5 == 3 {
			label.text = rowData.row3.text
			_isChecked(rowChecked: rowData.row3.checked, cell: cell)
		} else if indexPath.row % 5 == 4 {
			label.text = rowData.row4.text
			_isChecked(rowChecked: rowData.row4.checked, cell: cell)
		}
		return (cell)
	}
	
	private func _isChecked(rowChecked: Bool, cell: UITableViewCell) {
		if (rowChecked == true) {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
	}
	
	private func _rowInteraction(cell: UITableViewCell, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row % 5 == 0 {
			rowData.row0.checked = !rowData.row0.checked
			_isChecked(rowChecked: rowData.row0.checked, cell: cell)
		} else if indexPath.row % 5 == 1 {
			rowData.row1.checked = !rowData.row1.checked
			_isChecked(rowChecked: rowData.row1.checked, cell: cell)
		} else if indexPath.row % 5 == 2 {
			rowData.row2.checked = !rowData.row2.checked
			_isChecked(rowChecked: rowData.row2.checked, cell: cell)
		} else if indexPath.row % 5 == 3 {
			rowData.row3.checked = !rowData.row3.checked
			_isChecked(rowChecked: rowData.row3.checked, cell: cell)
		} else if indexPath.row % 5 == 4 {
			rowData.row4.checked = !rowData.row4.checked
			_isChecked(rowChecked: rowData.row4.checked, cell: cell)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			_rowInteraction(cell: cell, didSelectRowAt: indexPath)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

