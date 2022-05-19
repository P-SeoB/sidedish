//
//  Repositoriable.swift
//  SideDishApp
//
//  Created by 박진섭 on 2022/05/19.
//

protocol Repositoriable {
    associatedtype CacheManager: CacheManagable = ImageCacheManager
    func fetchData<T: Codable>(endpoint: Endpointable, decodeType: T.Type, onCompleted: @escaping(T?) -> Void) 
}
