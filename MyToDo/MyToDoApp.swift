//
//  MyToDoApp.swift
//  MyToDo
//
//  Created by João Moreira on 14/06/2023.
//

import SwiftUI
import SwiftData

@main
struct MyToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDoItem.self)
        }
    }
}
