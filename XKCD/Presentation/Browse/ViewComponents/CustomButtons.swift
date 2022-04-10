//
//  CustomButtons.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct CustomButtons: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title,
                                                     ascending: true)]) var favorites: FetchedResults<Favorite>
    
    let comic: ComicResponse
    var imageURL: String
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    
    var body: some View {
        HStack(spacing: 10) {
            
            Button(action: favouriteAction) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
            
            Button(action: openShareSheet) {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .font(.title2)
    }
    
    private func favouriteAction() {
        withAnimation(.spring()) {
            isFavorite.toggle()
            
            if isFavorite {
                addFavorite()
            } else {
                deleteFavorite()
            }
        }
    }
    
    private func openShareSheet() {
        self.isShareSheetShowing = true
        shareSheet(for: [imageURL.loadUIImage()])
    }
    
    private func addFavorite() {
        let comic = Favorite(context: moc)
        comic.num = Int16(self.comic.id)
        comic.title = self.comic.title
        comic.alt = self.comic.alt
        comic.transcript = self.comic.transcript
        comic.image = self.imageURL.loadImageData()
        
        save()
    }
    
    private func deleteFavorite() {
        if let lastAddedItem = favorites.last {
            moc.delete(lastAddedItem)
            save()
        }
    }
    
    private func save() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error saving favourite: \(error.localizedDescription)")
            }
        }
    }
}

struct CustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtons(comic: ComicResponse.example, imageURL: "")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
