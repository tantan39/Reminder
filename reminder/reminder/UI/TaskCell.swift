//
//  TaskCell.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI

struct TaskCell: View {
    var item: Task
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.gray)
            Text(item.title)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }

        }
    }
}

