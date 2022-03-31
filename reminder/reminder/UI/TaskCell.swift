//
//  TaskCell.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI
import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    @Published var item: Task
    @Published var title: String = ""
    @Published var iconName: String = ""
    
    private var cancellabels = Set<AnyCancellable>()
    
    init(task: Task) {
        self.item = task
        
        $item
            .map { $0.completed ? "checkmark.circle" : "circle"}
            .assign(to: \.iconName, on: self)
            .store(in: &cancellabels)
        
        $item
            .map { $0.title }
            .assign(to: \.title, on: self)
            .store(in: &cancellabels)
    }
}

struct TaskCell: View {
    var viewModel: TaskCellViewModel
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.iconName)
                .foregroundColor(.gray)
            Text(viewModel.title)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }

        }
    }
}

