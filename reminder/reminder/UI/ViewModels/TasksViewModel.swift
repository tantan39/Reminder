//
//  TasksViewModel.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation

class TasksViewModel: ObservableObject {
    @Published var items: [TaskCellViewModel] = []
    
    func addTask(_ task: Task) {
        let cellViewModel = TaskCellViewModel(task: task)
        items.append(cellViewModel)
    }
}
