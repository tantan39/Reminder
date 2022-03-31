//
//  TaskView.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import Foundation
import SwiftUI

enum TaskPriority {
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

struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var priority: TaskPriority
    var completed: Bool
}

struct TaskView: View {
    @ObservedObject var viewModel = TasksViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.items) { task in
                        TaskCell(item: task)
                    }
                }
                
                Button {
                    viewModel.items = mockTasks
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
        TaskView()
    }
}

