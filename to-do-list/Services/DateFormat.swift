//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import Foundation


class DateFormat {

    // MARK: -
    // MARK: Properties

    static let dateFormat = "dd.MM.yyyy hh:mm"


    // MARK: -
    // MARK: Public methods

    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dateFormat

        return formatter
    }
}