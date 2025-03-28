//
//  Travel_Capture_MVPApp.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import SwiftUI

@main
struct Travel_Capture_MVPApp: App {
    
    @State private var interactor = Interactor()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !interactor.isTracking {
                    StartView()
                } else {
                    TravelView()
                }
            }
            .environment(interactor)
        }
    }
}
