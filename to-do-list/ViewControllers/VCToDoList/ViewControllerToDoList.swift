//
//  ViewController.swift
//  to-do-list
//
//  Created by Nikolay Eckert on 15.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

import UIKit
import CoreData
import PopupDialog


class ViewControllerToDoList: UIViewController {

    // MARK: -
    // MARK: IBOutlet

    @IBOutlet weak var tableViewTaskList: UITableView!

    // MARK: -
    // MARK: Properties


    var arrayName = [NSManagedObject]()


    let arrayContent = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the.", ]

//    let arrayName = ["First", "Second", "Thirty", "Fourth"]


    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
//        let newUser = NSManagedObject(entity: entity!, insertInto: context)
//
//        newUser.setValue("First", forKey: "name")
//        newUser.setValue("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", forKey: "content")
//        newUser.setValue(EnumStatusTask.verySignificant.rawValue, forKey: "status")
//        newUser.setValue(false, forKey: "isComplete")
//        newUser.setValue(Date(), forKey: "actualCompletionTime")
//        newUser.setValue(nil, forKey: "scheduledCompletionTime")
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed saving")
//        }


        self.tableViewTaskList.dataSource = self;
        self.tableViewTaskList.delegate = self;
    }

    override func viewWillAppear(_ animated: Bool) {
        print("pfdjpgjdsfpger")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.destination is ViewControllerDetailsTask {
            let vc = segue.destination as? ViewControllerDetailsTask
//            vc?.username = "Arthur Dent"
        }
    }

    @IBAction func buttonNewTask_click(_ sender: Any) {
        print("gopr90439043")
        self.performSegue(withIdentifier: "detailsTask", sender: self)
    }

    @IBAction func buttonFliter_click(_ sender: Any) {
        print("jgfiodjhghjodf")
    }
}
