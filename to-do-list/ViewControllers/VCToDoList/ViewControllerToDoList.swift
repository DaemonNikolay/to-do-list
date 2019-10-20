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

//    var tasks = [NSManagedObject]()

    var indexElementSelected: Int = 0


    // MARK: -
    // MARK: Button actions

    @IBAction func buttonCompleteTask_click(_ sender: Any) {
        NSLog("Click")
    }

    @IBAction func buttonEditTask_click(_ sender: UIButton) {
        print("43434343 \(sender.tag)")
    }

    @IBAction func buttonRemoveTask_click(_ sender: UIButton) {
        let alert = UIAlertController(
                title: "Удаление",
                message: "Действительно хотите удалить? \nДействие не обратимо",
                preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
            let coreDataTask = CoreDataEntityTask()
            let isRemove = coreDataTask.remove(index: sender.tag)

            if isRemove {
                self.tableViewTaskList.reloadData()
            }
        }))

        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func buttonNewTask_click(_ sender: Any) {
        self.performSegue(withIdentifier: "detailsTask", sender: self)
    }

    @IBAction func buttonFilter_click(_ sender: Any) {
        print("jgfiodjhghjodf")
    }


    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewTaskList.dataSource = self;
        self.tableViewTaskList.delegate = self;
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableViewTaskList.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.destination is ViewControllerDetailsTask {
            let vc = segue.destination as? ViewControllerDetailsTask
//            vc?.username = "Arthur Dent"
        }
    }
}
