//
//  RandomArtApp.swift
//  RandomArt
//
//  Created by Paweł Dera on 04/08/2021.
//

import SwiftUI

@main
struct InspiArt: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
