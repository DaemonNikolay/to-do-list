//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class TableViewCellTask: UITableViewCell {
    @IBOutlet weak var labelStatusTask: UILabel!

    @IBOutlet weak var labelPreviewTaskContent: UILabel!
    @IBOutlet weak var labelNameTask: UILabel!

    @IBOutlet weak var labelCompletionOnSchedule: UILabel!
    @IBOutlet weak var labelActualCompletionTime: UILabel!

    @IBOutlet weak var buttonCompleteTask: Checkbox!
    @IBAction func buttonCompleteTask_click(_ sender: Any) {
        NSLog("Click")
    }
}
