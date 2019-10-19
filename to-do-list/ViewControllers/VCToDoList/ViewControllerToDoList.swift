//
//  ViewController.swift
//  to-do-list
//
//  Created by Nikolay Eckert on 15.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class ViewControllerToDoList: UIViewController {

    @IBOutlet weak var tableViewTaskList: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewTaskList.dataSource = self;
        self.tableViewTaskList.delegate = self;
    }
}
