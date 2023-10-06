//
//  NewsAPI.swift
//  News Explorer
//
//  Created by Stanislav Tereshchenko on 05.10.2023.
//


import Foundation

struct NewsAPI {
    
    static let shared = NewsAPI()
    private init() {}
    
//    private let apiKey = "4ea7896ed183482cb7edd70e47cc3f91"
    private let apiKey = "81aaf25ff2d74f908c2710877d9555ef"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article] {
        let apiResponse = try await fetchArticles(from: generateNewsURL(from: category))
        return apiResponse 
    }
    
    func filter(for query: String, fromDate: String, toDate: String ) async throws -> [Article] {
        let apiResponse = try await fetchArticles(from: generateSearchURL(query: query, fromDate: fromDate, toDate: toDate))
        return apiResponse 
    }

    func search(for query: String) async throws -> [Article] {
        let apiResponse = try await fetchArticles(from: generateSearchURL(from: query))
        return apiResponse 
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
            
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "An error occured")
            }
        default:
            throw generateError(description: "A server error occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    private func generateSearchURL(query: String, fromDate: String, toDate: String) -> URL {
//        let apiKey = "4ea7896ed183482cb7edd70e47cc3f91"
        let apiKey = "81aaf25ff2d74f908c2710877d9555ef"
        let percentEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = "https://newsapi.org/v2/everything?"
        
        var components = URLComponents(string: url)!
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "q", value: percentEncodedQuery),
            URLQueryItem(name: "from", value: fromDate),
            URLQueryItem(name: "to", value: toDate),
            URLQueryItem(name: "sortBy", value: "popularity")
        ]
        
        return components.url!
    }
    
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
