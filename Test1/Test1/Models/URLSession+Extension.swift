//
//  Extension.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import Foundation

extension URLSession {
    func detailTask(with imdbID: String, completionHandler: @escaping (Result<DetailResponse, Error>) -> Void) -> URLSessionDataTask {
        let url = URL(string: "https://www.omdbapi.com/?i=\(imdbID)&apikey=e4b81b6")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let details = try decoder.decode(DetailResponse.self, from: data)
                completionHandler(.success(details))
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        return task
    }
}
