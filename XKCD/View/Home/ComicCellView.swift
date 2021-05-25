//
//  ComicCellView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    
    var loadedImage: some View {
        AsyncImage(url: URL(string: comic.img)!, placeholder: {
            ZStack {
                Color.gray.opacity(0.15)
                ProgressView()
            }
        }) { image in
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
                
                ComicCellDetailView(comic: comic)
                
                Divider()
            }
        }
    }
}

struct ComicCellView_Previews: PreviewProvider {
    static var previews: some View {
        ComicCellView(comic: Comic.example)
    }
}
