//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


extension ViewControllerToDoList: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask") as! TableViewCellTask

        cell.labelStatusTask.text = EnumStatusTask.normal.rawValue

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)

        cell.labelActualCompletionTime.text = result


        return cell
    }

    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        fatalError("tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:) has not been implemented")
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
