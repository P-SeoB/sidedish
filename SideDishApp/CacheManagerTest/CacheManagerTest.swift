//
//  CacheManagerTest.swift
//  CacheManagerTest
//
//  Created by 박진섭 on 2022/05/19.
//

import XCTest

class CacheManagerTest: XCTestCase {
    
    var sut: MockCacheManagerWrapper<MockCacheManager>!
    
    var mockCacheManager: MockCacheManager!
    let mockURL = URL(string: "www.naver.com/park")!
    let mockData = NSString(stringLiteral: "park")
    var cacheKey: NSString = ""
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCacheManager = MockCacheManager()
        cacheKey = mockURL.lastPathComponent as NSString
        
        sut = MockCacheManagerWrapper(cacheManger: mockCacheManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockCacheManager = nil
        try super.tearDownWithError()
    }

    func testMemoryCheckCache() {
        // given
        mockCacheManager.cache.setObject(mockData, forKey: cacheKey)
        
        // when
        let cachedData = sut.checkCache(url: mockURL)
        
        // then
        XCTAssertEqual(mockData, cachedData)
    }
    
    func testDiskCheckCache() {
        // given
        let fileManager = FileManager()
        
        guard var path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        path.appendPathComponent(mockURL.lastPathComponent)
        
        if fileManager.fileExists(atPath: path.path) {  // if file already exist, remove that
            try? fileManager.removeItem(at: path)
        }

        let fileText = NSString(string: "plz")
        try? fileText.write(to: path, atomically: true, encoding: String.Encoding.utf8.rawValue)

        // when
        let cachedData = sut.checkCache(url: mockURL) // data in Disk
        let expectedData = MockCacheManager.CachedData(stringLiteral: "plz") // expected Data

        // then
        XCTAssertEqual(cachedData, expectedData)
    }
    
    
    func testCheckMemoryCache() {
        
        // when
        sut.setMemoryCache(url: mockURL, data: mockData)
        let cachedData = mockCacheManager.cache.object(forKey: cacheKey)
        
        // then
        XCTAssertEqual(mockData, cachedData)
    }
    
}
