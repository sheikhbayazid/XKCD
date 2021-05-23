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
            Spacer()
            
            ImageView(url: imageURL)
            
            BrowseComicDetails(comic: comic)
            
        }
        .padding(.vertical)
        .navigationBarTitle(Text("\(comic.id): " + comic.title), displayMode: .inline)
        .navigationBarItems(trailing: NavBarButtonsView(comic: comic, imageURL: imageURL) )
    }
    
}

struct BrowseComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseComicDetailView(comic: ComicResponse.example)
        }
    }
}



fileprivate struct ImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)!, placeholder: {
            ZStack {
                Color.gray.opacity(0.15)
                ProgressView()
            }
            
        }) { image in
            Image(uiImage: image)
                .resizable()
        }.aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pinchToZoom()
    }
}
