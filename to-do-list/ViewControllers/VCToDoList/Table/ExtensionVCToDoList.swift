//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit
import CoreData


extension ViewControllerToDoList: UITableViewDelegate, UITableViewDataSource {

    private var _currentDate: String {
        get {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let currentTime = formatter.string(from: date)

            return currentTime
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        var countElements = 0

        do {
            let result = try context.fetch(request)
            countElements = (result as! [NSManagedObject]).count
        } catch {
            print("Failed")
        }

        return countElements
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask") as! TableViewCellTask

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        request.returnsObjectsAsFaults = false

        do {
            let fetchResult = try context.fetch(request)
            let task = fetchResult[indexPath.item] as! NSManagedObject

            cell.buttonCompleteTask.isChecked = task.value(forKey: "isComplete") as! Bool
            cell.labelStatusTask.text = (task.value(forKey: "status") as! String)
            cell.labelNameTask.text = (task.value(forKey: "name") as! String)

            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"

            let actualCompletionTime = task.value(forKey: "actualCompletionTime") as! Date
            let scheduledCompletionTime = task.value(forKey: "scheduledCompletionTime") as! Date?

            cell.labelCompletionOnSchedule.text = formatter.string(from: actualCompletionTime)

            print("kpofdg \(scheduledCompletionTime == nil)")

            if (scheduledCompletionTime != nil) {
                print("jgpfdjgpdfj43345", scheduledCompletionTime as Any)
                cell.labelCompletionOnSchedule.text = formatter.string(from: scheduledCompletionTime!)
            } else {
                NSLog("gfdhgsd")
                cell.labelCompletionOnSchedule.text = "-"
            }
        } catch {
            print("Failed fetch data")
        }


        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}
