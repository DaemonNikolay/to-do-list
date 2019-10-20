//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import Foundation


class FormattedTime {

    // MARK: --
    // MARK: Properties

    static let dateFormat = "dd.MM.yyyy hh:mm"


    // MARK: --
    // MARK: Methods

    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = FormattedTime.dateFormat

        return formatter
    }

    static func currentDateAndTime() -> Date {
        return Date()
    }
}