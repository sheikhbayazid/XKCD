//
//  ComicDetailsView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct BrowseComicDetailView: View {
    let comic: ComicResponse
    var imageURL = ""
    
    init(comic: ComicResponse) {
        self.comic = comic
        
        for image in comic.imgs {
            imageURL = image.sourceUrl
        }
    }
    
    var body: some View {
        ScrollView {
            imageView(url: imageURL)
            BrowseComicDetails(comic: comic)
            
        }
        .padding(.vertical)
        .navigationBarTitle(Text("\(comic.id): " + comic.title), displayMode: .inline)
        .navigationBarItems(trailing: CustomButtons(comic: comic, imageURL: imageURL) )
    }
    
    private func imageView(url: String) -> some View {
        AsyncImage(url: URL(string: url)!, placeholder: loadingView) { image in
            Image(uiImage: image)
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pinchToZoom()
        .padding(.top, 15)
    }
    
    private func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
    
}

struct BrowseComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseComicDetailView(comic: ComicResponse.example)
        }
    }
}
