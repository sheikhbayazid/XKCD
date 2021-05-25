//
//  XKCDApp.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI

@main
struct XKCDApp: App {
    var body: some Scene {
        let persistenceController = PersistenceController.shared
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
