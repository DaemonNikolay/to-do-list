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
    // MARK: Properties

    private var _requestCoreData: NSFetchRequest<NSFetchRequestResult> {
        get {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName)
            request.returnsObjectsAsFaults = false

            return request
        }
    }


    // MARK: -
    // MARK: Public methods

    init() {
        _appDelegate = UIApplication.shared.delegate as! AppDelegate
        _context = _appDelegate.persistentContainer.viewContext
    }

    func getName(taskId: Int) -> String? {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.name) as! String?

        return result
    }

    func getContent(taskId: Int) -> String? {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.content) as! String?

        return result
    }

    func getStatus(taskId: Int) -> String? {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.status) as! String?

        return result
    }

    func getIsComplete(taskId: Int) -> Bool {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.isComplete) as! Bool

        return result
    }

    func getActualCompletionTime(taskId: Int) -> Date? {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.actualCompletionTime) as! Date?

        return result
    }

    func getScheduledCompletionTime(taskId: Int) -> Date? {
        let result = _getTask(taskId: taskId, attribute: EnumCoreDataTaskAttributes.scheduledCompletionTime) as! Date?

        return result
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
        let coreDataUniqueId = CoreDataEntityUniqueId.shared

        newTask.setValue(coreDataUniqueId.getId(), forKey: taskAttributes.id.rawValue)

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

    func remove(id: Int) -> Bool {
        do {
            let fetchResult = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(tasksFetchResult: fetchResult, id: id)

            if taskManagedObject == nil {
                return false
            }

            _context.delete(taskManagedObject!)
            try _context.save()

            return true
        } catch {
            return false
        }
    }

    func edit(id: Int, key: EnumCoreDataTaskAttributes, value: Any?) -> Bool {
        do {
            let fetchResult = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(tasksFetchResult: fetchResult, id: id)

            taskManagedObject?.setValue(value, forKey: key.rawValue)
            try _context.save()

            return true
        } catch {
            return false
        }
    }


    // MARK: -
    // MARK: Private methods

    private func _checkTaskAttributes(name: String, content: String) -> Bool {
        return !(name.isEmpty && name.isEmpty)
    }

    private func _getTask(taskId: Int, attribute: EnumCoreDataTaskAttributes) -> Any? {
        do {
            let fetchResult = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(tasksFetchResult: fetchResult, id: taskId)
            let element = taskManagedObject?.value(forKey: attribute.rawValue)

            return element
        } catch {
            return nil
        }
    }

    private func _getTask(tasksFetchResult: [NSManagedObject], id: Int) -> NSManagedObject? {
        var taskManagedObject: NSManagedObject? = nil

        tasksFetchResult.forEach({ element in
            let taskId = element.value(forKey: EnumCoreDataTaskAttributes.id.rawValue) as! Int
            if taskId == id {
                taskManagedObject = element
                return
            }
        })

        return taskManagedObject
    }
}