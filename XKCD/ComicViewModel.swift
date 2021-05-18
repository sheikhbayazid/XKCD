//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import Foundation
import SwiftUI

class ComicViewModel: ObservableObject {
    @Published var comics = [Comic]()
    @Published var searchText = ""
    @AppStorage("totalComics") var totalComics = 2450 // Default Comic number before updating from the api
    
    
    @Published var comic = Comic.example
    @Published var comicResponse = [ComicResponse]()
    
    init() {
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
                            self.comicResponse = decodedData
                            print("--- \(decodedData.count) ---")
                            
                            if self.totalComics < decodedData.count {
                                self.totalComics = decodedData.count
                                print("--- Total Comics: \(self.totalComics) ---")
                            }
                            
                            
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    func fetchData(for number: Int) {
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode(Comic.self, from: data)
                        DispatchQueue.main.async {
                            self.comic = decodedData
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
}
