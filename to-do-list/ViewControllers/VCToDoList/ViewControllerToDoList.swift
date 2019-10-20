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

    var tasks = [NSManagedObject]()


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

    @IBAction func buttonEditTask_click(_ sender: Any) {
        print("43434343")
    }


    @IBAction func buttonRemoveTask_click(_ sender: Any) {
        print("hgfdhdftr")
    }

    @IBAction func buttonNewTask_click(_ sender: Any) {
        self.performSegue(withIdentifier: "detailsTask", sender: self)
    }

    @IBAction func buttonFilter_click(_ sender: Any) {
        print("jgfiodjhghjodf")
    }
}
