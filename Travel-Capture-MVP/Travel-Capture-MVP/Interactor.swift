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
    var fetchResult: PHFetchResult<PHAsset>?
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
        
        // TODO: 지금까지 찍혔던 사진 앨범으로 만들어서 저장
        createAlbum()
        
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
        self.fetchResult = fetchResult
        
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
    
    private func createAlbum() {
        let albumName = self.title + "\(self.startDate.description)"
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(
                withTitle: albumName
            )
        } completionHandler: { isSuccess, error in
            if isSuccess {
                print("앨범 생성 성공")
                self.appendToAlbum(albumName)
            } else {
                print("앨범 생성 실패: \(error)")
            }
        }
    }
    
    private func appendToAlbum(_ albumName: String) {
        
        let fetchOptions = PHFetchOptions()
           fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
           let collection = PHAssetCollection.fetchAssetCollections(
               with: .album, subtype: .any, options: fetchOptions
           )
        
        if let album = collection.firstObject,
           let fetchResult = fetchResult {
            PHPhotoLibrary.shared().performChanges {
                let request = PHAssetCollectionChangeRequest(for: album)
                request?.addAssets(fetchResult)
                self.fetchResult = nil
                self.images.removeAll()
                self.title = ""
            } completionHandler: { isSuccess, error in
                if isSuccess {
                    print("앨범에 넣기 완료")
                } else {
                    print("앨범에 넣기 실패: \(error)")
                }
            }
        } else {
            print("앨범 찾기 실패")
        }
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
