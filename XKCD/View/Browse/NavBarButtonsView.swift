//
//  NavBarButtonsView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct NavBarButtonsView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true),]) var favorites: FetchedResults<Favorite>
    
    let comic: ComicResponse
    var imageURL: String
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Favorite button
            Button(action: {
                withAnimation(.spring()) {
                    isFavorite.toggle()
                    
                    if isFavorite {
                        addFavorite()
                    } else {
                        deleteFavorite()
                    }
                }
                
            }, label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title2)
            })
            
            // Share button
            Button(action: {
                self.isShareSheetShowing = true
                shareSheet(for: [imageURL.loadUIImage()])
                
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
            })
        }
    }
    
    
    private func addFavorite() {
        let comic = Favorite(context: moc)
        comic.num = Int16(self.comic.id)
        comic.title = self.comic.title
        comic.alt = self.comic.alt
        comic.transcript = self.comic.transcript
        comic.image = self.imageURL.loadImageData()
        
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error saving favorite: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteFavorite() {
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


struct NavBarButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarButtonsView(comic: ComicResponse.example, imageURL: "")
    }
}
