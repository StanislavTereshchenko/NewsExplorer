//
//  Category.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}
extension Category: Identifiable {
    var id: Self { self }
}
