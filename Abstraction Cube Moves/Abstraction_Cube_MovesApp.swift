//
//  Abstraction_Cube_MovesApp.swift
//  Abstraction Cube Moves

import SwiftUI

@main
struct Abstraction_Cube_MovesApp: App {
    @UIApplicationDelegateAdaptor(AbstractCubeAppDelegate.self) private var appDelegate
    
    
    
    var body: some Scene {
        WindowGroup {
            AbstractCubeGameInitialView()
        }
    }
}
