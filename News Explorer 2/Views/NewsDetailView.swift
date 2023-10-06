//
//  NewsDetailView.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 04.10.2023.
//

import SwiftUI

struct NewsDetailView: View {
    let article: Article
    var body: some View {
        NavigationView {
            VStack {
                VStack {
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
                                .scaledToFill()
                                .frame(maxHeight: 361)
                                .padding(.top, 0)
                            
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
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 25) {
                        Text(article.title)
                            .font(.custom("SFPRODISPLAYBOLD", size: 35))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 10)
                        
                        Text(article.descriptionText)
                            .font(.custom("SFPRODISPLAYREGULAR", size: 25))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        Text("\(article.captionText)\n\(article.authorText)")
                            .font(.custom("SFPRODISPLAYREGULAR", size: 17))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                    }
                    
                }
                
            }
            .ignoresSafeArea()
        }
        
    }
}
        

