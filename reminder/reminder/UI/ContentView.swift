//
//  ContentView.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI

struct ContentView: View {
    let storeUrl: URL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Reminder.json")
    
    var body: some View {
        TaskView(viewModel:
                    TasksViewModel(service:
                                    LocalTaskRepository(storeUrl:
                                                            storeUrl)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
