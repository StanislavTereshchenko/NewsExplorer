//
//  ContentView.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 04.10.2023.
//

import SwiftUI
import Foundation

struct Articles: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let image: URL
}

struct ContentView: View {
    @ObservedObject var articleStore = ArticleStore()
    @ObservedObject var techArticleStore = ArticleStore()
    @State private var searchText = ""
    @State private var searchResults: [Article] = []
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
            ZStack {
                VStack {
                    Color(hex: "#151924")
                        .frame(maxHeight: 316)
                        .ignoresSafeArea()
                    Color.white
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()
                }
                VStack(spacing: 16) {
                    Text("Discover Breaking News")
                        .font(.custom("SFPRODISPLAYBOLD", size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 75)
                        .padding(.leading, -120)
                    
                    
                    SearchBarView(searchText: $searchText, onSearch: performSearch)
                        .frame(height: 44)
                        .padding(.horizontal, 16)
                    
                    
                    Text("Filter news by period")
                        .font(.custom("SFPRODISPLAYBOLD", size: 24))
                        .foregroundColor(.white)
                        .padding(.leading, -150)
                    ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        Button(action: {
                            if searchText == "" {
                                showingAlert = true
                            } else {
                                Task {
                                    do {
                                        let date = Date()
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let day = Calendar.current.date(byAdding: .day, value: -1, to: date)
                                        
                                        articleStore.articles = try await NewsAPI.shared.filter(for: searchText, fromDate: dateFormatter.string(from: day!), toDate: dateFormatter.string(from: date))
                                        
                                    } catch {
                                    }
                                }
                            }
                            
                        }) {
                            Text("Yesterday")
                                .foregroundColor(.white)
                                .frame(width: 135, height: 50)
                                .background(Color.clear)
                                .cornerRadius(150)
                        }
                        .alert("Empty Search Field\nPlease enter a search term.", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        Button(action: {
                            if searchText == "" {
                                showingAlert = true
                            } else {
                                Task {
                                    do {
                                        let date = Date()
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let day = Calendar.current.date(byAdding: .day, value: -3, to: date)
                                        
                                        articleStore.articles = try await NewsAPI.shared.filter(for: searchText, fromDate: dateFormatter.string(from: day!), toDate: dateFormatter.string(from: date))
                                        
                                    } catch {
                                    }
                                }
                            }
                            
                        }) {
                            Text("Last 3 Days")
                                .foregroundColor(.white)
                                .frame(width: 135, height: 50)
                                .background(Color.clear)
                        }
                        .alert("Empty Search Field\nPlease enter a search term.", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        Button(action: {
                            if searchText == "" {
                                showingAlert = true
                            } else {
                                Task {
                                    do {
                                        let date = Date()
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let day = Calendar.current.date(byAdding: .day, value: -7, to: date)
                                        
                                        articleStore.articles = try await NewsAPI.shared.filter(for: searchText, fromDate: dateFormatter.string(from: day!), toDate: dateFormatter.string(from: date))
                                        
                                    } catch {
                                    }
                                }
                            }
                        }) {
                            Text("Last Week")
                                .foregroundColor(.white)
                                .frame(width: 135, height: 50)
                                .background(Color.clear)
                        }
                        .alert("Empty Search Field\nPlease enter a search term.", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                }
                    ScrollView(.vertical, showsIndicators: false) {
                        if searchText == ""{
                            Text("Breaking News")
                                .font(.custom("SFPRODISPLAYREGULAR", size: 21))
                                .foregroundColor(.black)
                                .frame(width: 375, height: 50)
                                .background(.white)
                                .padding(.horizontal, 16)
                        } else if searchText.count > 11 {
                            
                        } else {
                            Text("Breaking News: \(searchText)")
                                .font(.custom("SFPRODISPLAYREGULAR", size: 21))
                                .foregroundColor(.black)
                                .frame(width: 375, height: 50)
                                .background(.white)
                                .padding(.horizontal, 16)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(articleStore.articles) { article in
                                    if article.title == "[Removed]" {
                                        
                                    } else {
                                        NavigationLink(destination: NewsDetailView(article: article)) {
                                            BreakingNewsCell(article: article)
                                                .padding(.top, 8)
                                                .padding(.bottom, 8)
                                        }
                                        .navigationBarTitle("", displayMode: .inline)
                                        
                                    }
                                    
                                    
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 270)
                        .onAppear(perform: {
                            Task {
                                do {
                                    articleStore.articles = try await NewsAPI.shared.fetch(from: .general)
                                } catch {
                                }
                            }
                        })
                        
                        Text("Category News")
                            .font(.custom("SFPRODISPLAYREGULAR", size: 21))
                            .frame(width: 170, height: 50)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(150)
                            .padding(.leading, -180)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .technology)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Technology")
                                        .foregroundColor(.black)
                                        .frame(width: 135, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                                
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .entertainment)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Entertainment")
                                        .foregroundColor(.black)
                                        .frame(width: 135, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .sports)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Sport")
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .science)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Science")
                                        .foregroundColor(.black)
                                        .frame(width: 100, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .health)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Health")
                                        .foregroundColor(.black)
                                        .frame(width: 90, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                                Button(action: {
                                    Task {
                                        do {
                                            techArticleStore.articles = try await NewsAPI.shared.fetch(from: .business)
                                        } catch {
                                            // Обробка помилок завантаження даних
                                        }
                                    }
                                }) {
                                    Text("Business")
                                        .foregroundColor(.black)
                                        .frame(width: 100, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 150)
                                                .stroke(Color.black, lineWidth: 4) // Межа кнопки
                                        )
                                        .background(Color.white)
                                        .cornerRadius(150)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(techArticleStore.articles) { article in
                                if article.title == "[Removed]" || article.imageURL == nil {
                                    
                                } else {
                                    NavigationLink(destination: NewsDetailView(article: article)) {
                                        CategoriesNewsCell(article: article)
                                            .frame(maxWidth: .infinity)
                                            .padding(.top, 8)
                                            .padding(.bottom, 8)
                                            .padding(.horizontal, 20)
                                    }
                                }
                                
                                
                            }
                            // Додайте вміст для collection view (вертикально) тут
                        }
                        .onAppear(perform: {
                            Task {
                                do {
                                    techArticleStore.articles = try await NewsAPI.shared.fetch(from: .technology)
                                } catch {
                                }
                            }
                        })
                        
                    }
                }
            }
        }
    }
    .accentColor(.white)
        
}
    private func performSearch() {
            Task {
                do {
                    searchResults = try await NewsAPI.shared.search(for: searchText)
                    articleStore.articles = searchResults
                    
                } catch {
                    // Обробка помилок пошуку
                }
            }
        }

}

#Preview {
    ContentView()
}

