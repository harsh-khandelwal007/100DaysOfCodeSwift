//
//  unitConversionApp.swift
//  unitConversion
//
//  Created by harsh Khandelwal on 26/09/21.
//

import SwiftUI

@main
struct unitConversionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
