//
//  ComicView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicView: View {
    let comicNumber: Int
    @State private var comic = Comic.example
    
    var body: some View {
        ComicItemView(comic: fetchComicData(for: comicNumber))
    }
    
    // Fetching data from this view uses less memory than using fetching functions from view model
    func fetchComicData(for number: Int) -> Comic {
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
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
        
        return comic
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(comicNumber: 2)
    }
}
