//
//  Model.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 03.10.2022.
//

import Foundation

struct APIRespons: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Codable {
    let name: String?
}
