//
//  AllArticleTableViewCell.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 03.10.2022.
//

import UIKit

class AllArticlesTableViewCellViewModel {
    let title: String
    let subtitle: String
    
    
    init(
        title: String,
        subtitle: String
    ){
        self.title = title
        self.subtitle = subtitle
        
        
    }
}

class AllArticleTableViewCell: UITableViewCell {
    
    static let identifier = "AllArticlesTableViewCelldn"
    
    private let allArticlesTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:120/255, green: 203/255, blue: 187/255, alpha: 1)
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura", size: 22)
        return label
    }()
    
    private let allArticlesSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura", size: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(allArticlesTitleLabel)
        contentView.addSubview(allArticlesSubtitleLabel)
    }
    
    required init?(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        allArticlesTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width,
            height: 70
        )
        
        allArticlesSubtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height/2
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        allArticlesTitleLabel.text = nil
        allArticlesSubtitleLabel.text = nil
        
    }
    
    func configure(with viewModel: AllArticlesTableViewCellViewModel) {
        allArticlesTitleLabel.text = viewModel.title
        allArticlesSubtitleLabel.text = viewModel.subtitle
        
        
    }
    
    
}
