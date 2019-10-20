//
//  ViewControllerDetailsTask.swift
//  to-do-list
//
//  Created by Nikolay Eckert on 20.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class ViewControllerDetailsTask: UIViewController, UITextViewDelegate {

    var taskId: Int?

    // MARK: -
    // MARK: Constants

    let datePicker = UIDatePicker()


    // MARK: -
    // MARK: IBOutlets

    @IBOutlet weak var textFieldNameTask: UITextField!
    @IBOutlet weak var textViewContentTask: UITextView!
    @IBOutlet weak var segmentedControlTaskStatus: UISegmentedControl!
    @IBOutlet weak var textFieldDatePicker: UITextField!
    @IBOutlet weak var labelErrorDate: UILabel!


    // MARK: -
    // MARK: Button actions

    @IBAction func buttonSave_click(_ sender: Any) {
        let dateFormatter = FormattedTime.dateFormatter()

        let name = textFieldNameTask.text!
        let content = textViewContentTask.text!
        let status = _getSegment(selectedSegmentIndex: segmentedControlTaskStatus.selectedSegmentIndex)
        let scheduledCompletionTime = dateFormatter.date(from: textFieldDatePicker.text!)

        let coreDataTask = CoreDataEntityTask()
        var isSave = false

        if taskId == nil {
            isSave = coreDataTask.save(
                    name: name,
                    content: content,
                    status: status,
                    isComplete: false,
                    actualCompletionTime: nil,
                    scheduledCompletionTime: scheduledCompletionTime)
        } else {
            let id = taskId!
            let isChangeName = coreDataTask.edit(id: id, key: EnumCoreDataTaskAttributes.name, value: name)
            let isChangeContent = coreDataTask.edit(id: id, key: EnumCoreDataTaskAttributes.content, value: content)

            let isChangeStatus = coreDataTask.edit(
                    id: id,
                    key: EnumCoreDataTaskAttributes.status,
                    value: status.rawValue)

            let isChangeScheduledCompletionTime = coreDataTask.edit(
                    id: id,
                    key: EnumCoreDataTaskAttributes.scheduledCompletionTime,
                    value: scheduledCompletionTime)

            isSave = isChangeName && isChangeContent && isChangeStatus && isChangeScheduledCompletionTime
        }


        if (isSave) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func datePickerButtonDone_click() {
        labelErrorDate.isHidden = true

        let formatter = FormattedTime.dateFormatter()
        textFieldDatePicker.text = formatter.string(from: datePicker.date)

        self.view.endEditing(true)
    }

    @objc func datePickerButtonCancel_click() {
        self.view.endEditing(true)
    }


    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        _initTitle()
        _stylizationTextViewContentTask()
        _showDatePicker()
        _tapGestureRecognizerDismissKeyboard()
        _initFields()
    }


    // MARK: -
    // MARK: TextView

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if ((range.length + range.location) > textViewContentTask.text.count) {
            return false
        }

        let contentLength = textViewContentTask.text.count + text.count - range.length

        return contentLength <= 300
    }

    // MARK: -
    // MARK: Services

    private func _initFields() {
        if (taskId == nil) {
            return
        }

        let coreDataTask = CoreDataEntityTask()

        let id = taskId!

        print("jgpdfj \(id)")

        textFieldNameTask.text = coreDataTask.getName(taskId: id)
        textViewContentTask.text = coreDataTask.getContent(taskId: id)

        let scheduledCompletionTime = coreDataTask.getScheduledCompletionTime(taskId: id)
        if scheduledCompletionTime != nil {
            let formatter = FormattedTime.dateFormatter()
            textFieldDatePicker.text = formatter.string(from: scheduledCompletionTime!)
        }

        let statusTask = coreDataTask.getStatus(taskId: id)

        switch statusTask! {

        case EnumStatusTask.normal.rawValue: segmentedControlTaskStatus.selectedSegmentIndex = 0
        case EnumStatusTask.significant.rawValue: segmentedControlTaskStatus.selectedSegmentIndex = 1
        case EnumStatusTask.verySignificant.rawValue: segmentedControlTaskStatus.selectedSegmentIndex = 2

        default: segmentedControlTaskStatus.selectedSegmentIndex = 0
        }
    }

    private func _initTitle() {
        if taskId != nil {
            self.title = "Task change"
            return
        }

        self.title = "New task"
    }

    private func _stylizationTextViewContentTask() {
        textViewContentTask.layer.borderWidth = 1
        textViewContentTask.layer.cornerRadius = 5
        textViewContentTask.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func _getSegment(selectedSegmentIndex: Int) -> EnumStatusTask {
        switch selectedSegmentIndex {

        case 0: return EnumStatusTask.normal
        case 1: return EnumStatusTask.significant
        case 2: return EnumStatusTask.verySignificant

        default: return EnumStatusTask.unknown
        }
    }

    private func _showDatePicker() {
        datePicker.datePickerMode = .dateAndTime

        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerButtonDone_click));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerButtonCancel_click));

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)

        textFieldDatePicker.inputAccessoryView = toolbar
        textFieldDatePicker.inputView = datePicker
    }

    private func _tapGestureRecognizerDismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                action: #selector(ViewControllerDetailsTask._dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc private func _dismissKeyboard() {
        view.endEditing(true)
    }
}
