//
//  Article.swift
//  News_RxSwift
//
//  Created by Sai Raghu Varma Kallepalli on 16/8/20.
//  Copyright © 2020 Sai Raghu Varma Kallepalli. All rights reserved.
//

import Foundation

struct ArticleList: Codable {
    let status: String
    let articles: [Article]
}

extension ArticleList {
    static var all: Resource<ArticleList> = {
       let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=fe0504e965a0499aa62fb17ebd9571b3")!
        return Resource(url: url)
    }()
}

struct Article: Codable {
    let title: String
    let description: String?
}

