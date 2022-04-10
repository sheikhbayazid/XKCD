//
//  ComicDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicDetailView: View {
    private var imageURL = ""
    let comic: ComicResponse
    
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
                    .padding(.top, 16)
                ComicDescription(comic: comic)
            }
        }
        .padding(.vertical)
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarItems(trailing: QuickActionButtons(comic: comic, imageURL: imageURL))
    }
}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComicDetailView(ComicResponse.example)
        }
    }
}

extension ComicDetailView {
    
    private var title: String {
        "\(comic.id): " + comic.title
    }
}
