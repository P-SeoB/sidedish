//
//  MockCacheManager.swift
//  RepositoryTest
//
//  Created by 박진섭 on 2022/05/19.
//

import Foundation

final class MockCacheManager: CacheManagable {
    
    typealias CachedData = NSString
    
    var checkCacheIsCalled: Bool = false
    var setMemoryCacheIsCalled: Bool = false
    
    let cache = NSCache<NSString, CachedData>()
    
    func checkCache(url: URL) -> CachedData? {
        self.checkCacheIsCalled = true
        return nil
    }
    
    func setMemoryCache(url: URL, data: CachedData) {
        self.setMemoryCacheIsCalled = true
    }
}
