//
//  RepositoryAPIClient.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 18.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit


protocol RepositoryAPIClientProtocol: class {
    
    func getRepositories(by repoName: String, page: Int) -> Result<SearchResult?, Error>?
}


class RepositoryAPIClient: RepositoryAPIClientProtocol {
    
    private init() {}
    
    static let shared = RepositoryAPIClient()
    
    func getRepositories(by repoName: String, page: Int) -> Result<SearchResult?, Error>? {
        
        let urlString = "https://api.github.com/search/repositories"
        var urlcomponets = URLComponents(string: urlString)
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "q", value: repoName))
        items.append(URLQueryItem(name: "page", value: String(page)))
        items.append(URLQueryItem(name: "per_page", value: "100"))
        items.append(URLQueryItem(name: "sort", value: "stars"))
        items.append(URLQueryItem(name: "order", value: "desc"))
        urlcomponets?.queryItems = items
        
        guard let url = urlcomponets?.url else {
            return .failure(APIError.brokenURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        var result: Result<SearchResult?, Error>?
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                result = .failure(error)
                semaphore.signal()
                return
            }
            
            guard let data = data else {
                result = .success(nil)
                semaphore.signal()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let repositories = try decoder.decode(SearchResult.self, from: data)
                result = .success(repositories)
            } catch let error {
                result = .failure(error)
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
    func getImage(with url: String?) -> UIImage? {
        var downloadTask: URLSessionDataTask!
        var image: UIImage?
        let semaphore = DispatchSemaphore(value: 0)
        if let urlString = url, let newURL = URL(string: urlString) {
            downloadTask = URLSession.shared.dataTask(with: newURL, completionHandler: { (data, response, error) in
                if let data = data {
                    image = UIImage(data: data)!
                }
                semaphore.signal()
            })
            downloadTask.resume()
        } else {
           semaphore.signal()
        }
        semaphore.wait()
        return image
    }
}

enum APIError: Error {
    case brokenURL
}

