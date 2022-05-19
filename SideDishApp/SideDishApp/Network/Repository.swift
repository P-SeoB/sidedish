//
//  Repository.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/05/17.
//

import Foundation
import OSLog

struct Repository: Repositoriable {
    
    // NetworkManagable를 채택한 NetworkManager가 어떤 것일지에 따라 request가 달라짐.
    private var networkManager: NetworkManagable?
    
    //CacheManager는 있을수도 있고 없을 수도 있음.
    private var cacheManager: CacheManager?
    
    init(networkManager: NetworkManagable, cacheManager: CacheManager? = nil) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
    
    // request를 처리하고 성공했다면 Decoding된 데이터를 completionHandler에 담아서 보냄.
    func fetchData<T: Codable>(endpoint: Endpointable, decodeType: T.Type, onCompleted: @escaping(T?) -> Void) {
        guard let url = endpoint.getURL() else { return }
        
        // cache된 데이터가 있으면 처리함.
        if let cachedData = cacheManager?.checkCache(url: url) {
            onCompleted(cachedData as? T)
        }
        
        networkManager?.request(endpoint: endpoint, completion: { (result: Result<T?, NetworkError>) in
            switch result {
            case .success(let success):
                onCompleted(success)
                
                // 성공값이 CachedData가 될수 있다면.
                if let data = success as? CacheManager.CachedData {
                    cacheManager?.setMemoryCache(url: url, data: data)
                }
                
            case .failure(let error):
                os_log(.error, "\(error.localizedDescription)")
                }
            }
        )
    }
}
