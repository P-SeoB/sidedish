//
//  MockCacheManager.swift
//  CacheManagerTest
//
//  Created by 박진섭 on 2022/05/19.
//

import Foundation

struct MockCacheManager: CacheManagable {
    typealias CachedData = NSString
    
    let cache = NSCache<NSString, CachedData>()
    
    func checkCache(url: URL) -> CachedData? {
        // CheckMemory
        if let data = findDataInMemoryCache(from: url) {
            return data
        }
        
        // CheckDisk
        if let data = findInDiskCache(from: url) {
            let cachedData = NSString(data: data as Data, encoding: .min)!
            self.cache.setObject(cachedData, forKey: url.lastPathComponent as NSString)
            return cachedData
        }
        
        return nil
    }
    
    func setMemoryCache(url: URL, data: CachedData) {
        let cacheKey = url.lastPathComponent  // key
        self.cache.setObject(data, forKey: cacheKey as NSString)
    }
    
    private func findDataInMemoryCache(from url: URL) -> CachedData? {
        let cacheKey = NSString(string: url.lastPathComponent)
        let cachedData = self.cache.object(forKey: cacheKey)
        return cachedData
    }
    
    private func findInDiskCache(from url: URL) -> NSData? {
        let fileManager = FileManager()
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: filePath.path) {
            let cachedData = NSData(contentsOf: filePath)
            return cachedData
        }
        return nil
    }

}
