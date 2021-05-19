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
        ComicCellView(comic: comic)
            .onAppear (perform: loadComic)
        
    }
    
    
    func loadComic() {
        fetchData(for: comicNumber)
    }
    
    
    func fetchData(for number: Int) {
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode(Comic.self, from: data)
                        DispatchQueue.main.async {
                            print(decodedData)
                            self.comic = decodedData
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(comicNumber: 2)
    }
}
