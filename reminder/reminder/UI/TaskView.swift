//
//  TaskView.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation
import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: TasksViewModel
    @State var presentAddNewItem = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.items) { task in
                        TaskCell(viewModel: task)
                    }
                    .onDelete { indexSet in
                        viewModel.removeTask(at: indexSet)
                    }
                    
                    if presentAddNewItem {
                        TaskCell(viewModel: TaskCellViewModel(task: Task(title: "", priority: .high, completed: false))) { result in
                            if let item = try? result.get() {
                                viewModel.addTask(item)
                            }
                            presentAddNewItem = false
                        }
                    }
                }
                
                Button {
                    presentAddNewItem = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("New task")
                    }
                    Spacer()
                }
                .padding()
                .accentColor(.red)
            }
            .navigationTitle("Tasks")
        }
    }
}

struct TaskView_Preview: PreviewProvider {
    static var previews: some View {
        TaskView(viewModel: TasksViewModel(service: LocalTaskRepository(storeUrl: URL(string: "")!)))
    }
}


