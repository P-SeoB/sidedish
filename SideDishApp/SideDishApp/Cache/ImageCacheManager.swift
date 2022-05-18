//
//  ImageCacheManager.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/05/18.
//

import Foundation

struct ImageCacheManager: CacheManagable {
    
    typealias CachedData = NSData
    
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, CachedData>()

    func checkCache(url: URL) -> CachedData? {
        // CheckMemory
        if let imageNSData = findImageDataInMemoryCache(from: url) {
            return imageNSData
        }
        
        // CheckDisk
        if let imageNSData = findImageInDiskCache(from: url) {
            self.cache.setObject(imageNSData, forKey: url.lastPathComponent as NSString)
            return imageNSData
        }
        
        return nil
    }
    
    func setMemoryCache(url: URL, data: CachedData) {
        let imageName = url.lastPathComponent  // key
        self.cache.setObject(data, forKey: imageName as NSString)
    }
    
    private func findImageDataInMemoryCache(from url: URL) -> CachedData? {
        let cacheKey = NSString(string: url.lastPathComponent)
        let cachedImageData = self.cache.object(forKey: cacheKey)
        return cachedImageData
    }
    
    private func findImageInDiskCache(from url: URL) -> CachedData? {
        let fileManager = FileManager()
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: filePath.path) {
            let imageData = NSData(contentsOf: filePath)
            return imageData
        }
        return nil
    }
}
