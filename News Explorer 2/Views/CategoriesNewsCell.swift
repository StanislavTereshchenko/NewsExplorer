//
//  CategoriesNewsCell.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//

import SwiftUI

struct CategoriesNewsCell: View {
    let article: Article

    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: article.imageURL){ phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 120, height: 120)
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "Image")
                            .imageScale(.large)
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                HStack(spacing: 50) {
                    HStack(spacing: 8) {
                        Image("clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                        
                        Text(formatDate(article.publishedAt))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 8) {
                        Image("eye")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                        
                        Text("\(Int.random(in: 1000...5000))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 130)
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

