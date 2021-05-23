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
    @AppStorage("totalComics") var totalComics = 2460 // Default Comic number before updating from the api
    
    @Published var searchText = ""
    @Published var sort: Int = 0
    
    @Published var comicResponses = [ComicResponse]()
    @Published var serverError = false
    
    
    init() {
        self.comic = fetchComic(for: "") // Loading the latest comic number
        fetchAllComics()
        //fetchAllSingleComics()
    }
    
    // Fetch Comic by number
    func fetchComic(for number: String) -> Comic {
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            print("Invalid URL")
            return comic
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode(Comic.self, from: data)
                        DispatchQueue.main.async {
                            self.comic = decodedData
                            
                            if number.isEmpty {
                                self.totalComics = decodedData.num
                            }
                            
                            //print("--- Single Comic: \(decodedData)")
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
        
        return comic
    }
    
    // MARK: - Fetch all the comics for browse view
    func fetchAllComics() {
        guard let url = URL(string: "https://api.xkcdy.com/comics") else { // https://xkcd.com/info.0.json
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode([ComicResponse].self, from: data)
                        DispatchQueue.main.async {
                            self.comicResponses = decodedData
                            print("------------------------")
                            print(decodedData.count + 4) // Count is 4 less than the total comics. So added 4 to get the exact number
                            print("------------------------")
                            
                            //                            if self.totalComics < decodedData.count {
                            //                                self.totalComics = decodedData.count
                            //                                print("--- Total Comics: \(self.totalComics) ---")
                            //                            }
                            
                        }
                    } catch {
                        print(error)
                        self.serverError = true
                    }
                }
            }
        }
        task.resume()
    }
    
    
}
