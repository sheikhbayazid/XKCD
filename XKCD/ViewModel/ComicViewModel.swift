//
//  ComicViewModel.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import Combine
import SwiftUI
import Foundation

enum Sort: Int, Identifiable, CaseIterable {
    case latest
    case earliest
    
    var id: Int { rawValue }
}

final class ComicViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var comics = [ComicResponse]()
    @AppStorage("totalComics") private(set) var comicCount = 2508
    
    @Published private(set) var serverError = false
    lazy var totalComics = Array(stride(from: comicCount, to: 1, by: -1))
    
    @Published var searchText = ""
    @Published var sort: Sort = .latest
    
    init() {
        fetchAllComics()
        
        $sort
            .receive(on: RunLoop.main)
            .sink { sort in
                switch sort {
                case .latest:
                    self.totalComics = Array(stride(from: self.comicCount, to: 1, by: -1))
                case .earliest:
                    self.totalComics = Array(1...self.comicCount)
                }
            }
            .store(in: &cancellables)
    }
    
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
