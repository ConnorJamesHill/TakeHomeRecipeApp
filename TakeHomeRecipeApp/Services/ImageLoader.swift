// this file is used fo image loading. since it can be more time consuming for images, i made it so that we can save the images to the device to more consistently be quickly loaded!

// actor is used so that there is thread safety which

// singleton structure is used because we only need one instance of this to be shared throughout the app

// * 1: Check memory cache, if it's there, go ahead and download it and be done.

// * 2: Check disk cache, if it's there, go ahead and download it and be done.

// * 3: We can safely assume we're going to do it the old fashioned way now, we'll have to download the image. we start by creating the url which is passed into the function

// * 4: grab the image using an api call and our url and pull that image into a data variable. then create an image using that data

// * 5: Save the image we grabbed to memory and disk cache so that we can get the image more consistently next time!

import Foundation
import SwiftUI

actor ImageLoader {
    public static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    public init() {}
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("recipe-images")
    }
    
    public func loadImage(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)
// * 1
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
// * 2
        if let diskCachedImage = try? await loadImageFromDisk(urlString) {
            cache.setObject(diskCachedImage, forKey: cacheKey)
            return diskCachedImage
        }
        
// * 3
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
// * 4
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidResponse
        }
        
// * 5
        cache.setObject(image, forKey: cacheKey)
        try? await saveImageToDisk(image, urlString: urlString)
        
        return image
    }
    
    private func loadImageFromDisk(_ urlString: String) async throws -> UIImage? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        let imagePath = cacheDirectory.appendingPathComponent(urlString.hash.description)
        
        guard fileManager.fileExists(atPath: imagePath.path) else { return nil }
        let data = try Data(contentsOf: imagePath)
        return UIImage(data: data)
    }
    
    private func saveImageToDisk(_ image: UIImage, urlString: String) async throws {
        guard let cacheDirectory = cacheDirectory else { return }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        let imagePath = cacheDirectory.appendingPathComponent(urlString.hash.description)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try data.write(to: imagePath)
    }
} 
