//
//  NewsAPI_Call.swift
//  News_RxSwift
//
//  Created by Sai Raghu Varma Kallepalli on 22/8/20.
//  Copyright © 2020 Sai Raghu Varma Kallepalli. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

//Chan
class NewsAPICall {
    
    static let instance = NewsAPICall()
    
    private let newsURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=fe0504e965a0499aa62fb17ebd9571b3")!
    
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
    
    //WORKING API CALL AND PARSING
    func fetchArticlesFromAPI() -> Observable<ArticleList> {
        let url = newsURL
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else { throw Error.invalidResponse(result.response) }
                return result.data
            }.map { data in
                do {
                    let posts = try JSONDecoder().decode(ArticleList.self, from: data)
                    return posts
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
}
