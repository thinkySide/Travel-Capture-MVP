//
//  Interactor.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import UIKit

@Observable
final class Interactor {
    
    var isTracking = false
    var title: String = ""
    var images: [UIImage] = []
    
    init(isTracking: Bool = false, title: String = "", images: [UIImage] = []) {
        self.isTracking = isTracking
        self.title = title
        self.images = images
    }
}
