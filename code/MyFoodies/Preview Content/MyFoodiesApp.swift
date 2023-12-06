//
//  MyFoodiesApp.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import SwiftUI

@main
struct MyFoodiesApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

