//
//  NewsTableVC.swift
//  News_RxSwift
//
//  Created by Sai Raghu Varma Kallepalli on 16/8/20.
//  Copyright © 2020 Sai Raghu Varma Kallepalli. All rights reserved.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

class NewsTableVC: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let newsURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=fe0504e965a0499aa62fb17ebd9571b3")!
    
    private var posts = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationItem.LargeTitleDisplayMode.automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        fetchNewsFromAPI()
        
        fetchArticlesFromAPI()
            .subscribe(onNext: { [weak self] result in
                self?.posts = result.articles
                self?.reload()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
        
        print("Application ready")
        
    }
    
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
    
    private func fetchNewsFromAPI() {
        Observable.just(newsURL)
            
            
            .map { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }
//        .map { result -> Data in
//                return try? JSONDecoder().decode([Article].self, from: result)
//            }
            .subscribe( onNext: { article in
                    print(article)
                }).disposed(by: disposeBag)
    }
    @IBAction func onReloadTapped(_ sender: Any) {
        reload()
    }
}

extension NewsTableVC {
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return posts.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ArticleTableViewCell else { return ArticleTableViewCell() }
        let article = posts[indexPath.row]
        cell.updateCell(article)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 1,
                delay: 0.5 * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
        
    }
    
    override func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
