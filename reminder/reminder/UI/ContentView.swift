//
//  ContentView.swift
//  reminder
//
//  Created by Tan Tan on 3/31/22.
//

import SwiftUI
import Resolver

struct ContentView: View {
    var body: some View {
        TaskView(viewModel:
                    TasksViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            LocalTaskRepository() as TaskRepository
        }
        .scope(.application)
    }
}


