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

struct Article: Codable {
    let title: String
    let description: String?
}

