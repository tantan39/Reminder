//
//  Task.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation

enum TaskPriority: Codable {
    case low
    case medium
    case high
}

#if DEBUG
let mockTasks = [
  Task(title: "Learn about async/await", priority: .medium, completed: false),
  Task(title: "Practice", priority: .medium, completed: false),
  Task(title: "Practice more", priority: .high, completed: false),
  Task(title: "Build side projects", priority: .high, completed: true)
]
#endif

struct Task: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var priority: TaskPriority
    var completed: Bool
}
