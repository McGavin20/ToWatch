//
//  ToWatchApp.swift
//  ToWatch
//
//  Created by Sharma McGavin on 03/03/2023.
//

import SwiftUI

@main
struct ToWatchApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
