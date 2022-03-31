//
//  TasksViewModel.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation

class TasksViewModel: ObservableObject {
    @Published var items: [TaskCellViewModel] = mockTasks.map { TaskCellViewModel(task: $0) }
    
    func addTask(_ task: Task) {
        let cellViewModel = TaskCellViewModel(task: task)
        items.append(cellViewModel)
    }
    
    func removeTask(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
}
