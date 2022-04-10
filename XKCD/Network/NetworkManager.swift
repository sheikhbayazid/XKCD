//
//  NetworkManager.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 29/8/21.
//

import Foundation

enum Endpoint {
    case allComics
    case singleComic(Int)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchData<T: Decodable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var urlString = ""
        
        switch endpoint {
        case .allComics:
            urlString = "https://api.xkcdy.com/comics"
        case .singleComic(let comicNo):
            urlString = "https://xkcd.com/\(comicNo)/info.0.json"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, _, error in
            
            if let error = error {
                print("Error loading data from \(url): \(String(describing: error))")
                return
            }
            
            if let data = data {
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
