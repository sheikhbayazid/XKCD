//
//  BrowseComicsView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/22/21.
//

import SwiftUI

struct BrowseComicsView: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var filteredComics: [ReversedCollection<[ComicResponse]>.Element] {
        let reversedFilterComics = viewModel.comicResponses.sorted().reversed()
            .filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) || String($0.alt.lowercased()).contains((viewModel.searchText.lowercased())) || String($0.transcript.lowercased()).contains((viewModel.searchText.lowercased()))
            }) // Latest comics - Reversed & filtered by title, id, alt and transcript
        
        let nonReversedFilteredComics = viewModel.comicResponses.sorted()
            .filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) || String($0.alt.lowercased()).contains((viewModel.searchText.lowercased())) || String($0.transcript.lowercased()).contains((viewModel.searchText.lowercased()))
            }) // Earliest comics - Non-reversed & filtered by title, id, alt and transcript
        
        if viewModel.sort == 0 {
            return reversedFilterComics
        } else {
            return nonReversedFilteredComics
        }
    }
    
    var body: some View {
        ForEach(filteredComics) { comic in
            NavigationLink(
                destination: BrowseComicDetailView(comic: comic) ,
                
                label: {
                    ImageView(comic: comic)
                }
            )
        }
    }
}

struct BrowseComicsView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseComicsView(viewModel: ComicViewModel())
    }
}

fileprivate struct ImageView: View {
    let comic: ReversedCollection<[ComicResponse]>.Element
    
    var body: some View {
        AsyncImage(url: URL(string: getImageURL(imgs: comic.imgs))!, placeholder: { Color.gray.opacity(0.15)
            
        }) { image in
            Image(uiImage: image)
                .resizable()
        }.aspectRatio(contentMode: .fit)
        // .frame(maxWidth: Screen.width / 3 - 10)
        .overlay(
            Text("\(comic.id)")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.gray.opacity(0.75))
                .clipShape(Capsule())
                .padding(5),
            alignment: .topLeading
        )
    }
    
    func getImageURL(imgs: [ImageDetails]) -> String {
        var imageURL = ""
        
        for image in imgs {
            imageURL = image.sourceUrl
        }
        return imageURL
    }
}
