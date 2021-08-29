//
//  ComicDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicDetailView: View {
    let comic: ComicResponse
    var imageURL = ""
    
    init(_ comic: ComicResponse) {
        self.comic = comic
        
        for image in comic.imgs {
            imageURL = image.sourceUrl
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imageView(url: imageURL)
                ComicDescription(comic: comic)
            }
        }
        .padding(.vertical)
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarItems(trailing: CustomButtons(comic: comic, imageURL: imageURL))
    }
    
    @ViewBuilder
    private func imageView(url: String) -> some View {
        AsyncImage(url: URL(string: url)!, placeholder: loadingView) { image in
            Image(uiImage: image)
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 15)
        .pinchToZoom()
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
    
    private var title: String {
        "\(comic.id): " + comic.title
    }
}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComicDetailView(ComicResponse.example)
        }
    }
}