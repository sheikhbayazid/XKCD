//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import Foundation
import SwiftUI

enum Sort: Int, Identifiable, CaseIterable {
    case latest
    case earliest
    
    var id: Int { rawValue }
}

final class ComicViewModel: ObservableObject {
    @Published private(set) var comics = [ComicResponse]()
    @AppStorage("totalComics") private(set) var comicCount = 2508
    @Published private(set) var serverError = false
    
    @Published var searchText = ""
    @Published var sort: Sort = .latest
    
    init() { fetchAllComics() }
    
    func fetchAllComics() {
        NetworkManager.shared.fetchData(endpoint: .allComics, type: [ComicResponse].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comics):
                    self.comics = comics
                    self.comicCount = comics.count + 4
                    // We get -4 items from this endpoint compared to actual total items. So adding 4
                    
                case .failure(let error):
                    print(error)
                    self.serverError = true
                }
            }
        }
    }
    
    lazy var totalComics: [Int] = {
        if sort == .latest {
            return Array(stride(from: comicCount, to: 1, by: -1))
        } else if sort == .earliest {
            return Array(1...comicCount)
        }
        return Array(stride(from: comicCount, to: 1, by: -1))
    }()
    
    // TabBar Items
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
