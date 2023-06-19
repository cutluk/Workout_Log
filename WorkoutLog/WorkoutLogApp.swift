//
//  WorkoutLogApp.swift
//  WorkoutLog
//
//  Created by Luke Cutting on 6/17/23.
//

import SwiftUI

@main
struct WorkoutLogApp: App {
    var body: some Scene {
        WindowGroup {
            WorkoutsList(model: WorkoutsListModel())
        }
    }
}
