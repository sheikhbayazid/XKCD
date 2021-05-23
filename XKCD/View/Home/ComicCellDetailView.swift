//
//  ComicCellDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct ComicCellDetailView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true),]) var favorites: FetchedResults<Favorite>
    
    let comic: Comic
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    @State private var isSheetShowing = false
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                // Share Button
                Button(action: {
                    self.isShareSheetShowing = true
                    shareSheet(for: [comic.img.loadUIImage()])
                    
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                })
                
                Spacer()
                
                // Favorite Button
                Button(action: {
                    withAnimation(.spring()) {
                        isFavorite.toggle()
                        
                        if isFavorite {
                            addFavorite()
                        } else {
                            deleteComic()
                        }
                    }
                    
                }, label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                })
                
            }
            
            // Comic Details
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("#\(comic.num): " + comic.title)
                        .fontWeight(.medium)
                        .font(.subheadline)
                    
                    Text(comic.alt)
                        .font(.subheadline)
                    
                    HStack(spacing: 0) {
                        Text("Go to comic")
                        Text(" explanation")
                            .fontWeight(.medium)
                            .underline()
                            .onTapGesture {
                                self.isSheetShowing = true
                            }
                    }.padding(.top, 2)
                    .font(.subheadline)
                    .fullScreenCover(isPresented: $isSheetShowing) {
                        SafariView(url: URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.num)")!)
                            .ignoresSafeArea()
                            .preferredColorScheme(.dark)
                    }
                }
                
                Spacer()
                
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func addFavorite() {
        let comic = Favorite(context: moc)
        comic.num = Int16(self.comic.num)
        comic.title = self.comic.title
        comic.alt = self.comic.alt
        comic.transcript = self.comic.transcript
        comic.image = self.comic.img.loadImageData()
        
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error saving favorite: \(error.localizedDescription)")
            }
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


struct ComicCellDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComicCellDetailView(comic: Comic.example)
    }
}
