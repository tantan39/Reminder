//
//  TaskCell.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI
import Combine

struct TaskCell: View {
    @ObservedObject var viewModel: TaskCellViewModel
    var onCommit: (Result<Task, InputError>) -> Void = { _ in }
    var body: some View {
        HStack {
            Image(systemName: viewModel.iconName)
                .foregroundColor(.gray)
                .onTapGesture {
                    viewModel.item.completed.toggle()
                }
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
