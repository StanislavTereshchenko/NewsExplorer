//
//  ArticleDetailsTableViewCell.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 04.10.2022.
//

import UIKit

class ArticleDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleLinkLabel: UILabel!
    @IBOutlet weak var authorAndSourcesLabel: UILabel!
    @IBOutlet weak var bublishedAtLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleTitleLabel.numberOfLines = 0
        articleTitleLabel.sizeToFit()
        
        
        articleLinkLabel.numberOfLines = 0
        articleLinkLabel.sizeToFit()
        
        articleDescriptionLabel.numberOfLines = 0
        articleDescriptionLabel.sizeToFit()
        
        authorAndSourcesLabel.numberOfLines = 0
        authorAndSourcesLabel.sizeToFit()
        
    }
    
}
