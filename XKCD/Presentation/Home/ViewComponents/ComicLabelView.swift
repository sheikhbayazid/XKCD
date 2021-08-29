//
//  ComicCellDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct ComicLabelView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true)]) var favorites: FetchedResults<Favorite>
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    @State private var isSheetShowing = false
    
    let comic: Comic
    
    var body: some View {
        
        VStack(spacing: 10) {
            horizontalButtons()
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    comicTitleAndAltView()
                    comicExplanationView()
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func horizontalButtons() -> some View {
        HStack {
            Button(action: openShareSheet) {
                Image(systemName: "square.and.arrow.up")
            }
            
            Spacer()
            
            Button(action: favouriteAction) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
        }
        .font(.title2)
    }
    
    @ViewBuilder
    private func comicTitleAndAltView() -> some View {
        Group {
            Text(comicTitle)
                .fontWeight(.medium)
            
            Text(comic.alt)
        }
    }
    
    @ViewBuilder
    private func comicExplanationView() -> some View {
        HStack(spacing: 5) {
            Text("Go to comic")
            Text("explanation")
                .underline(true, color: .yellow)
                .fontWeight(.medium)
                .onTapGesture(perform: showSheet)
        }
        .font(.subheadline)
        .padding(.top, 2)
        .fullScreenCover(isPresented: $isSheetShowing) {
            SafariView(url: comicURL)
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
    
    private var comicTitle: String {
        "#\(comic.num): " + comic.title
    }
    
    private var comicURL: URL {
        URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.num)")!
    }
    
    private func favouriteAction() {
        withAnimation(.spring()) {
            isFavorite.toggle()
            
            if isFavorite {
                addToFavorite()
            } else {
                deleteFromFavorite()
            }
        }
    }
    
    private func openShareSheet() {
        showSheet()
        shareSheet(for: [comic.img.loadUIImage()])
    }
    
    private func showSheet() {
        isSheetShowing = true
    }
    
    private func addToFavorite() {
        let comic = Favorite(context: moc)
        comic.num = Int16(self.comic.num)
        comic.title = self.comic.title
        comic.alt = self.comic.alt
        comic.transcript = self.comic.transcript
        comic.image = self.comic.img.loadImageData()
        
        save()
    }
    
    private func deleteFromFavorite() {
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

struct ComicLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ComicLabelView(comic: Comic.example)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
