//
//  RepositroyWrapper.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/05/19.
//

import Foundation

struct RepositoryWrapper<T: Repositoriable> {
    
    var repository: T?
    
    init(repository: T) {
        self.repository = repository
    }
    
    func fetchData<T: Codable>(endpoint: Endpointable, decodeType: T.Type, onCompleted: @escaping(T?) -> Void)  {
        repository?.fetchData(endpoint: endpoint, decodeType: decodeType, onCompleted: onCompleted)
    }
}
