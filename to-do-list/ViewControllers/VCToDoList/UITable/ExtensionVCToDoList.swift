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
            let result = try context.fetch(request) as! [NSManagedObject]

            if taskStatus != EnumStatusTask.unknown {
                countElements = countElementsWithFilter(tasks: result)
            } else {
                countElements = result.count
            }
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
            var tasks = try context.fetch(request) as! [NSManagedObject]
            if taskStatus != EnumStatusTask.unknown {
                tasks = tasksFilter(tasks: tasks)
            }

            let index = indexPath.item
            let task = tasks[index]

            cell.buttonTaskComplete.isChecked = task.value(forKey: "isComplete") as! Bool
            cell.labelStatusTask.text = (task.value(forKey: "status") as! String)
            cell.labelNameTask.text = (task.value(forKey: "name") as! String)
            cell.labelPreviewTaskContent.text = (task.value(forKey: "content") as! String)

            cell.buttonTaskComplete.tag = task.value(forKey: "id") as! Int
            cell.buttonTaskEdit.tag = task.value(forKey: "id") as! Int
            cell.buttonTaskRemove.tag = task.value(forKey: "id") as! Int

            let formatter = DateFormatter()
            formatter.dateFormat = FormattedTime.dateFormat

            let actualCompletionTime = task.value(forKey: "actualCompletionTime") as! Date?
            let scheduledCompletionTime = task.value(forKey: "scheduledCompletionTime") as! Date?

            if (actualCompletionTime != nil) {
                cell.labelActualCompletionTime.isHidden = false
                cell.labelCompletedActualCompletionTime.isHidden = false
                cell.labelActualCompletionTime.text = formatter.string(from: actualCompletionTime!)
            } else {
                cell.labelActualCompletionTime.isHidden = true
                cell.labelCompletedActualCompletionTime.isHidden = true
            }

            if (scheduledCompletionTime != nil) {
                cell.labelCompletionOnSchedule.text = formatter.string(from: scheduledCompletionTime!)
            } else {
                cell.labelCompletionOnSchedule.text = "-"
            }
        } catch {
            fatalError()
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("jdsf \(indexPath.item)")
        indexElementSelected = indexPath.item
    }

    private func tasksFilter(tasks: [NSManagedObject]) -> [NSManagedObject] {
        var tasksFiltration = [NSManagedObject]()

        tasks.forEach({ task in
            let status = task.value(forKey: EnumCoreDataTaskAttributes.status.rawValue) as! String

            if status == taskStatus.rawValue {
                tasksFiltration.append(task)
            }
        })

        return tasksFiltration
    }

    private func countElementsWithFilter(tasks: [NSManagedObject]) -> Int {
        var count = 0

        tasks.forEach({ task in
            let taskStatusElement = task.value(forKey: EnumCoreDataTaskAttributes.status.rawValue) as! String
            if taskStatusElement == taskStatus.rawValue {
                count += 1
            }
        })

        return count
    }

}
