//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import CoreData
import UIKit


class CoreDataEntityTask: EntityTask {

    // MARK: --
    // MARK: Constants

    static let entityName = "Task"

    private let _appDelegate: AppDelegate
    private let _context: NSManagedObjectContext


    // MARK: --
    // MARK: Properties

    private var _requestCoreData: NSFetchRequest<NSFetchRequestResult> {
        get {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityTask.entityName)
            request.returnsObjectsAsFaults = false

            return request
        }
    }


    // MARK: --
    // MARK: Methods

    // MARK: ---
    // MARK: Init

    init() {
        _appDelegate = UIApplication.shared.delegate as! AppDelegate
        _context = _appDelegate.persistentContainer.viewContext
    }

    // MARK: ---
    // MARK: Getters

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

    func getTask(index: Int,
                 context: NSManagedObjectContext,
                 request: NSFetchRequest<NSFetchRequestResult>,
                 taskStatus: EnumStatusTask
    ) throws -> NSManagedObject {

        let tasks = try self.getTasks(context: context, request: request, taskStatus: taskStatus)
        let task = tasks[index]

        return task
    }

    func getTasks(
            context: NSManagedObjectContext,
            request: NSFetchRequest<NSFetchRequestResult>,
            taskStatus: EnumStatusTask
    ) throws -> [NSManagedObject] {

        var tasks = try context.fetch(request) as! [NSManagedObject]
        if taskStatus != EnumStatusTask.unknown {
            tasks = CoreDataEntityTask.tasksFilter(tasks: tasks, taskStatus: taskStatus)
        }

        return tasks
    }

    private func _getTask(taskId: Int, attribute: EnumCoreDataTaskAttributes) -> Any? {
        do {
            let fetchOfTasks = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(fetchOfTasks: fetchOfTasks, id: taskId)
            if taskManagedObject == nil {
                return nil
            }

            return taskManagedObject?.value(forKey: attribute.rawValue)
        } catch {
            return nil
        }
    }

    private func _getTask(fetchOfTasks: [NSManagedObject], id: Int) -> NSManagedObject? {
        var taskManagedObject: NSManagedObject? = nil

        fetchOfTasks.forEach({ task in
            let taskId = task.value(forKey: EnumCoreDataTaskAttributes.id.rawValue) as! Int
            if taskId == id {
                taskManagedObject = task
                return
            }
        })

        return taskManagedObject
    }

    // MARK: ---
    // MARK: CRUD (without read)

    func save(name: String,
              content: String,
              status: EnumStatusTask,
              isComplete: Bool,
              actualCompletionTime: Date?,
              scheduledCompletionTime: Date?) -> Bool {

        if (!_checkTaskAttributes(name: name, content: content)) {
            return false
        }

        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityTask.entityName, in: _context)
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
            return false
        }
    }

    func edit(id: Int, key: EnumCoreDataTaskAttributes, value: Any?) -> Bool {
        do {
            let fetchOfTasks = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(fetchOfTasks: fetchOfTasks, id: id)
            if taskManagedObject == nil {
                return false
            }

            taskManagedObject?.setValue(value, forKey: key.rawValue)
            try _context.save()

            return true
        } catch {
            return false
        }
    }

    func remove(id: Int) -> Bool {
        do {
            let fetchOfTasks = try _context.fetch(_requestCoreData) as! [NSManagedObject]
            let taskManagedObject: NSManagedObject? = self._getTask(fetchOfTasks: fetchOfTasks, id: id)
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


    // MARK: --
    // MARK: Validation methods

    private func _checkTaskAttributes(name: String, content: String) -> Bool {
        return !(name.isEmpty && name.isEmpty)
    }


    // MARK: --
    // MARK: Filter methods

    static func tasksFilter(tasks: [NSManagedObject], taskStatus: EnumStatusTask) -> [NSManagedObject] {
        var tasksFiltration = [NSManagedObject]()

        tasks.forEach({ task in
            let status = task.value(forKey: EnumCoreDataTaskAttributes.status.rawValue) as! String

            if status == taskStatus.rawValue {
                tasksFiltration.append(task)
            }
        })

        return tasksFiltration
    }

    static func countElementsWithFilter(tasks: [NSManagedObject], taskStatus: EnumStatusTask) -> Int {
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