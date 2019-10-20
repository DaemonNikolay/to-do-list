//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import CoreData
import UIKit


class CoreDataEntityTask: EntityTask {

    // MARK: -
    // MARK: Private constants

    private let _appDelegate: AppDelegate
    private let _context: NSManagedObjectContext

    private let _entityName = "Task"


    // MARK: -
    // MARK: Public methods

    init() {
        _appDelegate = UIApplication.shared.delegate as! AppDelegate
        _context = _appDelegate.persistentContainer.viewContext
    }

    func getName(index: Int) -> String? {
        let name = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.content)

        return name as? String
    }

    func getContent(index: Int) -> String? {
        let content = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.content)

        return content as? String
    }

    func getStatus(index: Int) -> String? {
        let status = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.status)

        return status as? String
    }

    func getIsComplete(index: Int) -> Bool {
        let isComplete = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.isComplete)

        return isComplete as! Bool
    }

    func getActualCompletionTime(index: Int) -> Date? {
        let actualCompletionTime = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.actualCompletionTime)

        return actualCompletionTime as? Date
    }

    func getScheduledCompletionTime(index: Int) -> Date? {
        let scheduledCompletionTime = _getElementCoreData(index: index, taskAttribute: EnumCoreDataTaskAttributes.scheduledCompletionTime)

        return scheduledCompletionTime as? Date
    }

    func save(name: String,
              content: String,
              status: EnumStatusTask,
              isComplete: Bool,
              actualCompletionTime: Date?,
              scheduledCompletionTime: Date?) -> Bool {

        if (!_checkTaskAttributes(name: name, content: content)) {
            return false
        }

        let entity = NSEntityDescription.entity(forEntityName: _entityName, in: _context)
        let newTask = NSManagedObject(entity: entity!, insertInto: _context)

        let taskAttributes = EnumCoreDataTaskAttributes.self

        newTask.setValue(name, forKey: taskAttributes.name.rawValue)
        newTask.setValue(content, forKey: taskAttributes.content.rawValue)
        newTask.setValue(status.rawValue, forKey: taskAttributes.status.rawValue)

        newTask.setValue(isComplete, forKey: taskAttributes.isComplete.rawValue)
        newTask.setValue(actualCompletionTime, forKey: taskAttributes.actualCompletionTime.rawValue)
        newTask.setValue(scheduledCompletionTime, forKey: taskAttributes.scheduledCompletionTime.rawValue)

        do {
            try _context.save()

            return true
        } catch {
            print("Failed saving")

            return false
        }
    }


    // MARK: -
    // MARK: Private methods

    private func _checkTaskAttributes(name: String, content: String) -> Bool {
        return !(name.isEmpty && name.isEmpty)
    }

    private func _getElementCoreData(index: Int, taskAttribute: EnumCoreDataTaskAttributes) -> Any? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
        request.returnsObjectsAsFaults = false

        do {
            let fetchResult = try _context.fetch(request)
            let task = fetchResult[index] as! NSManagedObject

            return task.value(forKey: taskAttribute.rawValue) as Any
        } catch {
            return nil
        }
    }
}