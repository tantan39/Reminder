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

class LocalTaskRepository: BaseTaskRepository, TaskRepository {
    private var storeURL: URL
    
    init(storeUrl: URL) {
        self.storeURL = storeUrl
        
        super.init()
        self.tasks = retrieve()
    }
    
    func addTask(_ task: Task) {
        self.tasks.append(task)
        save()
    }
    
    func removeTask(_ task: Task) {
        if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
            self.tasks.remove(at: index)
            save()
        }
    }
    
    func updateTask(_ task: Task) {
        if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
            self.tasks[index] = task
            save()
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(self.tasks)
            try? data.write(to: self.storeURL)
        } catch {
            fatalError("Can't save data")
        }
    }
    
    private func retrieve() -> [Task] {
        guard let data = try? Data(contentsOf: self.storeURL) else { return [] }
        let tasks = try? JSONDecoder().decode([Task].self, from: data)
        return tasks ?? []
    }
}
