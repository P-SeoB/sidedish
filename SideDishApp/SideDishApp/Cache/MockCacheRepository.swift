//
//  MockCacheRepository.swift
//  RepositoryTest
//
//  Created by 박진섭 on 2022/05/19.
//

import Foundation

struct MockCacheRepository: Repositoriable {
    
    typealias CacheManager = MockCacheManager
    
    // NetworkManagable를 채택한 NetworkManager가 어떤 것일지에 따라 request가 달라짐.
    var networkManager: NetworkManagable?
    var cacheManager: CacheManager?
    
    init(networkManager: NetworkManagable, cacheManager: CacheManager? = nil) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
    
    func fetchData<T: Codable>(endpoint: Endpointable,
                      decodeType: T.Type,
                      onCompleted: @escaping (T?) -> Void)  {
        guard let url = endpoint.getURL() else { return }
        
        cacheManager?.checkCache(url: url)
        
        networkManager?.request(endpoint: endpoint, completion: { (result: Result<T?, NetworkError>) in
            switch result {
            case .success(let success):
                if let data = success as? CacheManager.CachedData {
                    cacheManager?.setMemoryCache(url: url, data: data)
                }
                
            case .failure(let error):
                break
                }
            }
        )
    }
}
