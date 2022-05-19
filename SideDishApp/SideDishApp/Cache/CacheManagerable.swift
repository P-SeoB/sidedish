//
//  CacheManagerable.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/05/18.
//

import Foundation

protocol CacheManagable {
    associatedtype CachedData: NSObject
    
    func checkCache(url: URL) -> CachedData?
    func setMemoryCache(url: URL, data: CachedData)
}
