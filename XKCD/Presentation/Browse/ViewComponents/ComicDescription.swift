//
//  ComicDescription.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct ComicDescription: View {
    @State private var isSafariShowing = false
    
    let comic: ComicResponse
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Text("Go to comic")
                
                Text("explanation")
                    .underline(true, color: .yellow)
                    .fontWeight(.medium)
                    .onTapGesture(perform: showSafari)
            }
            .font(.subheadline)
            .padding(.top, 2)
            .fullScreenCover(isPresented: $isSafariShowing) {
                SafariView(url: comicURL)
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
                                .fontWeight(.semibold)
                            
                            Text("\(comic.transcript)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
    
    private var comicURL: URL {
        URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.id)")!
    }
    
    private func showSafari() {
        self.isSafariShowing = true
    }
}

struct ComicDescription_Previews: PreviewProvider {
    static var previews: some View {
        ComicDescription(comic: ComicResponse.example)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
