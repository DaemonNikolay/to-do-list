//
//  ViewController.swift
//  to-do-list
//
//  Created by Nikolay Eckert on 15.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class ViewControllerToDoList: UIViewController {

    // MARK: -
    // MARK: IBOutlet

    @IBOutlet weak var tableViewTaskList: UITableView!

    // MARK: -
    // MARK: Properties




    let arrayContent = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the.",
                        "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur.",
                        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters."]

    let arrayName = ["First", "Second", "Thirty", "Fourth"]


    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewTaskList.dataSource = self;
        self.tableViewTaskList.delegate = self;
    }
}
