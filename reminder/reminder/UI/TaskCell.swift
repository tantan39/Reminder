//
//  TaskCell.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI
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

struct TaskCell: View {
    @ObservedObject var viewModel: TaskCellViewModel
    var onCommit: (Result<Task, InputError>) -> Void = { _ in }
    var body: some View {
        HStack {
            Image(systemName: viewModel.iconName)
                .foregroundColor(.gray)
            TextField("Enter task title", text: $viewModel.item.title) {
                if !self.viewModel.item.title.isEmpty {
                    onCommit(.success(viewModel.item))
                } else {
                    onCommit(.failure(.empty))
                }
            }
            .id(viewModel.id)
            Spacer()
            Button {
                viewModel.item.completed.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }

        }
    }
}

enum InputError: Error {
  case empty
}
