//
//  ArticleTableViewCell.swift
//  News_RxSwift
//
//  Created by Sai Raghu Varma Kallepalli on 20/8/20.
//  Copyright © 2020 Sai Raghu Varma Kallepalli. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dec: UILabel!
    
    func updateCell(_ article: Article) {
        title.text = article.title
        dec.text = article.description
    }

}
