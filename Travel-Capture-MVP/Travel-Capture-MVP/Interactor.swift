//
//  Interactor.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import UIKit

@Observable
final class Interactor {
    
    var isTracking: Bool = false
    var title: String = ""
    var startDate: Date
    var images: [UIImage] = []
    
    init(
        title: String = "",
        startDate: Date = .now,
        images: [UIImage] = []
    ) {
        self.title = title
        self.images = images
        self.startDate = startDate
        self.isTracking = fetchIsTracking()
        if isTracking { setup() }
    }
}

// MARK: - UseCase

extension Interactor {
    
    func start() {
        isTracking = true
        saveIsTracking(isTracking)
        saveTitle(title)
        saveStartDate(.now)
    }
    
    func stop() {
        isTracking = false
        saveIsTracking(isTracking)
    }
}

// MARK: - Setting

extension Interactor {
    
    private func setup() {
        title = fetchTitle()
        startDate = fetchStartDate()
    }
}

// MARK: - UserDefaults

extension Interactor {
    
    private func fetchIsTracking() -> Bool {
        UserDefaults.standard.bool(forKey: "isTracking")
    }
    
    private func saveIsTracking(_ value: Bool) {
        UserDefaults.standard.set(isTracking, forKey: "isTracking")
    }
    
    private func fetchTitle() -> String {
        UserDefaults.standard.string(forKey: "title") ?? ""
    }
    
    private func saveTitle(_ value: String) {
        UserDefaults.standard.set(title, forKey: "title")
    }
    
    private func fetchStartDate() -> Date {
        UserDefaults.standard.object(forKey: "startDate") as? Date ?? .now
    }
    
    private func saveStartDate(_ value: Date) {
        UserDefaults.standard.set(startDate, forKey: "startDate")
    }
}
