//
//  RepositoryTest.swift
//  RepositoryTest
//
//  Created by 박진섭 on 2022/05/19.
//

import XCTest

class RepositoryTest: XCTestCase {
    
    var sut: RepositoryWrapper<Repository>!
    var sut2: RepositoryWrapper<MockCacheRepository>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RepositoryWrapper(repository: Repository(networkManager: NetworkManager(session: .shared)))
        sut2 = RepositoryWrapper(repository: MockCacheRepository(networkManager: NetworkManager(session: .shared), cacheManager: MockCacheManager())
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFetchData()  {
            
        // MockData - detail
        guard let path = Bundle.main.path(forResource: "DetailMockData", ofType: "json"),
              let jsonString = try? String(contentsOfFile: path),
              let dishDetailMockdata = jsonString.data(using: .utf8) else {
            XCTFail("Mock Data Path Error")
            return
        }
        
        // expected Data
        guard let expectedDecodedDetail = try? JSONDecoder().decode(DetailDishInfo.self, from: dishDetailMockdata) else {
            XCTFail("Mock Data Decoding Error")
            return
        }
        
        // mockEndpoint
        let detailMockEndPoint = EndPointCase.getDetail(hash: "H1AA9").endpoint
        
        let expectation = XCTestExpectation(description: "loading~")
        
        sut.fetchData(endpoint: detailMockEndPoint,
                      decodeType: DetailDishInfo.self) { detailDishinfo in
            XCTAssertEqual(expectedDecodedDetail, detailDishinfo)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchDataWithCache()  {
        let mockEndpoint = EndPointCase.getImage(imagePath: "http://public.codesquad.kr/jk/storeapp/data/main/739_ZIP_P__D1.jpg").endpoint
        let mockDecodeType = Data.self
        
        sut2.fetchData(endpoint: mockEndpoint,
                       decodeType: mockDecodeType) { _ in
            let diskCacheIsCalled = self.sut2.repository?.cacheManager?.checkCacheIsCalled
            let memoryCacheIsCalled = self.sut2.repository?.cacheManager?.setMemoryCacheIsCalled
            
            XCTAssertTrue(diskCacheIsCalled ?? false)
            XCTAssertTrue(memoryCacheIsCalled ?? false)
        }
    }
}
