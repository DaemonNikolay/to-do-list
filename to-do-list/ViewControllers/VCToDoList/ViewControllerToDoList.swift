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
    // MARK: Constants

    let titleViewName = "To do list"


    // MARK: --
    // MARK: IBOutlet

    @IBOutlet weak var tableViewTaskList: UITableView!


    // MARK: --
    // MARK: Properties

    var taskStatus: EnumStatusTask = EnumStatusTask.unknown
    var taskId: Int?

    private var _timer: Timer?


    // MARK: --
    // MARK: Button actions

    @IBAction func buttonCompleteTask_click(_ sender: Checkbox) {
        let coreDataTask = CoreDataEntityTask()

        let isEditIsComplete = coreDataTask.edit(
                id: sender.tag,
                key: EnumCoreDataTaskAttributes.isComplete,
                value: !sender.isChecked)

        var isEditActualCompletionTime = false
        if (!sender.isChecked) {
            isEditActualCompletionTime = coreDataTask.edit(
                    id: sender.tag,
                    key: EnumCoreDataTaskAttributes.actualCompletionTime,
                    value: FormattedTime.currentDateAndTime())
        } else {
            isEditActualCompletionTime = coreDataTask.edit(
                    id: sender.tag,
                    key: EnumCoreDataTaskAttributes.actualCompletionTime,
                    value: nil)
        }

        if (isEditActualCompletionTime && isEditIsComplete) {
            self.tableViewTaskList.reloadData()
        }
    }

    @IBAction func buttonEditTask_click(_ sender: UIButton) {
        taskId = sender.tag

        self.performSegue(withIdentifier: "detailsTask", sender: self)
    }

    @IBAction func buttonRemoveTask_click(_ sender: UIButton) {
        let alert = UIAlertController(
                title: "Удаление",
                message: "Действительно хотите удалить? \nДействие не обратимо",
                preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
            let coreDataTask = CoreDataEntityTask()
            let isRemove = coreDataTask.remove(id: sender.tag)

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
        let popup = PopupDialog(title: "Фильтр", message: "По какому статусу фильтровать?")
        popup.backgroundColorMode(userInterfaceStyle: self.traitCollection.userInterfaceStyle)

        let buttonNormal = DefaultButton(title: EnumStatusTask.normal.rawValue) {
            self._changeTaskStatus(status: .normal)
        }

        let buttonSignificant = DefaultButton(title: EnumStatusTask.significant.rawValue) {
            self._changeTaskStatus(status: .significant)
        }

        let buttonVerySignificant = DefaultButton(title: EnumStatusTask.verySignificant.rawValue) {
            self._changeTaskStatus(status: .verySignificant)
        }

        let buttonWithoutFilter = CancelButton(title: "Без фильтра") {
            self._changeTaskStatus(status: .unknown)
        }

        popup.addButtons([buttonNormal,
                          buttonSignificant,
                          buttonVerySignificant,
                          buttonWithoutFilter])

        self.present(popup, animated: true, completion: nil)
    }


    // MARK: --
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewTaskList.dataSource = self;
        self.tableViewTaskList.delegate = self;

        _createTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableViewTaskList.reloadData()
        self.taskId = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.destination is ViewControllerDetailsTask {
            let vc = segue.destination as? ViewControllerDetailsTask
            vc?.taskId = self.taskId
        }
    }


    // MARK: --
    // MARK: Services

    private func _changeTaskStatus(status: EnumStatusTask) {
        if self.taskStatus != status {
            self.taskStatus = status
            _switchTitleView(status: status)

            self.tableViewTaskList.reloadData()
        }
    }

    private func _switchTitleView(status: EnumStatusTask) {
        switch status {

        case EnumStatusTask.normal: _changeTitleViewName(newName: EnumStatusTask.pluralNormal.rawValue)
        case EnumStatusTask.significant: _changeTitleViewName(newName: EnumStatusTask.pluralSignificant.rawValue)
        case EnumStatusTask.verySignificant: _changeTitleViewName(newName: EnumStatusTask.pluralVerySignificant.rawValue)

        case EnumStatusTask.unknown: _changeTitleViewName(newName: titleViewName)

        default: _changeTitleViewName(newName: titleViewName)
        }
    }

    private func _changeTitleViewName(newName: String) {
        if newName == titleViewName {
            self.navigationItem.title = newName
            return
        }

        self.navigationItem.title = "\(titleViewName): \(newName.localizedLowercase)"
    }

    private func _createTimer() {
        if _timer == nil {
            _timer = Timer.scheduledTimer(timeInterval: 30.0,
                    target: self,
                    selector: #selector(_updateTableViewTaskForTimer),
                    userInfo: nil,
                    repeats: true)
        }
    }

    @objc private func _updateTableViewTaskForTimer() {
        self.tableViewTaskList.reloadData()
    }


    // MARK: --
    // MARK: Other
}
