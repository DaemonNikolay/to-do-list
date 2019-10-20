//
//  ViewControllerDetailsTask.swift
//  to-do-list
//
//  Created by Nikolay Eckert on 20.10.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class ViewControllerDetailsTask: UIViewController {

    let datePicker = UIDatePicker()


    // MARK: -
    // MARK: IBOutlets

    @IBOutlet weak var textFieldNameTask: UITextField!
    @IBOutlet weak var textViewContentTask: UITextView!
    @IBOutlet weak var segmentedControlTaskStatus: UISegmentedControl!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var labelErrorDate: UILabel!


    // MARK: -
    // MARK: IBActions

    @IBAction func segmentedControlTaskStatus_change(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  do {
            print("0")
        }
        case 1: do {
            print("1")
        }
        case 2: do {
            print("2")
        }
        default: print("default")
        }
    }

    @IBAction func buttonScheduledCompletionTime_click(_ sender: Any) {
        print("432432652323456")
        showDatePicker()
    }

    @IBAction func buttonSave_click(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"

        if dateFormatter.date(from: txtDatePicker.text!) != nil {
            print("date is valid")
            labelErrorDate.isHidden = true
        } else {
            print("date is invalid")
            labelErrorDate.isHidden = false
        }

        print("\(textFieldNameTask.text!) \(textViewContentTask.text!) \(segmentedControlTaskStatus.selectedSegmentIndex) \(txtDatePicker.text!)")
    }

    func showDatePicker() {
        datePicker.datePickerMode = .dateAndTime

        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)

        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
    }

    @objc func donedatePicker() {

        labelErrorDate.isHidden = true

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm"
        txtDatePicker.text = formatter.string(from: datePicker.date)

        print("ewr ", formatter.string(from: datePicker.date))

        self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }


    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Screen"

        stylizationTextViewContentTask()
        showDatePicker()
    }


    // MARK: -
    // MARK: Services

    private func stylizationTextViewContentTask() {
        textViewContentTask.layer.borderWidth = 1
        textViewContentTask.layer.cornerRadius = 5
        textViewContentTask.layer.borderColor = UIColor.lightGray.cgColor
    }
}
