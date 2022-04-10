//
//  ComicsGridView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/22/21.
//

import SwiftUI

struct ComicsGridView: View {
    @State var viewModel: ComicViewModel
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(sortedFilteredComics) { comic in
                    NavigationLink(destination: ComicDetailView(comic)) {
                        imageView(url: getImageURL(comic.imgs))
                            .overlay(overlayLabel(comic.id), alignment: .topLeading)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func overlayLabel(_ comicID: Int) -> some View {
        Text(comicID.description)
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.gray.opacity(0.75))
            .clipShape(Capsule())
            .padding(5)
    }
    
    private func getImageURL(_ imgs: [ImageDetails]) -> String {
        var imageURL = ""
        
        for image in imgs {
            imageURL = image.sourceUrl
        }
        return imageURL
    }
    
    private var sortedFilteredComics: [ComicResponse] {
        
        if viewModel.sort == .latest {
            return getFilteredComics(isReversed: true)
        } else {
            return getFilteredComics()
        }
    }
    
    private func getFilteredComics(isReversed: Bool = false) -> [ComicResponse] {
        var comics = [ComicResponse]()
        
        if isReversed {
            comics = viewModel.comics.sorted().reversed()
        } else {
            comics = viewModel.comics.sorted()
        }
        
        return comics
            .filter({ viewModel.searchText.isEmpty ? true :
                $0.title.lowercased().contains(viewModel.searchText.lowercased()) ||
                String($0.id).contains((viewModel.searchText)) ||
                String($0.alt.lowercased()).contains((viewModel.searchText.lowercased())) ||
                String($0.transcript.lowercased()).contains((viewModel.searchText.lowercased()))
            })
    }
}

struct ComicsGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsGridView(viewModel: ComicViewModel())
    }
}
