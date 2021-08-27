//
//  ComicItemView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicItemView: View {
    let comic: Comic
    
    var loadedImage: some View {
        AsyncImage(url: URL(string: comic.img)!, placeholder: loadingView) { image in
            Image(uiImage: image)
                .resizable()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if !comic.img.isEmpty {
                loadedImage
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(5)
                    .frame(maxWidth: Screen.width)
                    .pinchToZoom()
                
                ComicLabelView(comic: comic)
                
                Divider()
            }
        }
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
}

struct ComicItemView_Previews: PreviewProvider {
    static var previews: some View {
        ComicItemView(comic: Comic.example)
    }
}
