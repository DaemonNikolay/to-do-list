//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import Foundation


protocol EntityTask {
    func getName(index: Int) -> String?
    func getContent(index: Int) -> String?
    func getStatus(index: Int) -> String?
    func getIsComplete(index: Int) -> Bool
    func getActualCompletionTime(index: Int) -> Date?
    func getScheduledCompletionTime(index: Int) -> Date?


}