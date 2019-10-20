//
// Created by Nikolay Eckert on 20.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import Foundation


protocol EntityTask {
    func getName(taskId: Int) -> String?
    func getContent(taskId: Int) -> String?
    func getStatus(taskId: Int) -> String?
    func getIsComplete(taskId: Int) -> Bool
    func getActualCompletionTime(taskId: Int) -> Date?
    func getScheduledCompletionTime(taskId: Int) -> Date?


}