//
//  Interactor.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import UIKit
import Photos

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
        requestPhotoAuth()
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
    
    func setup() {
        if isTracking {
            title = fetchTitle()
            startDate = fetchStartDate()
            fetchPhotos()
        }
    }
    
    func refresh() {
        fetchPhotos()
    }
}

// MARK: - Photos

extension Interactor {
    
    private func requestPhotoAuth() {
        Task {
            await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        }
    }
    
    private func fetchPhotos() {
        let predicate = NSPredicate(format: "creationDate > %@", startDate as NSDate)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = predicate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var newImages = [UIImage]()
        let imageManager = PHImageManager.default()
        
        fetchResult.enumerateObjects { asset, _, _ in
            imageManager.requestImage(
                for: asset,
                targetSize: .init(width: 200, height: 200),
                contentMode: .aspectFill,
                options: nil,
                resultHandler: { image, _ in
                    if let image = image {
                        newImages.append(image)
                    }
                }
            )
        }
        
        print("새롭게 생성된 이미지 개수: \(newImages.count)")
        images = newImages
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
