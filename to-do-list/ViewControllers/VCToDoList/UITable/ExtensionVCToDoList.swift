//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit
import CoreData
import PopupDialog


extension ViewControllerToDoList: UITableViewDelegate, UITableViewDataSource {

    // MARK: --
    // MARK: Life cycle

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        var countElements = 0

        do {
            let tasks = try context.fetch(request) as! [NSManagedObject]

            if taskStatus != EnumStatusTask.unknown {
                countElements = CoreDataEntityTask.countElementsWithFilter(tasks: tasks, taskStatus: taskStatus)
            } else {
                countElements = tasks.count
            }
        } catch {
            fatalError()
        }

        return countElements
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellTask") as! TableViewCellTask

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityTask.entityName)
        request.returnsObjectsAsFaults = false

        do {
            let coreDataTasks = CoreDataEntityTask()

            let task = try coreDataTasks.getTask(
                    index: indexPath.item,
                    context: context,
                    request: request,
                    taskStatus: taskStatus)

            cell = _fillCell(cell: cell, task: task, coreDataTasks: coreDataTasks)
        } catch {
            fatalError()
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableViewTaskList.cellForRow(at: indexPath) as! TableViewCellTask

        let title = cell.labelNameTask.text
        let message = cell.labelPreviewTaskContent.text

        let popup = PopupDialog(title: title, message: message)

        popup.addButton(DefaultButton(title: "Хорошо") {
        })

        popup.backgroundColorMode(userInterfaceStyle: self.traitCollection.userInterfaceStyle)

        self.present(popup, animated: true)
    }


    // MARK: --
    // MARK: Fill cell

    private func _fillCell(
            cell: TableViewCellTask,
            task: NSManagedObject,
            coreDataTasks: CoreDataEntityTask
    ) -> TableViewCellTask {
        var cell = cell

        cell.buttonTaskComplete.isChecked = task.value(forKey: EnumCoreDataTaskAttributes.isComplete.rawValue) as! Bool
        cell.labelStatusTask.text = (task.value(forKey: EnumCoreDataTaskAttributes.status.rawValue) as! String)
        cell.labelNameTask.text = (task.value(forKey: EnumCoreDataTaskAttributes.name.rawValue) as! String)
        cell.labelPreviewTaskContent.text = (task.value(forKey: EnumCoreDataTaskAttributes.content.rawValue) as! String)

        cell = _fillButtonTags(cell: cell, task: task)
        cell = _fillCellOfTimes(cell: cell, task: task)

        cell.buttonTaskComplete.isChecked = task.value(forKey: EnumCoreDataTaskAttributes.isComplete.rawValue) as! Bool

        return cell
    }

    private func _fillButtonTags(cell: TableViewCellTask, task: NSManagedObject) -> TableViewCellTask {
        let name = EnumCoreDataTaskAttributes.id.rawValue
        cell.buttonTaskComplete.tag = task.value(forKey: name) as! Int
        cell.buttonTaskEdit.tag = task.value(forKey: name) as! Int
        cell.buttonTaskRemove.tag = task.value(forKey: name) as! Int

        return cell
    }

    private func _fillCellOfTimes(cell: TableViewCellTask, task: NSManagedObject) -> TableViewCellTask {
        let formatter = FormattedTime.dateFormatter()

        let actualCompletionTime = task.value(forKey: EnumCoreDataTaskAttributes.actualCompletionTime.rawValue) as! Date?
        if let actualCompletionTime = actualCompletionTime {
            cell.labelActualCompletionTime.isHidden = false
            cell.labelCompletedActualCompletionTime.isHidden = false
            cell.labelActualCompletionTime.text = formatter.string(from: actualCompletionTime)
        } else {
            cell.labelActualCompletionTime.isHidden = true
            cell.labelCompletedActualCompletionTime.isHidden = true
        }

        let scheduledCompletionTime = task.value(forKey: EnumCoreDataTaskAttributes.scheduledCompletionTime.rawValue) as! Date?
        if let scheduledCompletionTime = scheduledCompletionTime {
            cell.labelCompletionOnSchedule.text = formatter.string(from: scheduledCompletionTime)

            let currentTime = FormattedTime.currentDateAndTime()

            if scheduledCompletionTime < currentTime {
                if actualCompletionTime == nil || actualCompletionTime! > scheduledCompletionTime {
                    cell.backgroundColor = UIColor.withAlphaComponent(.systemPink)(0.2)
                }
            } else {
                cell.backgroundColor = .clear
            }

        } else {
            cell.labelCompletionOnSchedule.text = "-"
            cell.backgroundColor = .clear
        }

        return cell
    }


    // MARK: --
    // MARK: Other
}
