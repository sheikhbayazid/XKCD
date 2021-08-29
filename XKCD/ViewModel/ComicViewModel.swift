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
    @AppStorage("totalComics") private(set) var totalComics = 2508
    
    @Published var searchText = ""
    @Published var sort: Sort = .latest
    
    @Published private(set) var serverError = false
    
    init() { fetchAllComics() }
    
    func fetchAllComics() {
        NetworkManager.shared.fetchData(endpoint: .allComics, type: [ComicResponse].self) { result in
            switch result {
            case .success(let comics):
                DispatchQueue.main.async {
                    self.comics = comics
                    self.totalComics = comics.count + 4
                    // We get -4 items from this endpoint compared to actual total items. So adding 4
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.serverError = true
                }
            }
        }
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
