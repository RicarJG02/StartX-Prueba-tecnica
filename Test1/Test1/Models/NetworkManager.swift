//
//  NetworkManager.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 31/3/23.
//

import Foundation

class NetworkManager {
    
    let baseEndpoint = "http://www.omdbapi.com"
    let omdbApiKey = "e4b81b6"
    
    func searchMovies(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseEndpoint)?s=\(query)&apikey=\(omdbApiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrlString(urlString)))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noDataReturned))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(SearchResponse.self, from: data)
                completion(.success(response.search))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchDetails(for imdbId: String, completion: @escaping (Result<DetailResponse, Error>) -> Void) {
        let urlString = "\(baseEndpoint)?i=\(imdbId)&apikey=\(omdbApiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrlString(urlString)))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noDataReturned))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(DetailResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovieDetails(for imdbId: String, completion: @escaping (Result<DetailResponse, Error>) -> Void) {
        fetchDetails(for: imdbId) { (result) in
            switch result {
            case .success(let detailResponse):
                completion(.success(detailResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidUrlString(String)
    case noDataReturned
}
