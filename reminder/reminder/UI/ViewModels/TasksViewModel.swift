//
//  TasksViewModel.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation
import Combine

class TasksViewModel: ObservableObject {
    @Published var repository: TaskRepository
    @Published var items: [TaskCellViewModel] = []
    private var cancellable = Set<AnyCancellable>()
    
    init(service: TaskRepository) {
        self.repository = service
//        self.items = self.repository.tasks.compactMap {
//            TaskCellViewModel(task: $0)
//        }
        repository.$tasks.map { task in
            task.map {
                TaskCellViewModel(task: $0)
            }
        }
        .assign(to: \.items, on: self)
        .store(in: &cancellable)
    }
    
    func addTask(_ task: Task) {
//        let cellViewModel = TaskCellViewModel(task: task)
//        items.append(cellViewModel)
        repository.addTask(task)
    }
    
    func removeTask(at indexSet: IndexSet) {
        let viewModels = indexSet.lazy.map { self.items[$0] }
        viewModels.forEach { vm in
            repository.removeTask(vm.item)
        }
        items.remove(atOffsets: indexSet)
    }
}
