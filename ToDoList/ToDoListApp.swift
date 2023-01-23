//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by IKAKOOO on 18.01.23.
//

import SwiftUI

@main
struct ToDoListApp: App {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
