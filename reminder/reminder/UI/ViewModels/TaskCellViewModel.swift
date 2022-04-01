//
//  TaskCellViewModel.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Combine
import Resolver

class TaskCellViewModel: ObservableObject, Identifiable {
    var id: String = ""
    @Injected var repository: TaskRepository
    
    @Published var item: Task
    @Published var iconName: String = ""
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(task: Task) {
        self.item = task
        
        $item
            .map { $0.completed ? "checkmark.circle" : "circle"}
            .assign(to: \.iconName, on: self)
            .store(in: &cancellabels)
        
        $item
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellabels)
        
        $item
            .dropFirst()
            .sink { task in
                self.repository.updateTask(task)
            }
            .store(in: &cancellabels)
    }
}
