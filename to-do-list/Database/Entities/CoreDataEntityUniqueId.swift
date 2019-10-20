//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataEntityUniqueId {

    private let entityName: String = "UniqueId"
    private let attributeName: String = "id"

    private init() {
    }

    static var shared: CoreDataEntityUniqueId = {
        let instance = CoreDataEntityUniqueId()

        return instance
    }()


    func getId() -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        request.returnsObjectsAsFaults = false

        do {
            let fetchResult = try context.fetch(request)

            if fetchResult.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
                let newUniqueId = NSManagedObject(entity: entity!, insertInto: context)
                newUniqueId.setValue(0, forKey: attributeName)

                try _saveUniqueId(context: context)

                return 0
            }

            let uniqueId = fetchResult[0] as! NSManagedObject
            var id = uniqueId.value(forKey: attributeName) as! Int64
            id += 1

            uniqueId.setValue(id , forKey: attributeName)

            try _saveUniqueId(context: context)

            return id

        } catch {
            fatalError()
        }
    }

    private func _saveUniqueId(context: NSManagedObjectContext) throws {
        try context.save()
    }
}