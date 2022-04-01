//
//  FireStoreTaskRepository.swift
//  reminder
//
//  Created by Tan Tan on 4/1/22.
//

import Foundation
import FirebaseFirestore
import Resolver
import Combine

class FireStoreTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    @Injected var authenticationService: AuthenticationService
    private var db = Firestore.firestore()
    private var taskPath = "tasks"
    private var userID = "anonymous"
    private var cancellable = Set<AnyCancellable>()
    
    override init() {
        super.init()
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userID, on: self)
            .store(in: &cancellable)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
            }
            .store(in: &cancellable)
    }
    
    func addTask(_ task: Task) {
        do {
            var userTask = task
            userTask.userID = self.userID
            let _ = try db.collection("tasks").addDocument(from: userTask)
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
        db.collection("tasks")
            .whereField("userID", isEqualTo: self.userID)
            .order(by: "createdTime")
            .addSnapshotListener { querySnapshot, error in
            if let snapshot = querySnapshot {
                self.tasks = snapshot.documents.compactMap({ document in
                    try? document.data(as: Task.self)
                })
            }
        }
    }
}
