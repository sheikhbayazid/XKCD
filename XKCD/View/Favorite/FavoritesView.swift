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
            ZStack {
                VStack {
                    HeaderView()
                    Spacer()
                    
                    // Issue: List + HeaderView in VStack:- Auto select issue when back from navigation link destination.
                    // Fix: - Using only list in the navigation view solves the problem but limits custom header view
                    List {
                        ForEach(favorites) { item in
                            NavigationLink(
                                destination: FavoriteDetailView(item: item),
                                label: {
                                    FavoriteComicCellView(item: item)
                                }
                            )
                        }
                        .onDelete(perform: deleteComic)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top)
                }
                
                if favorites.isEmpty {
                    EmptyMessage()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // Delete comics by swipe function
    func deleteComic(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let favorite = favorites[index]
                moc.delete(favorite)
            }
            
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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView()
                .previewLayout(.sizeThatFits)
            
            EmptyMessage()
                .padding()
                .previewLayout(.sizeThatFits)
            
            FavoritesView()
        }
    }
}

fileprivate struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Favorites")
                .font(.custom("xkcd", size: 26))
            
            Spacer()
            
            EditButton()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct EmptyMessage: View {
    var body: some View {
        Text("You haven't added anything yet!")
            .fontWeight(.medium)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}
