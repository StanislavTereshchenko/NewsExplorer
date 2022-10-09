//
//  ArticleDetailsViewController.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 03.10.2022.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    
    var articles: Article!
    //var sour
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArticleDetailsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ArticleDetailsTableViewCellIdn")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 350
        
        
        
        
    }
    
    @objc func openLink() {
        if let urlToOpen = URL(string: articles.url!) {
            UIApplication.shared.open(urlToOpen, options: [:]) { (done) in
                print("Link was opened successfully")
            }
        }
    }
}

extension ArticleDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ArticleDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDetailsTableViewCellIdn") as?
        ArticleDetailsTableViewCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(ArticleDetailsViewController.openLink))
        cell?.articleTitleLabel.text = articles.title
        
        var contentString = "\(articles.content ?? "nil")"
        if  (contentString == "nil") {
            
            contentString = articles.description ?? ""
        }
        else {
            contentString.removeLast(13)
        }
        
        var publishedString = "\(articles.publishedAt ?? "nil")"
        if (publishedString == "nil") {
            publishedString = " "
        } else {
            publishedString.removeLast(10)
        }
        
        cell?.articleDescriptionLabel.text = "\(contentString)"
        cell?.articleLinkLabel.text = "More info info on the link below \n \(articles.url!)"
        cell?.articleLinkLabel.isUserInteractionEnabled = true
        cell?.articleLinkLabel.addGestureRecognizer(tap)
        cell?.articleImageView.downloaded(from: articles.urlToImage ?? "")
        cell?.authorAndSourcesLabel.text = "Author: \(articles.author ?? "") \(articles.source.name ?? "")"
        cell?.bublishedAtLabel.text = "Published: \(publishedString)"
        return cell ?? UITableViewCell()
    }
    
    
    
}
