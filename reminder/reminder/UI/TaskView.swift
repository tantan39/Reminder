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
    @State var presentSignInView = false
    
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
                .emptyState($viewModel.items.isEmpty) {
                    VStack{
                        Spacer()
                        Text("No tasks")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Spacer()
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
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentSignInView = true
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    
                }
            })
            .sheet(isPresented: $presentSignInView, content: {
                SignInView()
            })
            .navigationTitle("Tasks")
        }
    }
}

struct TaskView_Preview: PreviewProvider {
    static var previews: some View {
        TaskView(viewModel: TasksViewModel())
    }
}
