//
//  BrowseComicDetails.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct BrowseComicDetails: View {
    let comic: ComicResponse
    @State private var isSafariShowing = false
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Go to comic")
                
                Text(" explanation")
                    .fontWeight(.medium)
                    .underline()
                    .onTapGesture {
                        self.isSafariShowing = true
                    }
                
            }.font(.subheadline)
            .padding(.top, 2)
            .fullScreenCover(isPresented: $isSafariShowing) {
                SafariView(url: URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.id)")!)
                    .ignoresSafeArea()
                    .preferredColorScheme(.dark)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(comic.alt)
                        .font(.headline)
                    
                    if !comic.transcript.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Transcript:")
                                .fontWeight(.medium)
                                .font(.subheadline)
                            
                            Text("\(comic.transcript)")
                                .font(.subheadline)
                        }.foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.top)
            .padding(.horizontal)
        }
    }
}


struct BrowseComicDetails_Previews: PreviewProvider {
    static var previews: some View {
        BrowseComicDetails(comic: ComicResponse.example)
    }
}
