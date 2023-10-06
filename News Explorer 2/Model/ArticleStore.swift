//
//  ArticleStore.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//

import SwiftUI

class ArticleStore: ObservableObject {
    @Published var articles: [Article] = []
    
}
