//
//  BreakingNewsCell.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//

import SwiftUI

struct BreakingNewsCell: View {
    let article: Article
    
    var body: some View {
        VStack(spacing: 12) {
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
                        .frame(width: 236, height: 175)
                        .cornerRadius(8)
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
            if article.title == "[Removed]" || article.imageURL == nil {
                
            } else {
                Text(article.title)
                    .font(.custom("SFPRODISPLAYBOLD", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .multilineTextAlignment(.center)
                HStack(spacing: 80) {
                    HStack(spacing: 8) {
                        Image("clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                        
                        Text(formatDate(article.publishedAt))
                            .font(.caption)
                            .frame(width: 65)
                            .foregroundColor(.gray)
                        
                    }
                    HStack(spacing: 8) {
                        
                        Image("eye")
                            .resizable()
                            .frame(width: 15, height: 15) // Розмір ока
                            .foregroundColor(.gray)
                        
                        Text("\(Int.random(in: 1000...5000))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                }
            }
        }
        .frame(width: 260, height: 260)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
       
    }
     private func formatDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd.MM.yyyy"
         return dateFormatter.string(from: date)
     }
}
