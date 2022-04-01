//
//  TaskRepository.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation

class BaseTaskRepository: NSObject {
    @Published var tasks: [Task] = []
}

protocol TaskRepository: BaseTaskRepository {
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTask(_ task: Task)
}
