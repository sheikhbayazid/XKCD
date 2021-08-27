//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import Foundation
import SwiftUI

class ComicViewModel: ObservableObject {
    @Published var comic = Comic.example
    @Published var comicResponses = [ComicResponse]()
    
    @AppStorage("totalComics") var totalComics = 2460 // Default Comic number before updating from the api
    @Published var searchText = ""
    @Published var sort: Int = 0
    @Published var serverError = false
    
    init() {
        self.comic = fetchComic(for: "") // Loading the latest comic number
        fetchAllComics()
    }
    
    // Fetch Comic by Number
    func fetchComic(for number: String) -> Comic {
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            print("Invalid URL")
            return comic
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, _, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode(Comic.self, from: data)
                        DispatchQueue.main.async {
                            self.comic = decodedData
                            
                            if number.isEmpty {
                                self.totalComics = decodedData.num
                                print("------------------------")
                                print("Latest Comic: \(decodedData.num)")
                                print("------------------------")
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
        
        return comic
    }
    
    // Fetch all the comics for the Browse View
    func fetchAllComics() {
        guard let url = URL(string: "https://api.xkcdy.com/comics") else { // https://xkcd.com/info.0.json
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, _, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode([ComicResponse].self, from: data)
                        DispatchQueue.main.async {
                            self.comicResponses = decodedData
                        }
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                            self.serverError = true
                        }
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - TabBar Items
    @ViewBuilder
    func home() -> some View {
        Group {
            Image(systemName: "rectangle.3.offgrid.bubble.left")
            Text("Comics")
        }
    }
    
    @ViewBuilder
    func browse() -> some View {
        Group {
            Image(systemName: "rectangle.and.text.magnifyingglass")
            Text("Browse")
        }
    }
    
    @ViewBuilder
    func favourites() -> some View {
        Group {
            Image(systemName: "heart.fill")
            Text("Favorites")
        }
    }
}
