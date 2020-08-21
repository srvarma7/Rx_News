//
//  URLRequest+Extension.swift
//  News_RxSwift
//
//  Created by Sai Raghu Varma Kallepalli on 22/8/20.
//  Copyright © 2020 Sai Raghu Varma Kallepalli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    
    static func load<T> (resource: Resource<T>) -> Observable<T?> {
        
        return Observable.from([resource.url])
            .flatMap{ url -> Observable<Data> in
                let req = URLRequest(url: url)
                return URLSession.shared.rx.data(request: req)
        }.map { data -> T? in
            return try? JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
}
