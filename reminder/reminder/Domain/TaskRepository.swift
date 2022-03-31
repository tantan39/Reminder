//
//  TaskRepository.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation

protocol TaskRepository {
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTask(_ task: Task)
}
