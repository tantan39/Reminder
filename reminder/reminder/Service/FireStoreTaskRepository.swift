//
//  FireStoreTaskRepository.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import FirebaseFirestore

class FireStoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    var db = Firestore.firestore()
    
    override init() {
        super.init()
        loadData()
    }
    
    func addTask(_ task: Task) {
        do {
            let _ = try db.collection("tasks").addDocument(from: task)
        } catch {
            fatalError("add fail \(error.localizedDescription)")
        }
    }
    
    func removeTask(_ task: Task) {
        if let id = task.id {
            let _ = db.collection("tasks").document(id).delete()
        }
    }
    
    func updateTask(_ task: Task) {
        if let id = task.id {
            do {
            let _ = try db.collection("tasks").document(id).setData(from: task)
            } catch {
                fatalError("Update fail \(error.localizedDescription)")
            }
        }
    }
    
    private func loadData() {
        db.collection("tasks").order(by: "createdTime").addSnapshotListener { querySnapshot, error in
            if let snapshot = querySnapshot {
                self.tasks = snapshot.documents.compactMap({ document in
                    try? document.data(as: Task.self)
                })
            }
        }
    }
}
