//
//  ComicCellView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    @Environment(\.managedObjectContext) private var moc
    
    var loadedImage: some View {
        AsyncImage(url: URL(string: comic.img)!, placeholder: { Color.gray.opacity(0.15) }) { image in
            
            Image(uiImage: image)
                .resizable()
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            if !comic.img.isEmpty {
                loadedImage
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(5)
                    .frame(maxWidth: Screen.width) // , maxHeight: Screen.height * 0.6
                    .pinchToZoom()
                //                    .onTapGesture(count: 2) {
                //                        withAnimation(.spring()) {
                //                            isFavorite = true
                //                        }
                //                    }
                
                ComicCellDetailView(comic: comic)
                    .environment(\.managedObjectContext, self.moc)
                
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
