//
//  NetworkManager.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 03.10.2022.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=4ea7896ed183482cb7edd70e47cc3f91")
        
        static let searchUrl = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=4ea7896ed183482cb7edd70e47cc3f91&q="
        
    }
    
    private init() {}
    
    
    public func getTopNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIRespons.self, from: data)
                    
                    print("ARTICLES: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        let urlString = Constants.searchUrl + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIRespons.self, from: data)
                    
                    print("ARTICLES: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func getFilteredDay(with query: String, with scope: Int, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = Calendar.current.date(byAdding: .day, value: -scope, to: date)
        
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(query)&from=\(dateFormatter.string(from: day!))&to=\(dateFormatter.string(from: date))&sortBy=relevancy&apiKey=4ea7896ed183482cb7edd70e47cc3f91") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIRespons.self, from: data)
                    
                    print("ARTICLES: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
        
    }
}

