//
//  TaskCellViewModel.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    var id: String = ""
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
            .map { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellabels)
    }
}
