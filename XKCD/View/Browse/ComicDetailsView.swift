//
//  ComicDetailsView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicDetailsView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true),]) var favorites: FetchedResults<Favorite>
    
    let comic: ComicResponse
    var imageURL = ""
    
    @State private var isSafariShowing = false
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    
    init(comic: ComicResponse) {
        self.comic = comic
        
        for image in comic.imgs {
            imageURL = image.sourceUrl
        }
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            
            AsyncImage(url: URL(string: imageURL)!, placeholder: {
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
                        Text("Transcript: \(comic.transcript)")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.top)
            
        }
        .padding()
        .navigationBarTitle(Text("\(comic.id): " + comic.title), displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack(spacing: 10) {
                    Button(action: {
                        withAnimation(.spring()) {
                            isFavorite.toggle()
                            
                            if isFavorite {
                                addFavorite()
                            } else {
                                deleteComic()
                            }
                        }
                        
                        //MARK: - Add Favorite Comic
                    }, label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                    })
                    Button(action: {
                        self.isShareSheetShowing = true
                        shareSheet(for: [imageURL.loadUIImage()])
                        
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                    })
                }
        )
        
        
    }
    
    
    
    private func addFavorite() {
        let comic = Favorite(context: moc)
        comic.num = Int16(self.comic.id)
        comic.title = self.comic.title
        comic.alt = self.comic.alt
        comic.transcript = self.comic.transcript
        comic.image = self.imageURL.loadImageData()
        
        print(favorites)
        
        if !self.favorites.contains(comic) {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print("Error saving favorite: \(error.localizedDescription)")
                }
            }
            
            print(favorites)
        }
    }
    
    private func deleteComic() {
        if let lastAddedItem = favorites.last {
            moc.delete(lastAddedItem)
            
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print("Error saving book: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

struct ComicDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComicDetailsView(comic: ComicResponse.example)
        }
    }
}
