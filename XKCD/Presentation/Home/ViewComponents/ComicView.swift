//
//  ComicView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicView: View {
    @State private var comic: Comic = .example
    
    let comicNumber: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            
            Group {
                if !comic.img.isEmpty {
                    imageView()
                    ComicLabelView(comic: comic)
                    
                    Divider()
                }
            }
        }
        .onAppear(perform: loadComic)
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        AsyncImage(url: URL(string: comic.img)!, placeholder: loadingView) { image in
            Image(uiImage: image)
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
        .cornerRadius(5)
        .frame(maxWidth: Screen.width)
        .pinchToZoom()
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
    
    private func loadComic() {
        NetworkManager.shared.fetchData(endpoint: .singleComic(comicNumber), type: Comic.self) { result in
            
            switch result {
            case .success(let comic):
                self.comic = comic
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(comicNumber: 1)
    }
}
