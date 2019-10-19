//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


extension ViewControllerToDoList: UITableViewDelegate, UITableViewDataSource {

    private var _currentDate: String {
        get {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let currentTime = formatter.string(from: date)

            return currentTime
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContent.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask") as! TableViewCellTask

        cell.buttonCompleteTask.isChecked = true
        cell.labelStatusTask.text = EnumStatusTask.normal.rawValue

        cell.labelNameTask.text = arrayName[indexPath.item]
        cell.labelPreviewTaskContent.text = arrayContent[indexPath.item]

        cell.labelCompletionOnSchedule.text = self._currentDate
        cell.labelActualCompletionTime.text = self._currentDate

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}
