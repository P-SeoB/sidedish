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
        if let imageData = findCachedDataInMemoryCache(from: url) {
            return imageData
        }
        
        // CheckDisk
        if let imageNSData = findDataInDiskMemory(from: url) {
            //만약 Cache의 Value값이 NSData가 아닌 다른 값이라면 여기서 변환을 해서 넣어줌.
            self.cache.setObject(imageNSData, forKey: url.lastPathComponent as NSString)
            return imageNSData
        }
        
        return nil
    }
    
    func setMemoryCache(url: URL, data: CachedData) {
        let imageName = url.lastPathComponent  // key
        self.cache.setObject(data, forKey: imageName as NSString)
    }
    
    private func findCachedDataInMemoryCache(from url: URL) -> CachedData? {
        let cacheKey = NSString(string: url.lastPathComponent)
        let cachedImageData = self.cache.object(forKey: cacheKey)
        return cachedImageData
    }
    
    private func findDataInDiskMemory(from url: URL) -> NSData? {
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
