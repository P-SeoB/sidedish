//
//  MockCacheManagerWrapper.swift
//  CacheManagerTest
//
//  Created by 박진섭 on 2022/05/19.
//

import Foundation

struct MockCacheManagerWrapper<C: CacheManagable> {
    
    let cacheManager: C?
    
    init(cacheManger:C) {
        self.cacheManager = cacheManger
    }
    
    
    func checkCache(url:URL) -> C.CachedData? {
        cacheManager?.checkCache(url: url)
    }
    
    func setMemoryCache(url: URL, data: C.CachedData) {
        cacheManager?.setMemoryCache(url: url, data: data)
    }
}
 
