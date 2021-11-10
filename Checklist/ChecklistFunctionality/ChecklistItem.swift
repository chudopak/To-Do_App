//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Stepan Kirillov on 10/9/21.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
	var text: String
	var checked: Bool
	
	var dueDate = Date()
	var shouldRemind = false
	var itemID: Int

	override init() {
		text = ""
		checked = false
		itemID = DataModel.nextChecklistItemID()
	}
	init(text: String, checked: Bool) {
		self.text = text
		self.checked = checked
		itemID = DataModel.nextChecklistItemID()
	}

	func toggleChecked () {
		checked = !checked
	}
	
	func scheduleNotification() {
		removeNotification()
		if shouldRemind && dueDate > Date() {
			let content = UNMutableNotificationContent()
			content.title = "Reminder:"
			content.body = text
			content.sound = UNNotificationSound.default

			let calendar = Calendar(identifier: .gregorian)
			let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)

			let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
			let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)

			let center = UNUserNotificationCenter.current()
			center.add(request)
		}
	}
	
	func removeNotification() {
		let center = UNUserNotificationCenter.current()
		center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
	}
}

