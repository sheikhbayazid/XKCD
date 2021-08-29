//
//  FavoritesView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true)]) var favorites: FetchedResults<Favorite>
    
    @State var image: Data = .init(count: 0)
    
    var body: some View {
        NavigationView {
            VStack {
                navigationView()
                
                // Issue: List + navigationView in VStack:- Auto select issue when back from navigation link destination.
                // Fix: - Using only list in the navigation view solves the problem but limits custom navigation view
                
                if favorites.isEmpty {
                    emptyMessage()
                } else {
                    
                    List {
                        ForEach(favorites) { item in
                            NavigationLink(
                                destination: FavoriteDetailView(item: item),
                                label: {
                                    comicLabel(item: item)
                                }
                            )
                        }
                        .onDelete(perform: deleteComic)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private func comicLabel(item: FetchedResults<Favorite>.Element) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("#\(item.num): " + (item.title ?? ""))
                .font(.headline)
            
            Text(item.alt ?? "")
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func emptyMessage() -> some View {
        Group {
            Spacer()
            
            Text("Your favourite comics will show up here.")
                .fontWeight(.medium)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func navigationView() -> some View {
        HStack {
            Text("Favorites")
                .font(.custom("xkcd", size: 26))
            
            Spacer()
            
            EditButton()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func deleteComic(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let favorite = favorites[index]
                moc.delete(favorite)
            }
            
            save()
        }
    }
    
    private func save() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error saving book: \(error.localizedDescription)")
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
